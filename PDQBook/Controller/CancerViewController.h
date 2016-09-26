//
//  CancerViewController.h
//  PDQBook
//
//  Created by Mr.Chou on 16/7/18.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "SuperViewController.h"
//#import "Cancer.h"

@interface CancerViewController : SuperViewController

@property (nonatomic, strong) Cancer *cancer;


- (id)initWithCancer:(Cancer *)cancer;



@end
