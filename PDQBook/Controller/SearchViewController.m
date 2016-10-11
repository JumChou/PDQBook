//
//  SearchViewController.m
//  PDQBook
//
//  Created by Mr.Chou on 16/7/18.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "SearchViewController.h"
#import "CommonDefine.h"
#import "NBSearchView.h"
#import "RecentSearchRecords.h"
#import "RecentSearchRecordsView.h"
#import "SearchResultsView.h"
#import "SearchResults.h"
#import "SRCellHeightCache.h"
#import "CancerPaperViewController.h"
#import "JCSwitchLanguageBtn.h"
#import "DRNRealTimeBlurView.h"
#import "SRDictionaryContentView.h"
#import <VBFPopFlatButton/VBFPopFlatButton.h>

static const CGFloat kSwitchLanguageBtn_W = 60.f;
static const CGFloat kSwitchLanguageBtn_Padding = 50.f;
static const CGFloat kDicContentAnimation_Duration = 0.4f;
static const CGFloat kDicContentView_Top = 70.f;
static const CGFloat kDicContentView_Bottom = 90.f;
static const CGFloat kDicContentCloseBtn_Bottom = 30.f;
static const CGFloat kDicContentCloseBtn_W = 28.f;

@interface SearchViewController () <UITableViewDelegate, SRDictionaryCellDelegate, UIScrollViewDelegate>
{
    CGFloat DicContentView_LimitH;
}

@property (nonatomic, strong) NBSearchView *searchView;
@property (nonatomic, strong) RecentSearchRecordsView *recentSearchRecordsView;
@property (nonatomic, strong) SearchResultsView *searchResultsView;
@property (nonatomic, strong) UIButton *switchLanuageBtn;
@property (nonatomic, strong) UIImageView *screenSnapshotView;
@property (nonatomic, strong) UIImageView *cellSnapshotView;

@property (nonatomic, strong) DRNRealTimeBlurView *blurView;
@property (nonatomic, strong) VBFPopFlatButton *dicContentCloseBtn;
@property (nonatomic, strong) SRDictionaryContentView *dicContentView;
@property (nonatomic, assign) CGRect dicContentViewOriRect;

/// 最近搜索记录
@property (nonatomic, strong) RecentSearchRecords *recentSearchRecords;
/// 搜索结果
@property (nonatomic, strong) SearchResults *searchResults;
/// 所有cell的高度cache
@property (nonatomic, strong) NSMutableArray<SRCellHeightCache *> *cellHeightCacheAry;


@end

@implementation SearchViewController

#pragma mark - LifeCircle
- (id)init {
    self = [super init];
    if (self) {
        DicContentView_LimitH = (kScreenHeight - (kDicContentView_Top + kDicContentView_Bottom));
        
        [self initNaviSearchView];
        [self initBlurViewAndDicContentView];
        
        self.recentSearchRecords = [[RecentSearchRecords alloc] init];
        
        WeakSelf(ws);
        self.searchResults = [[SearchResults alloc] initWithConfigureCellBlock:^(UITableViewCell *cell, NSIndexPath *indexPath) {
            [ws configureCell:cell indexPath:indexPath];
        }];
        
        self.cellHeightCacheAry = [NSMutableArray array];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Color_LightGray;
    
    self.recentSearchRecordsView = [[RecentSearchRecordsView alloc] init];
    self.recentSearchRecordsView.tableView.dataSource = self.recentSearchRecords;
    self.recentSearchRecordsView.tableView.delegate = self;
    [self.view addSubview:self.recentSearchRecordsView];
    [self.recentSearchRecordsView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake((kStatusBarHeight+kNavBarHeight), 0, 0, 0));
    }];
    
    self.searchResultsView = [[SearchResultsView alloc] init];
    self.searchResultsView.tableView.dataSource = self.searchResults;
    self.searchResultsView.tableView.delegate = self;
    [self.view addSubview:self.searchResultsView];
    [self.searchResultsView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake((kStatusBarHeight+kNavBarHeight), 0, 0, 0));
    }];
    
    self.switchLanuageBtn = [JCSwitchLanguageBtn buttonWithStatus:SwitchLanguageBtnStatus_CN];
    [self.switchLanuageBtn addTarget:self action:@selector(switchLanuageBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.searchResultsView addSubview:self.switchLanuageBtn];
    [self.switchLanuageBtn makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.view).offset(-kSwitchLanguageBtn_Padding);
        make.bottom.equalTo(self.view).offset(-kSwitchLanguageBtn_Padding);
        make.width.equalTo(kSwitchLanguageBtn_W);
        make.height.equalTo(kSwitchLanguageBtn_W);
    }];
    #warning 隐藏语言切换btn
    self.switchLanuageBtn.alpha = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:self.searchView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.searchView removeFromSuperview];
}


#pragma mark - PrivateMethod
/**
 初始化NavigationBar的SearchView
 */
- (void)initNaviSearchView {
    WeakSelf(ws);
    self.searchView = [[NBSearchView alloc] initWithCloseHandler:^{
        [ws.searchResults cancelAllNetworkingTasks];
        [ws dismissViewControllerAnimated:YES completion:^{
            
        }];
    } inputingHandler:^(NSString *inputingText) {
        [ws searchInputingAction];
    } searchHandler:^(NSString *searchText) {
        [ws searchWithText:searchText];
    }];
    self.searchView.frame = CGRectMake(0, 0, kScreenWidth, kNavBarHeight);
}

/**
 初始化blurView
 */
- (void)initBlurViewAndDicContentView {
    self.blurView = [[DRNRealTimeBlurView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)
                                                     tintColor:nil
                                                       opacity:0.1
                                                  cornerRadius:0];
    self.blurView.alpha = 0;
    UITapGestureRecognizer *blurViewtapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeDictionaryContent)];
    [self.blurView addGestureRecognizer:blurViewtapGR];
    
    self.dicContentView = [[SRDictionaryContentView alloc] init];
//    self.dicContentView.clipsToBounds = YES;
//    self.dicContentView.layer.cornerRadius = kScreenWidth/50;
    self.dicContentView.layer.shadowOffset = CGSizeMake(10, 3);
    self.dicContentView.layer.shadowOpacity = 0.1f;
    self.dicContentView.layer.shadowRadius = 4;
    [self.blurView addSubview:self.dicContentView];
    
    self.dicContentCloseBtn = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(0, 0, kDicContentCloseBtn_W, kDicContentCloseBtn_W)
                                                           buttonType:buttonCloseType
                                                          buttonStyle:buttonRoundedStyle
                                                animateToInitialState:YES];
    self.dicContentCloseBtn.alpha = 0;
    self.dicContentCloseBtn.lineThickness = 2;
    self.dicContentCloseBtn.lineRadius = 2;
    self.dicContentCloseBtn.tintColor = [UIColor whiteColor];
    self.dicContentCloseBtn.roundBackgroundColor = [UIColor lightGrayColor];
//    self.dicContentCloseBtn.roundBackgroundColor = [UIColor colorWithHexString:@"d4d4d6"];
    self.dicContentCloseBtn.layer.shadowOffset = CGSizeMake(3, 3);
    self.dicContentCloseBtn.layer.shadowOpacity = 0.1f;
    self.dicContentCloseBtn.layer.shadowRadius = 4;
    [self.dicContentCloseBtn addTarget:self action:@selector(closeDictionaryContent) forControlEvents:UIControlEventTouchUpInside];
    [self.blurView addSubview:self.dicContentCloseBtn];
    [self.dicContentCloseBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.blurView);
        make.bottom.equalTo(self.blurView).offset(-kDicContentCloseBtn_Bottom);
        make.width.equalTo(kDicContentCloseBtn_W);
        make.height.equalTo(kDicContentCloseBtn_W);
    }];
}

/**
 Search输入操作
 */
- (void)searchInputingAction {
    self.recentSearchRecordsView.alpha = 1;
    [self.recentSearchRecordsView reloadViews];
    self.searchResultsView.alpha = 0;
}

/**
 搜索

 @param searchText 搜索的文本
 */
- (void)searchWithText:(NSString *)searchText {
    DebugLog(@"搜索词:%@", searchText);
    self.searchView.searchText.text = searchText;
    [self.searchView.searchText resignFirstResponder];
    self.recentSearchRecordsView.alpha = 0;
    [self.recentSearchRecords saveSearchRecordWithText:searchText];
    
    UCZProgressView *progressView = [[UCZProgressView alloc] initLoadingStyleWithIsUseArcAnim:NO];
    [self.view addSubview:progressView];
    [progressView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake((kStatusBarHeight+kNavBarHeight), 0, 0, 0));
    }];
    
    [self.searchResults HTTPRequestSearchWithText:searchText success:^{
        [self.cellHeightCacheAry removeAllObjects];
        [self.searchResultsView reloadViews];
        self.searchResultsView.alpha = 1;
        progressView.progress = 1;
        
    } failure:^(NSError *error) {
        [self.cellHeightCacheAry removeAllObjects];
        [self.searchResultsView reloadViews];
        self.searchResultsView.alpha = 1;
        progressView.progress = 1;
        
    }];
}

/**
 切换语言按钮事件
 */
- (void)switchLanuageBtnAction {
    if (self.searchResults.language == SRLanguage_CN) {
        self.searchResults.language = SRLanguage_EN;
        
    } else if (self.searchResults.language == SRLanguage_EN) {
        self.searchResults.language = SRLanguage_CN;
    }
    
    [self.cellHeightCacheAry removeAllObjects];
    [self.searchResultsView reloadViews];
}

#pragma mark 字典内容展示、关闭
/**
 展示字典内容

 @param cell      点击cell
 @param indexPath 点击cell的indexPath
 */
- (void)showDictionaryContentWithCell:(SRDictionaryCell *)cell indexPath:(NSIndexPath *)indexPath {
    self.blurView.renderStatic = NO;
    [[UIApplication sharedApplication].keyWindow addSubview:self.blurView];
    
    self.dicContentViewOriRect = [cell convertRect:cell.bounds toView:self.view]; // 获取OriRect
    [self.dicContentView configureWithData:[self.searchResults getDataWithIndexPath:indexPath]]; // 获取数据
    [self.dicContentView remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(CGRectGetMinY(self.dicContentViewOriRect));
        make.leading.equalTo(self.view).offset(CGRectGetMinX(self.dicContentViewOriRect));
        make.width.equalTo(CGRectGetWidth(self.dicContentViewOriRect));
        make.height.equalTo(CGRectGetHeight(self.dicContentViewOriRect));
    }];
    [self.dicContentView setNeedsLayout];
    [self.dicContentView layoutIfNeeded];
    
//    MASLayoutConstraint *
    [UIView animateWithDuration:0.2 animations:^{ // STEP_1
        self.blurView.alpha = 1;
        
    } completion:^(BOOL finished) {
        self.blurView.renderStatic = YES;
        
        [UIView animateWithDuration:kDicContentAnimation_Duration animations:^{ // STEP_2
            CGRect fullHeightRect = self.dicContentViewOriRect;
            fullHeightRect.size.height = DicContentView_LimitH;
            self.dicContentView.frame = fullHeightRect;
            
        } completion:^(BOOL finished) {
            
        }];
    
        [UIView animateWithDuration:kDicContentAnimation_Duration animations:^{
            [self.dicContentView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(DicContentView_LimitH);
            }];
            [self.dicContentView setNeedsLayout];
            [self.dicContentView layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            
        }];
    
        [UIView animateWithDuration:kDicContentAnimation_Duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.dicContentView updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view).offset(kDicContentView_Top);
            }];
            [self.blurView setNeedsLayout];
            [self.blurView layoutIfNeeded];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.4f animations:^{
                self.dicContentCloseBtn.alpha = 1.f;
            }];
            
        }];
    }];
}

/**
 关闭字典内容
 */
- (void)closeDictionaryContent {
    [UIView animateWithDuration:0.2f animations:^{
        self.dicContentCloseBtn.alpha = 0.f;
    }];
    
    [UIView animateWithDuration:kDicContentAnimation_Duration animations:^{ // STEP_1
        [self.dicContentView updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(CGRectGetMinY(self.dicContentViewOriRect));
        }];
        [self.blurView setNeedsLayout];
        [self.blurView layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
    }];
    
    dispatch_time_t executeTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC));
    dispatch_after(executeTime, dispatch_get_main_queue(), ^(void){
        [self.dicContentView.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                             atScrollPosition:UITableViewScrollPositionTop
                                                     animated:YES]; // 回到列表头部
        
        [UIView animateWithDuration:kDicContentAnimation_Duration animations:^{ // STEP_2
            self.dicContentView.frame = self.dicContentViewOriRect;
            
        } completion:^(BOOL finished) {
            
        }];
        
        [UIView animateWithDuration:kDicContentAnimation_Duration animations:^{
            [self.dicContentView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(CGRectGetHeight(self.dicContentViewOriRect));
            }];
            [self.dicContentView setNeedsLayout];
            [self.dicContentView layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{ // STEP_3
                self.blurView.alpha = 0;
            } completion:^(BOOL finished) {
                [self.blurView removeFromSuperview];
            }];
            
        }];
    });
}


#pragma mark - AboutTableView
/**
 处理最近搜索记录点击

 @param indexPath 点击的indexPath
 */
- (void)handleRecentSearchRecordDidSelectAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.recentSearchRecords.searchRecords.count) { // 清除搜索记录
        [self.recentSearchRecords clearSearchRecords];
        [self.recentSearchRecordsView reloadViews];
        
    } else {
        SearchRecord *searchRecord = [self.recentSearchRecords getSearchRecordWithIndexPath:indexPath];
        self.searchView.searchText.text = searchRecord.searchText;
        [self searchWithText:searchRecord.searchText];
    }
}

/**
 处理搜索结果点击
 
 @param indexPath 点击的indexPath
 */
- (void)handleSearchResultDidSelectAtIndexPath:(NSIndexPath *)indexPath {
    SRType resultType = [self.searchResults getDataSRTypeWithIndexPath:indexPath];
    if (resultType == SRType_Dictionary) {
        SRDictionaryCell *cell = [self.searchResultsView.tableView cellForRowAtIndexPath:indexPath];
        [self showDictionaryContentWithCell:cell indexPath:indexPath];
        
    } else if (resultType == SRType_Paper) {
        SearchResult *searchResult = [self.searchResults getDataWithIndexPath:indexPath];
        CancerPaperViewController *paperVC = [[CancerPaperViewController alloc] initWithPaperURL:searchResult.paperParaLanguageURL];
        paperVC.paperName = searchResult.title;
        paperVC.language = searchResult.language;
        [self.navigationController pushViewController:paperVC animated:YES];
    }
}


/**
 配置需展示的cell

 @param cell      需配置的cell
 @param indexPath indexPath
 */
- (void)configureCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[SRDictionaryCell class]]) {
        SRDictionaryCell *dicCell = (SRDictionaryCell *)cell;
        dicCell.delegate = self;
        NSArray *data = [self.searchResults getDataWithIndexPath:indexPath];
        SRCellHeightCache *cache = [self getCellHeightCacheWithIndexPath:indexPath];
        [dicCell setUpViewsWithData:data expandedState:cache.expandedState];
        
    } else if ([cell isKindOfClass:[SRPaperCell class]]) {
        SRPaperCell *paperCell = (SRPaperCell *)cell;
        SearchResult *searchResult = [self.searchResults getDataWithIndexPath:indexPath];
        [paperCell setUpViewsWithData:searchResult];
    }
}


#pragma mark - AboutExpand
/**
 根据indexPath获得缓存的cellHeightCache

 @param indexPath indexPath

 @return cellHeightCache
 */
- (SRCellHeightCache *)getCellHeightCacheWithIndexPath:(NSIndexPath *)indexPath {
    SRCellHeightCache *cellHeightCache;
    for (SRCellHeightCache *cache in self.cellHeightCacheAry) {
        if ([cache.indexPath isEqual:indexPath]) {
            cellHeightCache = cache;
            break;
        }
    }
    return cellHeightCache;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.recentSearchRecordsView.tableView) {
        return 44;
        
    } else if (tableView == self.searchResultsView.tableView) {
        SRCellHeightCache *cache = [self getCellHeightCacheWithIndexPath:indexPath];
        if (!cache || cache.isNeedNewValue) { // 不存在cache，或需要新值
            CGFloat fullH = 0.0;
            CGFloat limitH = 0.0;
            SRCellExpandedState expandedState = ExpandedState_NO;
            
            SRType type = [self.searchResults getDataSRTypeWithIndexPath:indexPath];
            if (type == SRType_Dictionary) {
                CGFloat contentH = [SRDictionaryCell calculateContentHeightWithData:[self.searchResults getDataWithIndexPath:indexPath]];
                limitH = [SRDictionaryCell limitHeight];
                if (contentH > limitH && [self.searchResults getDataCount] > 1) {
                    expandedState = ExpandedState_NO;
                } else {
                    expandedState = ExpandedState_None;
                }
                
                fullH = [SRDictionaryCell calculateFullHeightWithContentHeight:contentH
                                                                 expandedState:expandedState];
                
            } else if (type == SRType_Paper) {
                fullH = [SRPaperCell calculateFullHeightWithData:[self.searchResults getDataWithIndexPath:indexPath]];
                limitH = [SRPaperCell limitHeight];
                expandedState = ExpandedState_None;
                if (fullH > limitH) {
                    fullH = limitH;
                }
            }
            
            if (!cache) {
                cache = [[SRCellHeightCache alloc] initWithIndexPath:indexPath
                                                       expandedState:expandedState
                                                         limitHeight:limitH
                                                          fullHeight:fullH];
                [self.cellHeightCacheAry addObject:cache];
                
            } else if (cache.isNeedNewValue) {
                cache.limitHeight = limitH;
                cache.fullHeight = fullH;
                cache.isNeedNewValue = NO;
            }
        }
        return cache.height;
        
    } else {
        return 44;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView == self.searchResultsView.tableView) {
        return 10.f;
    } else {
        return 0.f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = Color_Clear;
    return view;
}

// 编辑选项控制
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (tableView == self.searchResultsView.tableView) {
//        if ([self.searchResults getDataSRTypeWithIndexPath:indexPath] == SRType_Dictionary) {
            return UITableViewCellEditingStyleDelete;
//        } else {
//            return UITableViewCellEditingStyleNone;
//        }
        
    } else {
        return UITableViewCellEditingStyleNone;
    }
}

// 自定义侧滑按钮
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (tableView == self.searchResultsView.tableView) {
        NSString *title;
        UIColor *bgColor;
        if ([self.searchResults getDataSRLanguageWithIndexPath:indexPath] == SRLanguage_CN) {
            title = @"英文";
            bgColor = SRDictionaryCell_Color_SwitchEN;
        } else {
            title = @"中文";
            bgColor = SRDictionaryCell_Color_SwitchCN;
        }
        
        UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:title handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            [self.searchResults switchDataSRLanguageWithIndexPath:indexPath];
            SRCellHeightCache *cache = [self getCellHeightCacheWithIndexPath:indexPath];
            cache.isNeedNewValue = YES;
            [tableView setEditing:NO animated:NO];
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
        action.backgroundColor = bgColor;
        
//        if ([self.searchResults getDataSRTypeWithIndexPath:indexPath] == SRType_Dictionary) {
            return @[action];
//        } else {
//            return nil;
//        }
        
    } else {
        return nil;
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    /* 【v1】
    if (tableView == self.searchResultsView.tableView) {
        if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[SRDictionaryCell class]]) {
            return NO;
        }
    }
     */
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DebugLog(@"%@:(%zd, %zd)", tableView, indexPath.section, indexPath.row);
    
    if (tableView == self.recentSearchRecordsView.tableView) { // 点击最近搜索记录
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self handleRecentSearchRecordDidSelectAtIndexPath:indexPath];
        
    } else if (tableView == self.searchResultsView.tableView) { // 点击搜索结果
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self handleSearchResultDidSelectAtIndexPath:indexPath];
        
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.recentSearchRecordsView.tableView) {
        [self.searchView.searchText resignFirstResponder];
    }
}


#pragma mark - SRDictionaryCellDelegate
- (void)expandBtnActionInCell:(SRDictionaryCell *)cell {
    NSIndexPath *indexPath = [self.searchResultsView.tableView indexPathForCell:cell];
    DebugLog(@"indexPath.row:%zd", indexPath.row);
    
    /* 【v1】
    SRCellHeightCache *cache = [self getCellHeightCacheWithIndexPath:indexPath];
    UITableViewRowAnimation animation = UITableViewRowAnimationAutomatic;
    
    if (cache.expandedState == ExpandedState_NO) {
        cache.expandedState = ExpandedState_Yes;
//        animation = UITableViewRowAnimationBottom;
        
    } else if (cache.expandedState == ExpandedState_Yes) {
        cache.expandedState = ExpandedState_NO;
//        animation = UITableViewRowAnimationTop;
        [self.searchResultsView.tableView scrollToRowAtIndexPath:indexPath
                                                atScrollPosition:UITableViewScrollPositionTop
                                                        animated:YES];
        
    } else {
        DebugLog(@"What!? 什么鬼！ExpandedState_None还能有expandBtnAction！！！？？？");
    }
    
    [self.searchResultsView.tableView beginUpdates];
    [self.searchResultsView.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
    [self.searchResultsView.tableView endUpdates];
    */
    
    [self showDictionaryContentWithCell:cell indexPath:indexPath];
    
    
    
//    UIImage *screenImage = [UIImage imageWithSnapshotScreen];
//    UIImage *cellImage = [UIImage imageWithSnapshotView:cell inRect:cell.bounds];
//
//    self.screenSnapshotView.image = [screenImage blurryImageWithBlurLevel:1];
//    self.screenSnapshotView.alpha = 1;
    
//    self.cellSnapshotView.frame = [cell convertRect:cell.bounds toView:self.view];
//    self.cellSnapshotView.backgroundColor = Color_Blue;
//    self.cellSnapshotView.image = cellImage;
//    self.cellSnapshotView.alpha = 1;
    
//    CATransform3D screenSnapshotPerspective = self.screenSnapshotView.layer.transform;
//    screenSnapshotPerspective.m34 = -(1.f/50.f);
//    CABasicAnimation *fartherAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
//    CATransform3D fartherTransform = CATransform3DTranslate(screenSnapshotPerspective, 0.f, 0.f, -5.f);
//    fartherAnimation.toValue = [NSValue valueWithCATransform3D:fartherTransform];
//    fartherAnimation.duration = 0.5;
//    fartherAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
//    fartherAnimation.fillMode = kCAFillModeForwards;
//    fartherAnimation.removedOnCompletion = NO;
//    [self.screenSnapshotView.layer addAnimation:fartherAnimation forKey:@"fartherAnimation"];
}






@end
