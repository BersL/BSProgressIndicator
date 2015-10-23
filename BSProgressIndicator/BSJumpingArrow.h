//
//  JumpingArrow.h
//  ProgressIndicator
//
//  Created by Bers on 15/9/12.
//  Copyright (c) 2015年 Bers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSJumpingArrow : UIView

@property (nonatomic) UIColor *loadingColor;
@property (nonatomic) UIColor *completeColor;

- (instancetype)initWithFrame:(CGRect)frame animationPeriod:(NSTimeInterval)period lineWidth:(CGFloat)lineWidth;

- (void)startAnimation;
- (void)stopAnimation;
- (void)changeColorToGray:(NSTimeInterval)timeInterval;
- (void)changeColorToBlue:(NSTimeInterval)timeInterval;
- (void)rotateArrowWithDuration:(NSTimeInterval)duration;
- (void)rotateAndTransformWithDuration:(NSTimeInterval)duration;

- (void)reset;

@end
