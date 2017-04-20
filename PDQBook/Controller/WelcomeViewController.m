//
//  WelcomeViewController.m
//  PDQBook
//
//  Created by Mr.Chou on 2017/4/19.
//  Copyright © 2017年 weihaisi. All rights reserved.
//

#import "WelcomeViewController.h"
#import "MainViewController.h"

static const CGFloat kEnterBtn_H = 50.f;

@interface WelcomeViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *scrollContentView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIButton *enterBtn;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"B8C9E1"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
    
    self.scrollContentView = [UIView new];
    [self.scrollView addSubview:self.scrollContentView];
    [self.scrollContentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];
    
    UIView *lastView;
    for (NSInteger i = 0; i < 3; i++) {
        NSString *imageName = [NSString stringWithFormat:@"Welcome%@_%zd", iPhone4 ? @"_iPhone4" : @"", i + 1];
        UIImage *image = [UIImage imageNamed:imageName];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [self.scrollContentView addSubview:imageView];
        [imageView makeConstraints:^(MASConstraintMaker *make) {
            if (!lastView) {
                make.leading.equalTo(self.scrollContentView);
            } else {
                make.leading.equalTo(lastView.trailing);
            }
            make.top.bottom.width.equalTo(self.scrollView);
        }];
        lastView = imageView;
    }
    
    [self.scrollContentView remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
        make.trailing.equalTo(lastView);
    }];
    
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.numberOfPages = 3;
    self.pageControl.currentPage = 0;
    [self.view addSubview:self.pageControl];
    [self.pageControl makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.height.equalTo(50.f);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-0.f);
    }];
    
    self.enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.enterBtn.alpha = 0.7;
    [self.enterBtn setBackgroundColor:Color_Navy];
    [self.enterBtn setTitle:@"立即进入" forState:UIControlStateNormal];
    [self.enterBtn setTitleColor:Color_White forState:UIControlStateNormal];
    [self.enterBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    self.enterBtn.titleLabel.font = [UIFont systemFontOfSize:19.f];
    [self.enterBtn addTarget:self action:@selector(enterBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.enterBtn];
    [self.enterBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.equalTo(self.view);
        make.height.equalTo(kEnterBtn_H);
        make.top.equalTo(self.view.bottom);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Method
- (void)showEnterBtn {
    [self.enterBtn updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.bottom).offset(-kEnterBtn_H);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)hideEnterBtn {
    [self.enterBtn updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.bottom);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}


#pragma mark - EventAction
- (void)enterBtnAction {
    DebugLog(@"");
    [self.navigationController pushViewController:[MainViewController new] animated:YES];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:UD_IsAppHaveLaunched];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    CGFloat pageWidth = scrollView.frame.size.width;
//    int pageIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
//    DebugLog(@"%zd", pageIndex);
//    self.pageControl.currentPage = pageIndex;
//    
//    if (pageIndex == 2) {
//        [self showEnterBtn];
//    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pageWidth = scrollView.frame.size.width;
    int pageIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
//    DebugLog(@"%zd", pageIndex);
    self.pageControl.currentPage = pageIndex;
    
    if (pageIndex == 2) {
        [self showEnterBtn];
    } else {
        [self hideEnterBtn];
    }
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
