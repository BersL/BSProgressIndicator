//
//  OuterBorder.h
//  ProgressIndicator
//
//  Created by Bers on 15/9/19.
//  Copyright © 2015年 Bers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSOuterBorder : UIView

@property (nonatomic) UIColor *loadingColor;
@property (nonatomic) UIColor *completeColor;

- (void)startAnimation;
- (void)startSecondPartAnimationWithDuration:(NSTimeInterval)duraiton;
- (void)stopAnimation;
- (void)changeColorToGray:(NSTimeInterval)timeInterval;
- (void)changeColorToBlue:(NSTimeInterval)timeInterval;
- (void)thinLineWidthWithDuration:(NSTimeInterval)duration;

- (void)reset;

@end
