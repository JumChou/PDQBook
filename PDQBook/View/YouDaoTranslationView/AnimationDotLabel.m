//
//  AnimationDotLabel2.m
//  DotAnimationDemo
//
//  Created by Mr.Jiang on 15/3/24.
//  Copyright (c) 2015年 JasonRyan. All rights reserved.
//

#import "AnimationDotLabel.h"

#define DotTextWidth 20     // "..." 的宽度

@interface AnimationDotLabel ()

@property (nonatomic, copy) NSString *originalText;

@end

@implementation AnimationDotLabel
{
    CADisplayLink *displayLink;
    NSArray *dots;
    NSUInteger currentTextIndex;    // 当前显示.的索引
}

-(instancetype)init {
    self = [super init];
    if (self) {
        [self initValues];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initValues];
    }
    return self;
}


- (void)initValues {
    currentTextIndex = 0;
    _animateInterval = 0.5f;
    _originalText = @"";
    self.textAlignment = NSTextAlignmentLeft;
    dots = [[NSArray alloc] initWithObjects:@"",@".",@"..",@"...", nil];
    
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateText)];
    displayLink.frameInterval = _animateInterval * 60;
    displayLink.paused = YES;
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    
}

- (void)updateText {
    if (self.animated) {  // 需要动画 则文字后面追加...
        super.text = [_originalText stringByAppendingString:[dots objectAtIndex:currentTextIndex++ % dots.count]];
    }
    else {
        super.text = _originalText;
    }
}

- (void)setText:(NSString *)text {
    displayLink.paused = YES;  // 先暂停动画
    super.text = text;
    self.originalText = text;
}

- (void)setAnimated:(BOOL)animated {
    _animated = animated;
    currentTextIndex = 0;   // 复位
    displayLink.paused = !animated;
    
    // 调整self的位置及大小
    CGRect frame = self.frame;
    CGSize size = [_originalText boundingRectWithSize:CGSizeMake(999, frame.size.height) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.font} context:nil].size;
    size.width = animated ? (size.width + DotTextWidth) : size.width;
    frame.size = size;
    frame.origin.x = (self.superview.frame.size.width - size.width) / 2;
    self.frame = frame;
}


- (void)invalidate {
    displayLink.paused = YES;
    [displayLink invalidate];
}

@end
