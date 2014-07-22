//
//  MainViewController.m
//  CoreAnimationApp
//
//  Created by Kevin Almanza on 7/17/14.
//  Copyright (c) 2014 Kevin Almanza. All rights reserved.
//

#import "FilterViewController.h"
#import "FilterView.h"

@interface FilterViewController ()
{
    EAGLContext *context;
}
@property (weak, nonatomic) IBOutlet FilterView *filView;
@property (nonatomic, strong) NSMutableArray *imgArray;

@end

@implementation FilterViewController

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
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [self.filView setContext:context];
    
    self.filView.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    self.filView.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    self.filView.drawableStencilFormat = GLKViewDrawableStencilFormat8;
    
    // Enable multisampling
    self.filView.drawableMultisample = GLKViewDrawableMultisample4X;
}

- (void)timerFired:(id)something
{
    [self.view setNeedsDisplay];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
