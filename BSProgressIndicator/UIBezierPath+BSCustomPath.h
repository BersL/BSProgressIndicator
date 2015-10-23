//
//  UIBezierPath+CustomPath.h
//  ProgressIndicator
//
//  Created by Bers on 15/9/12.
//  Copyright (c) 2015年 Bers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (BSCustomPath)

+ (UIBezierPath*)bezierPathWithRoundedCornerArrowLeft:(CGPoint)leftPoint
                                                 peak:(CGPoint)peakPoint
                                                right:(CGPoint)rightPoint
                                            lineWidth:(CGFloat)width;

@end
