//
//  ViewController.m
//  XDDragPhotoFrame
//
//  Created by jack on 15/4/13.
//  Copyright (c) 2015年 jack. All rights reserved.
//

#import "ViewController.h"
#import "DragPhotoFrameView.h"

@interface ViewController (){
    DragPhotoFrameView *dragPhotoFrameView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dragPhotoFrameView = [[DragPhotoFrameView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 400)];
    [self.view addSubview:dragPhotoFrameView];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 5; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"head%d",i]];
        [tempArray addObject:image];
    }
    dragPhotoFrameView.imagesArray = tempArray;
    [dragPhotoFrameView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 400, 100, 20)];
    [button setTitle:@"add image" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 500, 100, 20)];
    [button1 setTitle:@"show tag" forState:UIControlStateNormal];
    [button1 addTarget:dragPhotoFrameView action:@selector(showCurrentTag) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
}

-(void)clickAction:(UIButton*)button{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < arc4random()%6; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"head%d",arc4random()%6]];
        [tempArray addObject:image];
    }
    [dragPhotoFrameView addImages:tempArray];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (![change[@"new"] isEqual:change[@"old"]]) {
        NSLog(@"%@",change);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
