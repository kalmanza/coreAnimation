//
//  blurView.h
//  CoreAnimationApp
//
//  Created by Kevin Almanza on 7/18/14.
//  Copyright (c) 2014 Kevin Almanza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@protocol FilterViewDataSource <NSObject>

- (CIFilter *)filterToDraw;

@end

@interface FilterView : GLKView

@property (nonatomic, weak) id <FilterViewDataSource> dataSource;
@property (nonatomic, strong) CIContext *_ciContext;
@property (nonatomic, strong) EAGLContext *_eaglContext;

- (void)setupFilter;

- (void)startTimer;

- (void)cleanup;

@end
