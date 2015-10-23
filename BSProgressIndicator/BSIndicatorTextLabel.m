//
//  BSIndicatorText.m
//  ProgressIndicator
//
//  Created by Bers on 15/9/24.
//  Copyright © 2015年 Bers. All rights reserved.
//

#import "BSIndicatorTextLabel.h"

@interface BSIndicatorTextLabel (){
    NSTimeInterval _animationPeriod;
    CGFloat _targetFactor, _currentFactor;
    NSUInteger _textLength;
    CGAffineTransform _origionTransform;
    int _flicker;
    void (^completionBlock)(void);
}

@property (nonatomic) UILabel *label;
@property (nonatomic) CADisplayLink *displayLink;
@property (nonatomic) CGFloat deltaPortion;
@property (nonatomic) NSUInteger curFrame;

@end

@implementation BSIndicatorTextLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.label = [[UILabel alloc] initWithFrame:CGRectInset(frame, frame.size.width * 0.1, frame.size.height * 0.1)];
        self.label.font = [UIFont fontWithName:@"Verdana" size:14];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.numberOfLines = 1;
        [self addSubview:self.label];
        self.text = @"Default";
        
        _animationPeriod = 0.5f;
        _currentFactor = 1.6f;
        _flicker = NO;
        completionBlock = nil;
    }
    return self;
}

- (void)enlargeTextWithFactor:(NSNumber*)factor toColor:(UIColor*)color{
    [self setAttributedText:self.text spacing:factor];
    [self.label setTextColor:color];
}

- (void)animateTextSpacingTo:(CGFloat)factor toColor:(UIColor*)color withDuration:(NSTimeInterval)duration{
    _flicker = NO;
    _targetFactor = factor;
    _animationPeriod = duration;
    if (!self.displayLink) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick)];
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [UIView animateWithDuration:_animationPeriod animations:^{
            self.label.textColor = color;
            CGFloat scale = factor > _currentFactor ? 1.1 : 1.0;
            self.label.transform = CGAffineTransformMakeScale(scale, scale);
        }];
    }
}

- (void)tick{
    if (_flicker == 2)
        --self.curFrame;
    else
        ++self.curFrame;
    [self setAttributedText:self.text
                    spacing:[NSNumber numberWithDouble:
                             self.deltaPortion * (_targetFactor - _currentFactor) + _currentFactor]];
}

- (void)flickerTextSpacingTo:(CGFloat)factor withDuration:(NSTimeInterval)duration completion:(void (^)(void))completion{
    _flicker = YES;
    _targetFactor = factor;
    _animationPeriod = duration/2;
    completionBlock = completion;
    if (!self.displayLink) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick)];
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [UIView animateWithDuration:_animationPeriod/2 animations:^{
            _origionTransform = self.label.transform;
            CGFloat scale = factor > _currentFactor ? 1.1 : 0.9;
            self.label.transform = CGAffineTransformMakeScale(scale, scale);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:_animationPeriod/2 animations:^{
                self.label.transform = _origionTransform;
            }];
        }];
    }
}

- (void)animateTextSpacingTo:(CGFloat)factor toColor:(UIColor*)color toText:(NSString*)text withDuration:(NSTimeInterval)duration{
    UIView *previousView = [self.label snapshotViewAfterScreenUpdates:NO];
    previousView.center = self.label.center;
    [self addSubview:previousView];
    _text = text;
    [self setAttributedText:_text spacing:[NSNumber numberWithDouble:factor]];
    self.label.transform = CGAffineTransformMakeScale(0.2, 0.2);
    [self setTextColor:color];
    self.label.alpha = 0.0;
    [UIView animateWithDuration:duration animations:^{
        
        CGFloat scale = factor > _currentFactor ? 1.1 : 1.0;
        self.label.transform = CGAffineTransformMakeScale(scale, scale);
        self.label.alpha = 1.0;
        
        previousView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        previousView.alpha = 0.0;

    }];
}

- (void)stopAnimation{
    [self.displayLink invalidate];
    _currentFactor = _targetFactor;
    _curFrame = 0;
    _flicker = 0;
    self.displayLink = nil;
    if (completionBlock) {
        completionBlock();
        completionBlock = nil;
    }
}

- (void)reset{
    completionBlock = nil;
    [self stopAnimation];
    _currentFactor = 1.6;
    self.label.transform = CGAffineTransformIdentity;
    self.label.textColor = self.defaultColor;
    [self setAttributedText:self.text spacing:@1.6];
}

- (void)setText:(NSString *)text{
    _text = [text copy];
    _textLength = [text length];
    [self setAttributedText:text spacing:@1.6];
}

- (void)setFontSize:(CGFloat)fontSize{
    self.label.font = [UIFont fontWithName:@"Verdana" size:fontSize];
}

- (void)setAttributedText:(NSString*)text spacing:(NSNumber*)value{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self.text];
    [attrStr addAttribute:NSKernAttributeName
                    value:value
                    range:NSMakeRange(0, _textLength)];
    [self.label setAttributedText:attrStr];
}

- (void)setTextColor:(UIColor *)textColor{
    self.label.textColor = textColor;
    if (!self.defaultColor) {
        self.defaultColor = textColor;
    }
}

- (void)setCurFrame:(NSUInteger)curFrame{
    _curFrame = curFrame;
    self.deltaPortion = (CGFloat)self.curFrame / (_animationPeriod * 60.0f);
    if (_curFrame <= 0 || _flicker == 2) {
        [self stopAnimation];
    }
    
    
    if (curFrame >= _animationPeriod*60.0f) {
        if (_flicker) {
            _curFrame = 0;
            CGFloat temp = _targetFactor;
            _targetFactor = _currentFactor;
            _currentFactor = temp;
            _flicker = 2;
        }else
            [self stopAnimation];
    }
}


@end
