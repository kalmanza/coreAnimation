//
//  MainViewController.m
//  CoreAnimationApp
//
//  Created by Kevin Almanza on 7/17/14.
//  Copyright (c) 2014 Kevin Almanza. All rights reserved.
//

#import "FilterViewController.h"
#import "FilterView.h"

@interface FilterViewController () <FilterViewDataSource, UITableViewDataSource, UITableViewDelegate>
{
    NSDictionary *_dictAttributes;
    NSArray *_arrayInputKeys;
}
@property (weak, nonatomic) IBOutlet FilterView *filView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSString *filterName;
@property (nonatomic, weak) CIFilter *filter;

@end

@implementation FilterViewController

- (CIFilter *)filter
{
    if (!_filter) {
         _filter = [CIFilter filterWithName:self.filterName];
    }
    return _filter;
}

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
    [self.tableView setAllowsSelection:NO];
    _dictAttributes = self.filter.attributes;
    _arrayInputKeys = self.filter.inputKeys;
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

- (void)sliderChanged:(UISlider *)slider
{
    [_filter setValue:@(slider.value) forKey:_arrayInputKeys[slider.tag]];
    [self.filView setNeedsDisplay];
}

- (CIFilter *)filterToDraw
{
    return self.filter;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayInputKeys.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 280, 30)];
    [lable setText:_arrayInputKeys[indexPath.row]];
    [cell.contentView addSubview:lable];
    
    NSString *key = _arrayInputKeys[indexPath.row];
    if (![key isEqualToString:kCIInputImageKey]) {
        NSDictionary *dictKeyAttributes = _dictAttributes[key];
        
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(20, 50, 280, 10)];
        
        NSNumber *sliderMin = dictKeyAttributes[kCIAttributeSliderMin];
        [slider setMinimumValue:sliderMin.floatValue];
        
        NSNumber *sliderMax = dictKeyAttributes[kCIAttributeSliderMax];
        [slider setMaximumValue:sliderMax.floatValue];
        
        NSNumber *currentValue = [self.filter valueForKey:key];
        [slider setValue:currentValue.floatValue];
        
        [cell.contentView addSubview:slider];
        
        [slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
        [slider setTag:indexPath.row];
    }
    return cell;
}

- (void)dealloc
{
    [_filView cleanup];
    _filView = nil;
}

@end
