//
//  DragPhotoFrameView.h
//  XDDragPhotoFrame
//
//  Created by jack on 15/4/13.
//  Copyright (c) 2015年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DragPhotoFrameView : UIView

@property (nonatomic,strong) NSArray *imagesArray;
@property (nonatomic,strong) UIButton *addButton;

-(void)addImages:(NSArray*)newAddImagesArray;
-(void)showCurrentTag;
@end
