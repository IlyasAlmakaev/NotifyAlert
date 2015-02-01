//
//  AGToastView.h
//  NotifyAlert
//
//  Created by intent on 01.02.15.
//  Copyright (c) 2015 intent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AGToastView : UIView

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UILabel *textLabel;

@property (assign, nonatomic) NSTimeInterval duration;
@property (assign, nonatomic) NSTimeInterval delay;

@property (assign, nonatomic) CGFloat textPadding;
@property (assign, nonatomic) CGFloat marginBottom;
@property (assign, nonatomic) CGFloat cornerRadius;
@property (assign, nonatomic) CGFloat backgroundAlpha;
@property (assign, nonatomic) CGFloat maxWidth;
@property (assign, nonatomic) CGFloat maxHeight;

// constants
#define DEFAULT_ALPHA      0.75f
#define DEFAULT_DURATION   1.0f
#define DEFAULT_DALAY      2.0f
#define DEFAULT_PADDING    15.0f
#define DEFAULT_MARGIN     350.0f
#define DEFAULT_RADIUS     5.0f

#define SCREEN_W ( CGRectGetWidth ([[UIScreen mainScreen] bounds]) )
#define SCREEN_H ( CGRectGetHeight ([[UIScreen mainScreen] bounds]) )

#define MAX_WIDTH ( SCREEN_W - 20 )
#define MAX_HEIGHT ( SCREEN_H / 4 )

// methods
- (void)showInView:(UIView *)view;
- (void)showInView:(UIView *)view withDelay:(NSTimeInterval)delay;


@end
