//
//  UIBezierPath+CustomPath.m
//  ProgressIndicator
//
//  Created by Bers on 15/9/12.
//  Copyright (c) 2015年 Bers. All rights reserved.
//

#import "UIBezierPath+BSCustomPath.h"
#define SQR(X) ((X)*(X))
#define DISTANCE(X,Y) (sqrt(SQR((X).y - (Y).y) + SQR((X).x - (Y).x)))

@implementation UIBezierPath (BSCustomPath)

+ (UIBezierPath*)bezierPathWithRoundedCornerArrowLeft:(CGPoint)leftPoint
                                                 peak:(CGPoint)peakPoint
                                                right:(CGPoint)rightPoint
                                            lineWidth:(CGFloat)width{
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat cornerRadius = width/2;
    CGFloat leftSideLength = sqrt(SQR(peakPoint.y - leftPoint.y) + SQR(peakPoint.x - leftPoint.x));
    CGFloat sinAlpha = (leftPoint.y - peakPoint.y)/leftSideLength,
            cosAlpha = (peakPoint.x - leftPoint.x)/leftSideLength;
    CGFloat pointAX = leftPoint.x - cornerRadius * sinAlpha,
            pointAY = leftPoint.y - cornerRadius * cosAlpha;
    CGPoint pointA = CGPointMake(pointAX, pointAY);
    CGFloat pointA2X = leftPoint.x + cornerRadius * sinAlpha,
            pointA2Y = leftPoint.y + cornerRadius * cosAlpha;
    CGPoint pointA2 = CGPointMake(pointA2X, pointA2Y);
    
    CGFloat pointBY = peakPoint.y - cornerRadius / cosAlpha;
    CGPoint pointB = CGPointMake(peakPoint.x, pointBY);
    
    CGFloat rightSideLength = sqrt(SQR(peakPoint.y - rightPoint.y) + SQR(peakPoint.x - rightPoint.x));
    CGFloat sinBeta = (rightPoint.y - peakPoint.y)/rightSideLength,
            cosBeta = (rightPoint.x - peakPoint.x)/rightSideLength;
    CGFloat pointCX = rightPoint.x - cornerRadius * sinBeta,
            pointCY = rightPoint.y + cornerRadius * cosBeta;
    CGPoint pointC = CGPointMake(pointCX, pointCY);
    CGFloat pointC2X = rightPoint.x + cornerRadius * sinBeta,
            pointC2Y = rightPoint.y - cornerRadius * cosBeta;
    CGPoint pointC2 = CGPointMake(pointC2X, pointC2Y);
    
    CGFloat pointDX = pointB.x + 2*cornerRadius * sinBeta,
            pointDY = pointBY - 2*cornerRadius * cosBeta;
    CGPoint pointD = CGPointMake(pointDX, pointDY);
    
    CGFloat pointEX = pointB.x - 2*cornerRadius * sinAlpha,
            pointEY = pointBY - 2*cornerRadius * cosAlpha;
    CGPoint pointE = CGPointMake(pointEX, pointEY);
    
    //左边第一条边
    [path moveToPoint:pointE];
    [path addLineToPoint:pointA];

    //左下角圆弧
    [path addArcWithCenter:leftPoint radius:cornerRadius startAngle:acos(sinAlpha) endAngle:M_PI+acos(sinAlpha) clockwise:YES];
    //闭合路径
    [path addLineToPoint:pointA2];
    
    //左边第二条边
    [path addLineToPoint:pointB];
    //右边第一条边
    [path addLineToPoint:pointC];
    //右下角圆弧
    [path addArcWithCenter:rightPoint radius:cornerRadius startAngle:-acos(sinBeta) endAngle:M_PI-acos(sinBeta) clockwise:YES];
    //闭合路径
    [path addLineToPoint:pointC2];
    //右边第二条边
    [path addLineToPoint:pointD];
    //顶部弧
    //pointB.y -= 2*(pointBY - (pointEY + pointDY)/2);
    CGFloat radius = sqrt(SQR(pointD.y - pointB.y) + SQR(pointD.x - pointB.x));
    [path addArcWithCenter:pointB radius:radius startAngle:-acos(sinBeta) endAngle:M_PI+acos(sinBeta) clockwise:NO];
    //[path addQuadCurveToPoint:pointE controlPoint:pointB];
    
    return path;
}

@end
