//
//  OuterBorder.m
//  ProgressIndicator
//
//  Created by Bers on 15/9/19.
//  Copyright © 2015年 Bers. All rights reserved.
//

#import "BSOuterBorder.h"

@interface BSOuterBorder () {
    NSUInteger _totalFrame;
    BOOL _stateFlag;
}

@property (nonatomic) CAShapeLayer *shapeLayer;
@property (nonatomic) CAShapeLayer *progressLayer;
@property (nonatomic) CADisplayLink *displayLink;
@property (nonatomic) CGFloat deltaPortion;
@property (nonatomic) NSUInteger curFrame;

@end

@implementation BSOuterBorder

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _deltaPortion = 0;
        _totalFrame = 60 * 0.3;
        _stateFlag = 0;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)startAnimation{
    if (!self.displayLink) {
        self.curFrame = 0;
        self.displayLink = [CADisplayLink displayLinkWithTarget:self
                                                       selector:@selector(tick)];
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
    }
}

- (void)startSecondPartAnimationWithDuration:(NSTimeInterval)duraiton{
    [self stopAnimation];
    _stateFlag = 1;
    [self setNeedsDisplay];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = [NSNumber numberWithDouble:0.0f];
    animation.toValue = [NSNumber numberWithDouble:1.0f];
    animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.7 :0.0 :0.2 :1.0];
    animation.duration = duraiton;
    animation.delegate = self;
    [self.progressLayer addAnimation:animation forKey:@"strokeEndAnimation"];
    self.progressLayer.strokeEnd = 1.0f;
}

- (void)stopAnimation{
    [self.displayLink invalidate];
    self.displayLink = nil;
}

- (void)tick{
    ++self.curFrame;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    
    CGFloat rOffset = self.bounds.size.width * 0.15 * self.deltaPortion;
    CGPoint rCenter = CGPointMake(self.bounds.size.width * 0.7 - rOffset, self.bounds.size.height / 2);

    if(!_stateFlag){
        CGPoint pointA = CGPointMake(self.bounds.size.width * 0.7 - (self.bounds.size.height / 2)*cos(self.deltaPortion*M_PI_2) - rOffset,
                                     self.bounds.size.height / 2 - (self.bounds.size.height / 2)*sin(self.deltaPortion*M_PI_2));
        CGPoint pointB = CGPointMake(self.bounds.size.width * 0.7 - rOffset, self.bounds.size.height);
        
        
        CGFloat lOfffset = self.bounds.size.width * 0.4 * self.deltaPortion - rOffset;
        CGPoint lCenter = CGPointMake(self.bounds.size.width * 0.3 + lOfffset,
                                      self.bounds.size.height / 3 * 2 - (self.bounds.size.height / 6)*self.deltaPortion);
        CGFloat lRadius = self.bounds.size.height / 3 + (self.bounds.size.height / 6)*self.deltaPortion;
        CGPoint pointC = CGPointMake(self.bounds.size.width * 0.3 + lOfffset,
                                     self.bounds.size.height);
        CGPoint pointD = CGPointMake(self.bounds.size.width * 0.3
                                     - lRadius * sin(M_PI/8*(1-self.deltaPortion)) + lOfffset,
                                     lCenter.y  - lRadius * cos(M_PI/8*(1-self.deltaPortion)));
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint:pointA];
        [bezierPath addArcWithCenter:rCenter radius:self.bounds.size.height / 2
                          startAngle:-M_PI+(M_PI_2)*self.deltaPortion endAngle:M_PI/2 clockwise:YES];
        [bezierPath moveToPoint:pointB];
        [bezierPath addLineToPoint:pointC];
        [bezierPath addArcWithCenter:lCenter radius:lRadius startAngle:M_PI/2
                            endAngle:-(M_PI/2+M_PI/8*(1-self.deltaPortion)) clockwise:YES];
        [bezierPath moveToPoint:pointD];
        CGPoint controlPoint = CGPointMake((pointA.x + pointD.x)/10*6, pointD.y - 5);
        [bezierPath addQuadCurveToPoint:pointA controlPoint:controlPoint];
        self.shapeLayer.lineWidth = 4.0f + 3.0f*self.deltaPortion;
        self.shapeLayer.path = bezierPath.CGPath;
    }else{
        UIBezierPath *bezierPath = [UIBezierPath
                                    bezierPathWithArcCenter:rCenter radius:self.bounds.size.height/2 startAngle:-M_PI/2 endAngle:M_PI/2*3 clockwise:YES];
        self.shapeLayer.path = bezierPath.CGPath;
        self.progressLayer.path = bezierPath.CGPath;
    }
}

- (void)changeColorToGray:(NSTimeInterval)timeInterval{
    self.shapeLayer.strokeColor = self.loadingColor.CGColor;
}

- (void)changeColorToBlue:(NSTimeInterval)timeInterval{
    self.shapeLayer.strokeColor = self.completeColor.CGColor;
}

- (void)thinLineWidthWithDuration:(NSTimeInterval)duration{
    self.shapeLayer.lineWidth = 4.0f;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
    animation.toValue = [NSNumber numberWithDouble:4.0f];
    animation.duration = duration;
    [self.progressLayer addAnimation:animation forKey:@"animation"];
    self.progressLayer.lineWidth = 4.0f;
}

- (void)reset{
    _stateFlag = 0;
    [self stopAnimation];
    [self.shapeLayer removeAllAnimations];
    self.shapeLayer.lineWidth = 4.0f;
    self.shapeLayer.strokeColor = self.loadingColor.CGColor;
    [self.progressLayer removeFromSuperlayer];
    _progressLayer = nil;
    self.curFrame = 0;
    [self setNeedsDisplay];
}

#pragma -mark Getters And Setters

- (CAShapeLayer*)shapeLayer{
    if (!_shapeLayer) {
        _shapeLayer = [[CAShapeLayer alloc] init];
        _shapeLayer.frame = self.bounds;
        _shapeLayer.lineWidth = 4.0f;
        _shapeLayer.backgroundColor = [UIColor clearColor].CGColor;
        _shapeLayer.strokeColor = self.loadingColor.CGColor;
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:_shapeLayer];
    }
    return _shapeLayer;
}

- (CAShapeLayer*)progressLayer{
    if (!_progressLayer) {
        _progressLayer = [[CAShapeLayer alloc] init];
        _progressLayer.frame = self.bounds;
        _progressLayer.lineWidth = 7.0f;
        _progressLayer.backgroundColor = [UIColor clearColor].CGColor;
        _progressLayer.strokeColor = self.completeColor.CGColor;
        _progressLayer.fillColor = [UIColor clearColor].CGColor;
        _progressLayer.strokeEnd = 0.f;
        [self.layer addSublayer:_progressLayer];

    }
    return _progressLayer;
}

- (void)setCurFrame:(NSUInteger)curFrame{
     _curFrame = curFrame;
    self.deltaPortion = (CGFloat)self.curFrame / (CGFloat)_totalFrame;
    if (curFrame == _totalFrame) {
        [self stopAnimation];
    }
}


@end
