//
//  JumpingArrow.m
//  ProgressIndicator
//
//  Created by Bers on 15/9/12.
//  Copyright (c) 2015年 Bers. All rights reserved.
//

#import "BSJumpingArrow.h"
#import "UIBezierPath+BSCustomPath.h"

@interface BSJumpingArrow () {
    CGFloat _maxDelta;
    CGFloat _lineWidth;
    NSTimeInterval _animationPeriod, _origionPeriod;
    BOOL _stateFlag;
    CGPoint _origionCenter;
}

@property (nonatomic) CADisplayLink *displayLink;
@property (nonatomic) CAShapeLayer *shapeLayer;
@property (nonatomic) CGFloat delta;
@property (nonatomic) NSMutableArray *deltaCache;
@property (nonatomic) NSUInteger curFrame;

@end

@implementation BSJumpingArrow

- (instancetype)initWithFrame:(CGRect)frame animationPeriod:(NSTimeInterval)period lineWidth:(CGFloat)lineWidth{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _maxDelta = lineWidth / 5;
        _delta = 0;
        _lineWidth = lineWidth;
        _stateFlag = 0;
        _animationPeriod = _origionPeriod = period;
        self.clipsToBounds = NO;
        _origionCenter = self.center;
    }
    return self;
}

- (void)startAnimation{
    if (!self.displayLink) {
        _animationPeriod = _origionPeriod;
        CAKeyframeAnimation *animation = [CAKeyframeAnimation
                                          animationWithKeyPath:@"position"];
        animation.duration = _animationPeriod/2;
        animation.repeatCount = 1e10f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        CGPoint position = [self.shapeLayer position];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:position];
        [path addLineToPoint:CGPointMake(position.x, position.y + 5*_maxDelta)];
        [path addLineToPoint:position];
        animation.path = path.CGPath;
        [self.shapeLayer addAnimation:animation forKey:@"positionAnimation"];
        
        self.displayLink = [CADisplayLink displayLinkWithTarget:self
                                                       selector:@selector(animationLoopTick)];
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
}

- (void)startTransfromAnimation{
    if (!self.displayLink) {
        _stateFlag = YES;
        self.displayLink = [CADisplayLink displayLinkWithTarget:self
                                                       selector:@selector(animationTick)];
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
}

- (void)stopAnimation{
    [self.displayLink invalidate];
    self.displayLink = nil;
    [self.shapeLayer removeAllAnimations];
    self.curFrame = 0;
    [self setNeedsDisplay];
}

- (void)animationLoopTick{
    ++self.curFrame;
    [self setNeedsDisplay];
}

- (void)animationTick{
    ++_curFrame;
    [self setNeedsDisplay];
    if (_curFrame >= (_animationPeriod*60.0f)) {
        [self.displayLink invalidate];
        self.displayLink = nil;
        [self.shapeLayer removeAllAnimations];
        self.shapeLayer.transform = CATransform3DMakeRotation(M_PI, 0.0, 0.0, 1.0);
    }
}

- (void)drawRect:(CGRect)rect{
    UIBezierPath *bezierPath;
    if (!_stateFlag) {
        CGFloat halfArrowHeight = self.shapeLayer.frame.size.height/2 - self.delta;
        bezierPath = [UIBezierPath bezierPathWithRoundedCornerArrowLeft:
                      CGPointMake(-self.delta, self.frame.size.height / 2 + halfArrowHeight)
                      peak:CGPointMake(self.shapeLayer.frame.size.width/2, self.shapeLayer.frame.size.height / 2 - halfArrowHeight)
                      right:CGPointMake(self.frame.size.width + self.delta, self.frame.size.height / 2 + halfArrowHeight)
                      lineWidth:_lineWidth];
    }else{
        CGFloat len = (CGFloat)self.curFrame / (_animationPeriod*60.0f) * self.shapeLayer.frame.size.height * 2.5;
        bezierPath = [UIBezierPath
                      bezierPathWithRoundedCornerArrowLeft:
                      CGPointMake(-len, self.frame.size.height + len)
                      peak:CGPointMake(self.shapeLayer.frame.size.width/2, 0)
                      right:CGPointMake(self.frame.size.width , self.frame.size.height)
                      lineWidth:_lineWidth];
    }
    self.shapeLayer.path = bezierPath.CGPath;
}

- (void)changeColorToGray:(NSTimeInterval)timeInterval{
    self.shapeLayer.fillColor = self.loadingColor.CGColor;
    self.shapeLayer.strokeColor = [UIColor colorWithWhite:0.3 alpha:0.1].CGColor;
}

- (void)changeColorToBlue:(NSTimeInterval)timeInterval{
    self.shapeLayer.fillColor = self.completeColor.CGColor;
    self.shapeLayer.strokeColor = self.completeColor.CGColor;
}

- (void)rotateArrowWithDuration:(NSTimeInterval)duration{
    [self stopAnimation];
    CAKeyframeAnimation *animtion = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    animtion.values = @[[NSNumber numberWithDouble:0.0],[NSNumber numberWithDouble:M_PI],[NSNumber numberWithDouble:M_PI*2]];
    animtion.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.7 :0.0 :0.2 :1.0];
    animtion.duration = duration;
    [self.shapeLayer addAnimation:animtion forKey:@"rotate"];
}

- (void)rotateAndTransformWithDuration:(NSTimeInterval)duration{
    _animationPeriod = duration;
    [self startTransfromAnimation];
    CABasicAnimation *animtion = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animtion.toValue = @(M_PI);
    animtion.duration = duration;
    animtion.removedOnCompletion = NO;
    animtion.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.7 :0.0 :0.2 :1.0];
    animtion.fillMode = kCAFillModeForwards;
    
    [self changeColorToBlue:duration*2];
    [UIView animateWithDuration:duration animations:^{
        CGPoint center = self.center;
        center.x -= self.frame.size.width * 0.2;
        center.y -= self.frame.size.height * 0.3;
        self.center = center;
        self.transform = CGAffineTransformMakeScale(0.9, 0.9);
        self.transform = CGAffineTransformRotate(self.transform, -M_PI/22);
    }];
    [self.shapeLayer addAnimation:animtion forKey:@"halfRotate"];
}

- (void)reset{
    _stateFlag = 0;
    [self stopAnimation];
    _animationPeriod = _origionPeriod;
    self.center = _origionCenter;
    self.shapeLayer.strokeColor = [UIColor colorWithWhite:0.3 alpha:0.1].CGColor;
    self.shapeLayer.fillColor = self.loadingColor.CGColor;
    self.transform = CGAffineTransformIdentity;
    [self.shapeLayer removeAllAnimations];
    self.shapeLayer.transform = CATransform3DIdentity;
}

#pragma -mark Getters And Setters
- (CAShapeLayer*)shapeLayer{
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        [_shapeLayer setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _shapeLayer.strokeColor = [UIColor colorWithWhite:0.3 alpha:0.1].CGColor;
        _shapeLayer.lineWidth = 1.0f;
        _shapeLayer.backgroundColor = [UIColor clearColor].CGColor;
        _shapeLayer.fillColor = self.loadingColor.CGColor;
        [self.layer addSublayer:_shapeLayer];
    }
    return _shapeLayer;
}


- (void)setCurFrame:(NSUInteger)curFrame{
    _curFrame = curFrame;
    if (curFrame >= (NSUInteger)(_animationPeriod*60.0f)) {
        curFrame -= (NSUInteger)(_animationPeriod*60.0f);
    }
    self.delta = _maxDelta * fabs(sin(2*M_PI / (_animationPeriod*60.0f) * curFrame));
}


@end
