//
//  BSProgressIndicator.h
//  ProgressIndicator
//
//  Created by Bers on 15/9/23.
//  Copyright © 2015年 Bers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSProgressIndicator : UIView

@property (nonatomic) NSString *loadingText;
@property (nonatomic) NSString *completeText;

@property (nonatomic) UIColor *loadingColor;
@property (nonatomic) UIColor *completeColor;

- (void)startLoading;
- (void)endLoading;
- (void)stopAndReset;

@end
