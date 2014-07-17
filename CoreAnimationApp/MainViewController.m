//
//  MainViewController.m
//  CoreAnimationApp
//
//  Created by Kevin Almanza on 7/16/14.
//  Copyright (c) 2014 Kevin Almanza. All rights reserved.
//

#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface MainViewController ()

@property (nonatomic, weak) IBOutlet UIButton *eatMe;
@property (nonatomic, weak) IBOutlet UIButton *drinkMe;
@property (nonatomic, strong) CALayer *circleMask;
@property (nonatomic, strong) CALayer *blueLayer;
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.blueLayer = [CALayer layer];
    [self.blueLayer setFrame:self.view.bounds];
    [self.blueLayer setBackgroundColor:[UIColor purpleColor].CGColor];
    [self.blueLayer setDelegate:self];
    
    _circleMask = [CALayer layer];
    [_circleMask setContents:(id)[UIImage imageNamed:@"logo"].CGImage];
    [_circleMask setContentsScale:[UIScreen mainScreen].scale];
    [_circleMask setContentsGravity:kCAGravityResizeAspect];
    [_circleMask setFrame:CGRectMake(0, 0, 50, 50)];
    [_circleMask setPosition:self.blueLayer.position];
    
    [self.blueLayer setMask:_circleMask];
    
    [self.view.layer addSublayer:self.blueLayer];
    [self.view setBackgroundColor:[UIColor clearColor]];
//    [blueLayer display];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    CGContextSetLineWidth(ctx, 10.0f);
    CGContextSetStrokeColorWithColor(ctx, [UIColor orangeColor].CGColor);
    CGContextStrokeEllipseInRect(ctx, CGRectMake(5.0f, 5.0f, layer.bounds.size.width - 10.0f, layer.bounds.size.height - 10.0f));
}

- (IBAction)drinkMeAction:(id)sender
{
    [_circleMask removeAllAnimations];
    [self.blueLayer removeAllAnimations];
}

- (IBAction)eatMeAction:(id)sender
{
    
    CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    [keyframeAnimation setValues:@[[NSValue valueWithCATransform3D:CATransform3DScale(_circleMask.transform, 1, 1, 1)], [NSValue valueWithCATransform3D:CATransform3DScale(_circleMask.transform, .9, .9, 1)],[NSValue valueWithCATransform3D:CATransform3DScale(_circleMask.transform, .9, .9, 1)], [NSValue valueWithCATransform3D:CATransform3DScale(_circleMask.transform, 10, 10, 1)]]];
    [keyframeAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [keyframeAnimation setCalculationMode:kCAAnimationLinear];
    [keyframeAnimation setDuration:0.65];
    [keyframeAnimation setKeyTimes:@[@0.0, @0.15, @0.4, @1.0]];
    [keyframeAnimation setRemovedOnCompletion:NO];
    [keyframeAnimation setFillMode:kCAFillModeForwards];
    [_circleMask addAnimation:keyframeAnimation forKey:@"keysan"];
    
    
    CAKeyframeAnimation *keyframeAnimation2 = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    [keyframeAnimation2 setValues:@[@1,@1,@1,@0]];
    [keyframeAnimation2 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [keyframeAnimation2 setCalculationMode:kCAAnimationLinear];
    [keyframeAnimation2 setDuration:0.65];
    [keyframeAnimation2 setKeyTimes:@[@0.0, @0.15, @0.4, @1.0]];
    [keyframeAnimation2 setRemovedOnCompletion:NO];
    [keyframeAnimation2 setFillMode:kCAFillModeForwards];
    [_blueLayer addAnimation:keyframeAnimation2 forKey:@"keyop"];

    
//    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
//    [anim setToValue:[NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DMakeRotation(3.14, 0, 0, 1), 4, 4, 1)]];
//    [anim setRemovedOnCompletion:NO];
//    [anim setDuration:0.5];
//    [anim setAutoreverses:YES];
//    [anim setFillMode:kCAFillModeForwards];
//    [anim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//    [_circleMask addAnimation:anim forKey:@"anim"];
    
//    CABasicAnimation *anim2 = [CABasicAnimation animationWithKeyPath:@"transform"];
//    [anim2 setToValue:[NSValue valueWithCATransform3D:CATransform3DRotate(_circleMask.transform, 3.14, 0, 0, 1)]];
//    [anim2 setRemovedOnCompletion:NO];
//    [anim2 setDuration:0.5];
//    [anim2 setAutoreverses:NO];
//    [anim2 setFillMode:kCAFillModeForwards];
//    [_circleMask addAnimation:anim2 forKey:@"anim2"];
    
//    CABasicAnimation *alpha = [CABasicAnimation animationWithKeyPath:@"opacity"];
//    [alpha setFromValue:[NSNumber numberWithDouble:1.0]];
//    [alpha setToValue:[NSNumber numberWithDouble:0.0]];
//    [alpha setDuration:1.0];
//    [alpha setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
//    [alpha setRemovedOnCompletion:NO];
//    [alpha setAutoreverses:NO];
//    [alpha setFillMode:kCAFillModeForwards];
//    [self.blueLayer addAnimation:alpha forKey:@"alpha"];
}

@end
