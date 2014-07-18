//
//  blurView.m
//  CoreAnimationApp
//
//  Created by Kevin Almanza on 7/18/14.
//  Copyright (c) 2014 Kevin Almanza. All rights reserved.
//

#import "blurView.h"

@interface blurView ()
{
    CIImage *inputImage;
    CIFilter *filter;
    CIContext *context;
    CAEAGLLayer *ealayer;
}
@end

@implementation blurView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib
{
    inputImage = [CIImage imageWithCGImage:[UIImage imageNamed:@"toast"].CGImage];
    NSTimer *timer;
    timer = [NSTimer scheduledTimerWithTimeInterval: 1.0/60.0
                                             target: self
                                           selector: @selector(timerFired:)
                                           userInfo: nil
                                            repeats: YES];
    [[NSRunLoop currentRunLoop] addTimer: timer
                                 forMode: NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] addTimer: timer
                                 forMode: UITrackingRunLoopMode];
    filter = [CIFilter filterWithName:@"CILightTunnel"];
    [filter setValue:@0 forKey:kCIInputRadiusKey];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    CIVector *center = [CIVector vectorWithCGPoint:CGPointMake(200, 200)];
    [filter setValue:center forKey:kCIInputCenterKey];
}

- (void)timerFired:(id)something
{
    int radius = [[filter valueForKey:kCIInputRadiusKey] integerValue];
    static BOOL increase = YES;
    
    if (increase) {
        radius+=1;
    } else {
        radius-=1;
    }
    if (radius > 200) {
        increase = NO;
    }
    if (radius < 2) {
        increase = YES;
    }
    [filter setValue:[NSNumber numberWithInteger:radius] forKey:kCIInputRadiusKey];
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGRect newrect = CGRectMake(0, 0, rect.size.width*2, rect.size.height*2);
    if (!context) {
        context = [CIContext contextWithEAGLContext:[EAGLContext currentContext]];
    }
    [context drawImage:[filter valueForKey:kCIOutputImageKey] inRect:newrect fromRect:newrect];
}

@end
