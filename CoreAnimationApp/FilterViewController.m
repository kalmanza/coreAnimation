//
//  MainViewController.m
//  CoreAnimationApp
//
//  Created by Kevin Almanza on 7/17/14.
//  Copyright (c) 2014 Kevin Almanza. All rights reserved.
//

#import "FilterViewController.h"
#import "FilterView.h"

@interface FilterViewController () <FilterViewDataSource>
{

}
@property (weak, nonatomic) IBOutlet FilterView *filView;
@property (nonatomic, copy) NSString *filterName;

@end

@implementation FilterViewController

- (id)initWithFilterName:(NSString *)filterName
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _filterName = filterName;
    }
    return self;
}

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
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [self setTitle:self.filterName];
    [_filView setDataSource:self];
    _filView._eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [_filView setContext:_filView._eaglContext];
    self.filView.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    self.filView.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    self.filView.drawableStencilFormat = GLKViewDrawableStencilFormat8;

    // Enable multisampling
    self.filView.drawableMultisample = GLKViewDrawableMultisample4X;
    _filView._ciContext = [CIContext contextWithEAGLContext:_filView._eaglContext];
    [_filView setupFilter];
    [_filView startTimer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CIFilter *)filterToDraw
{
    return [CIFilter filterWithName:self.filterName];
}

- (void)dealloc
{
    [_filView cleanup];
    _filView = nil;
}

@end
