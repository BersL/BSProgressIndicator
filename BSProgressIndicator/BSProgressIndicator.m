//
//  BSProgressIndicator.m
//  ProgressIndicator
//
//  Created by Bers on 15/9/23.
//  Copyright © 2015年 Bers. All rights reserved.
//

#import "BSProgressIndicator.h"
#import "BSJumpingArrow.h"
#import "BSOuterBorder.h"
#import "BSIndicatorTextLabel.h"

@interface BSProgressIndicator (){
    BOOL _animating, _reseting;
}

@property (nonatomic) BSJumpingArrow *jumpingArrow;
@property (nonatomic) BSOuterBorder *border;
@property (nonatomic) BSIndicatorTextLabel *textLabel;

@end

@implementation BSProgressIndicator

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commitInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commitInit];
    }
    return self;
}

- (void)commitInit{
    _animating = NO;
    _reseting = NO;
    self.loadingColor = [UIColor colorWithWhite:0.3 alpha:0.3];
    self.completeColor = [UIColor colorWithRed:68.0/255.0 green:177.0/255.0 blue:247.0/255.0 alpha:1.0f];
    self.loadingText = @"Loading";
    self.completeText = @"Complete";
}

- (void)startLoading{
    if (!_animating) {
        [self.jumpingArrow startAnimation];
        _animating = YES;
    }
}

- (void)endLoading{
    if (_animating) {
        //progress1
        [self.jumpingArrow changeColorToBlue:0.5];
        [self.border changeColorToBlue:0.5];
        [self.textLabel animateTextSpacingTo:2.4f toColor:self.completeColor withDuration:0.5];
        //progress2
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (_animating) {
                [self.textLabel flickerTextSpacingTo:1.6f withDuration:0.5 completion:^{
                    //progress3
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.border startAnimation];
                        [self.jumpingArrow changeColorToGray:0.4];
                        [self.border changeColorToGray:0.4];
                        [self.jumpingArrow rotateArrowWithDuration:1.8f];
                        [self.textLabel animateTextSpacingTo:1.6f toColor:self.loadingColor withDuration:0.4];
                        [UIView animateWithDuration:0.4 animations:^{
                            CGPoint center = self.jumpingArrow.center;
                            center.x -= 0.15*self.border.frame.size.width;
                            self.jumpingArrow.center = center;
                        } completion:^(BOOL finished) {
                            if(_animating){
                                [self.border startSecondPartAnimationWithDuration:1.0f];
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    if (_animating) {
                                        [self.border thinLineWidthWithDuration:0.6f];
                                        [self.jumpingArrow rotateAndTransformWithDuration:0.6f];
                                        [self.textLabel animateTextSpacingTo:2.2f toColor:self.completeColor toText:self.completeText withDuration:0.4f];
                                        _animating = NO;
                                    }
                                });
                            }
                        }];
                    });
                    
                }];
                
            }
        });
        
    }
}


- (void)stopAndReset{
    if (!_reseting) {
        _animating = NO;
        _reseting = YES;
        [self.border reset];
        [self.jumpingArrow reset];
        [self.textLabel reset];
        _reseting = NO;
        [self.textLabel setText:self.loadingText];
    }
}

- (void)didMoveToSuperview{
    [self border];
    [self jumpingArrow];
    [self textLabel];
}

#pragma -mark Getters And Setters
- (BSJumpingArrow*)jumpingArrow{
    if (!_jumpingArrow) {
        _jumpingArrow = [[BSJumpingArrow alloc] initWithFrame:
                         CGRectMake(self.frame.size.width*0.61, self.frame.size.height*0.36,
                                    self.frame.size.width*0.14, self.frame.size.height*0.03)
                                            animationPeriod:2.5f lineWidth:6.0f];
        [_jumpingArrow setCompleteColor:self.completeColor];
        [_jumpingArrow setLoadingColor:self.loadingColor];
        [self addSubview:_jumpingArrow];
    }
    return _jumpingArrow;
}

- (BSOuterBorder*)border{
    if (!_border) {
        _border = [[BSOuterBorder alloc] initWithFrame:
                   CGRectMake(-10.0, 8.0, self.frame.size.width + 10.0 , self.frame.size.height * 0.7 - 16.0)];
        [_border setCompleteColor:self.completeColor];
        [_border setLoadingColor:self.loadingColor];
        [self addSubview:_border];
    }
    return _border;
}

- (BSIndicatorTextLabel*)textLabel{
    if (!_textLabel) {
        _textLabel = [[BSIndicatorTextLabel alloc] initWithFrame:
                      CGRectMake(0, 0, self.frame.size.width * 1 , self.frame.size.height * 0.26)];
        _textLabel.center = CGPointMake(self.frame.size.width * 0.515, self.frame.size.height * 0.74);
        [_textLabel setText:self.loadingText];
        [_textLabel setTextColor:[UIColor colorWithWhite:0.3 alpha:0.5]];
        [self addSubview:_textLabel];
    }
    return _textLabel;
}

- (void)setCompleteColor:(UIColor *)completeColor{
    _completeColor = completeColor;
    [_jumpingArrow setCompleteColor:self.completeColor];
    [_jumpingArrow setLoadingColor:self.loadingColor];
    [_border setCompleteColor:self.completeColor];
    [_border setLoadingColor:self.loadingColor];
}

@end
