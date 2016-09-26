//
//  CancerPaperViewController.h
//  PDQBook
//
//  Created by Mr.Chou on 16/8/4.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "SuperViewController.h"
#import "SearchResult.h"

@interface CancerPaperViewController : SuperViewController

/// 文章名
@property (nonatomic, strong) NSString *paperName;
/// 文章URL
@property (nonatomic, strong) NSString *paperURL;

@property (nonatomic, assign) SRLanguage language;


- (id)initWithPaperURL:(NSString *)paperURL;

@end
