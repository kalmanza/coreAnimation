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
        if ([_filter.inputKeys containsObject:kCIInputImageKey]) {
            [_filter setValue:[CIImage imageWithCGImage:[UIImage imageNamed:@"toast"].CGImage] forKey:kCIInputImageKey];
        }
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

- (UIControl *)controlForKey:(NSString *)key
{
    NSDictionary *dictKeyAttributes = _dictAttributes[key];
    NSString *type = dictKeyAttributes[kCIAttributeType];
    
    UIControl *control;
    
    if ([type isEqualToString:kCIAttributeTypeAngle]) {
        control = [[UISlider alloc] init];
    } else if ([type isEqualToString:kCIAttributeTypeBoolean]) {
        control = [[UISwitch alloc] init];
    } else if ([type isEqualToString:kCIAttributeTypeColor]) {
        control = [UIButton buttonWithType:UIButtonTypeCustom];
    } else if ([type isEqualToString:kCIAttributeTypeCount]) {
        control = [[UISlider alloc] init];
    } else if ([type isEqualToString:kCIAttributeTypeDistance]) {
        control = [[UISlider alloc] init];
    } else if ([type isEqualToString:kCIAttributeTypeImage]) {
        control = [UIButton buttonWithType:UIButtonTypeCustom];
    } else if ([type isEqualToString:kCIAttributeTypeInteger]) {
        control = [[UISlider alloc] init];
    } else if ([type isEqualToString:kCIAttributeTypeOffset]) {
        control = nil;
    } else if ([type isEqualToString:kCIAttributeTypePosition]) {
        control = nil;
    } else if ([type isEqualToString:kCIAttributeTypePosition3]) {
        control = nil;
    } else if ([type isEqualToString:kCIAttributeTypeRectangle]) {
        control = nil;
    } else if ([type isEqualToString:kCIAttributeTypeScalar]) {
        control = [[UISlider alloc] init];
    } else if ([type isEqualToString:kCIAttributeTypeTime]) {
        control = [[UISlider alloc] init];
    } else if ([type isEqualToString:kCIAttributeTypeTransform]) {
        control = nil;
    } else {
        NSLog(@"No type found");
        control = nil;
    }
    return control;
}

- (void)setupControl:(UIControl *)control forKey:(NSString *)key usingAttributes:(NSDictionary *)attributes
{
    if ([control isKindOfClass:[UISlider class]]) {
        [control setFrame:CGRectMake(20, 50, 280, 10)];
        NSNumber *sliderMin = attributes[kCIAttributeSliderMin];
        [(UISlider *)control setMinimumValue:sliderMin.floatValue];
        NSNumber *sliderMax = attributes[kCIAttributeSliderMax];
        [(UISlider *)control setMaximumValue:sliderMax.floatValue];
        NSNumber *currentValue = [self.filter valueForKey:key];
        [(UISlider *)control setValue:currentValue.floatValue];
        [(UISlider *)control addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    } else if ([control isKindOfClass:[UIButton class]]) {
        [control setFrame:CGRectMake(20, 50, 280, 10)];
        [control setBackgroundColor:[UIColor blueColor]];
    } else {
        NSLog(@"not a button or slider");
    }
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
    UIControl *control = [self controlForKey:key];
    if (control) {
        [self setupControl:control forKey:key usingAttributes:_dictAttributes[key]];
        [control setTag:indexPath.row];
        [cell.contentView addSubview:control];
    }
    return cell;
}

- (void)dealloc
{
    [_filView cleanup];
    _filView = nil;
}

@end
