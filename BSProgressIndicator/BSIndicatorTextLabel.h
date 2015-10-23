//
//  BSIndicatorText.h
//  ProgressIndicator
//
//  Created by Bers on 15/9/24.
//  Copyright © 2015年 Bers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSIndicatorTextLabel : UIView

@property (nonatomic, copy) NSString *text;
@property (nonatomic) UIColor *defaultColor;

- (void)setTextColor:(UIColor*)textColor;
- (void)setFontSize:(CGFloat)fontSize;
- (void)enlargeTextWithFactor:(NSNumber*)factor toColor:(UIColor*)color;
- (void)animateTextSpacingTo:(CGFloat)factor toColor:(UIColor*)color withDuration:(NSTimeInterval)duration;
- (void)animateTextSpacingTo:(CGFloat)factor toColor:(UIColor*)color toText:(NSString*)text withDuration:(NSTimeInterval)duration;
- (void)flickerTextSpacingTo:(CGFloat)factor withDuration:(NSTimeInterval)duration completion:(void (^)(void))completion;

- (void)reset;

@end
