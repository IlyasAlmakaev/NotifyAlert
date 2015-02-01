//
//  AGToastView.m
//  NotifyAlert
//
//  Created by intent on 01.02.15.
//  Copyright (c) 2015 intent. All rights reserved.
//

#import "AGToastView.h"
#import <QuartzCore/QuartzCore.h>

@implementation AGToastView

@synthesize backgroundView, textLabel;
@synthesize backgroundAlpha, duration, delay;
@synthesize textPadding, marginBottom, cornerRadius;
@synthesize maxWidth, maxHeight;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // Hidden
        self.alpha = 0;
        
        // Setup defaults
        backgroundAlpha = DEFAULT_ALPHA;
        duration        = DEFAULT_DURATION;
        delay           = DEFAULT_DALAY;
        textPadding     = DEFAULT_PADDING;
        cornerRadius    = DEFAULT_RADIUS;
        marginBottom    = DEFAULT_MARGIN;
        maxWidth        = MAX_WIDTH;
        maxHeight       = MAX_HEIGHT;
        
        //
        backgroundView = [[UIView alloc] init];
        backgroundView.backgroundColor =    [UIColor blackColor];
        backgroundView.layer.cornerRadius = cornerRadius;
        backgroundView.layer.shadowColor =  [UIColor blackColor].CGColor;
        backgroundView.layer.shadowOpacity = 0.5;
        backgroundView.layer.shadowOffset =  CGSizeMake(0, 1);
        backgroundView.layer.shadowRadius =  5;
        
        //
        textLabel = [[UILabel alloc] init];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textColor       = [UIColor whiteColor];
        textLabel.numberOfLines   = 0;
        textLabel.textAlignment   = NSTextAlignmentCenter;
        textLabel.shadowOffset    = CGSizeMake(0, -1);
        textLabel.shadowColor     = [UIColor colorWithWhite:0 alpha:0.5];
        textLabel.font            = [UIFont systemFontOfSize:14];
        
        [self addSubview:backgroundView];
        [self addSubview:textLabel];
    }
    return self;
}

// position
- (void)layoutSubviews
{
    
    [super layoutSubviews];
    
    if (!textLabel.text) return;
    
    CGSize size = [textLabel.text sizeWithFont:textLabel.font constrainedToSize:CGSizeMake(maxWidth - textPadding * 2, MAXFLOAT)];
    
    CGRect frame = CGRectMake(0, 0, maxWidth - textPadding *2, maxHeight - textPadding * 2);
    
    frame.size.height = size.height > maxHeight - textPadding * 2 ? maxHeight - textPadding * 2 : size.height;
    frame.size.width = size.width > maxWidth - textPadding * 2 ? maxWidth - textPadding * 2 : size.width;
    
    textLabel.frame = frame;
    backgroundView.frame = CGRectInset(frame, -textPadding, -textPadding);
    
    CGRect shadowRect = CGRectMake(0, 0, CGRectGetWidth(backgroundView.frame), CGRectGetHeight(backgroundView.frame));
    
    backgroundView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:shadowRect cornerRadius:cornerRadius].CGPath;
    
    backgroundView.alpha = backgroundAlpha;
    
    CGPoint center = CGPointMake(SCREEN_W / 2, SCREEN_H - CGRectGetHeight(backgroundView.frame)/2 - 20 /* status bar */ - marginBottom);
    textLabel.center = center;
    backgroundView.center = center;
}

// animation
- (void)showInView:(UIView *)view withDelay:(NSTimeInterval)newDelay
{
    if (newDelay < 0) newDelay = delay;
    
    // add on display
    [view addSubview:self];
    
    // reduce transparency, show presentation
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^() { self.alpha = 1.0f; } completion:^(BOOL finished) {
        
        // increase transparency, remove presentation
        if (finished) {
            [UIView animateWithDuration:duration delay:newDelay options:UIViewAnimationOptionCurveEaseOut animations:^() { self.alpha = 0; } completion:^(BOOL finished) { [self removeFromSuperview]; }];
        }
        
    }];
    
}

- (void)showInView:(UIView *)view
{
    [self showInView:view withDelay:delay];
}


@end
