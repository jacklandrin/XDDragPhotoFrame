//
//  ImageViewWithDelete.m
//  XDDragPhotoFrame
//
//  Created by jack on 15/4/13.
//  Copyright (c) 2015年 jack. All rights reserved.
//

#import "ImageViewWithDelete.h"

@implementation ImageViewWithDelete

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //self.infoDic = [[NSDictionary alloc] init];
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width - 10, self.frame.size.height - 10)];
        [self addSubview:self.imageView];
        self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [self.deleteButton setImage:[UIImage imageNamed:@"delete_button"] forState:UIControlStateNormal];
        [self addSubview:self.deleteButton];
    }
    return self;
}

@end
