//
//  blurView.m
//  CoreAnimationApp
//
//  Created by Kevin Almanza on 7/18/14.
//  Copyright (c) 2014 Kevin Almanza. All rights reserved.
//

#import "FilterView.h"

@interface FilterView ()
{
    CIImage *inputImage;
    CIFilter *filter;
    NSTimer *timer;
}
@end

@implementation FilterView

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
}

- (void)setupFilter
{
    filter = [self.dataSource filterToDraw];
    [filter setValue:inputImage forKey:kCIInputImageKey];
}

- (void)startTimer
{
//    __weak FilterView *weakSelf = self;
//    timer = [NSTimer scheduledTimerWithTimeInterval: 1.0/60.0
//                                             target: weakSelf
//                                           selector: @selector(timerFired:)
//                                           userInfo: nil
//                                            repeats: YES];
//    [[NSRunLoop currentRunLoop] addTimer: timer
//                                 forMode: NSDefaultRunLoopMode];
//    [[NSRunLoop currentRunLoop] addTimer: timer
//                                 forMode: UITrackingRunLoopMode];
}

- (void)timerFired:(id)something
{
    [self setNeedsDisplay];
}

- (void)cleanup
{
    [timer invalidate];
    timer = nil;
    inputImage = nil;
    filter = nil;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGRect newrect = CGRectMake(0, 0, rect.size.width*2, rect.size.height*2);
    [__ciContext drawImage:[filter valueForKey:kCIOutputImageKey] inRect:newrect fromRect:inputImage.extent];
}

@end
