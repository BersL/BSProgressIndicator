//
//  ViewController.m
//  ProgressIndicator
//
//  Created by Bers on 15/9/12.
//  Copyright (c) 2015年 Bers. All rights reserved.
//

#import "ViewController.h"
#import "BSProgressIndicator.h"

@interface ViewController (){
    BOOL animating;
}

@property (nonatomic) BSProgressIndicator *indicator;

@end

@implementation ViewController
- (IBAction)handleTap:(UITapGestureRecognizer *)sender {
    if (animating) {
        [self.indicator stopAndReset];
        animating = NO;
    }else{
        [self.indicator startLoading];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.indicator endLoading];
        });
        animating = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.indicator = [[BSProgressIndicator alloc] initWithFrame:CGRectMake(180, 350 - 8, 125, 121)];
    self.indicator.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.indicator];
    
    animating = NO;
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
