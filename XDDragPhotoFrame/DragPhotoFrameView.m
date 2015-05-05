//
//  DragPhotoFrameView.m
//  XDDragPhotoFrame
//
//  Created by jack on 15/4/13.
//  Copyright (c) 2015年 jack. All rights reserved.
//

#import "DragPhotoFrameView.h"
#import "ImageViewWithDelete.h"

#define NumberOfRow 4
#define Duration 0.2f
#define MAXIMAGENUM 16
#define OFFSET 10

@interface DragPhotoFrameView(){
    CGFloat size;
    NSArray *imageViewsArray;
    
}
@property (nonatomic,strong) UIPanGestureRecognizer *panGestureRecognizer;
@end

@implementation DragPhotoFrameView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        size = (frame.size.width - OFFSET) / NumberOfRow;
        self.backgroundColor = [UIColor whiteColor];
        _imagesArray = [[NSArray alloc] init];
        _addButton = [[UIButton alloc] initWithFrame:CGRectMake(OFFSET, OFFSET, size - OFFSET, size - OFFSET)];
        [_addButton setBackgroundImage:[UIImage imageNamed:@"add_photo_button"] forState:UIControlStateNormal];
        [self addSubview:_addButton];
        self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        self.panGestureRecognizer.minimumNumberOfTouches = 1;
        self.panGestureRecognizer.maximumNumberOfTouches = 1;
    }
    return self;
}

-(void)setImagesArray:(NSArray *)imagesArray{
    if (imagesArray.count > MAXIMAGENUM) {
        return;
    }
    _imagesArray = imagesArray;
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < imagesArray.count; i++) {
        UIImage *image = imagesArray[i];
        ImageViewWithDelete *imageViewDelete = [[ImageViewWithDelete alloc] initWithFrame:[self imageFrame:i]];
        [imageViewDelete.imageView setImage:image];
        imageViewDelete.deleteButton.tag = i;
        [imageViewDelete.deleteButton addTarget:self action:@selector(deleteImageAction:) forControlEvents:UIControlEventTouchUpInside];
        imageViewDelete.tag = i;
        [imageViewDelete addGestureRecognizer:self.panGestureRecognizer];
        [self addSubview:imageViewDelete];
        [tempArray addObject:imageViewDelete];
    }
    if (imagesArray.count < MAXIMAGENUM) {
        _addButton.frame = [self addButtonFrame:imagesArray.count];
        [self addSubview:_addButton];
    }
    imageViewsArray = tempArray;
    [self adjustFrame];
}

-(CGRect)imageFrame:(NSInteger)index{
    int column = index % NumberOfRow;
    int row = (int)index / NumberOfRow;
    return CGRectMake(column * size, row * size, size, size);
}

-(CGRect)addButtonFrame:(NSInteger)index{
    int column = index % NumberOfRow;
    int row = (int)index / NumberOfRow;
    return CGRectMake(column * size + OFFSET, row * size + OFFSET, size - OFFSET, size - OFFSET);
}

-(void)addImages:(NSArray *)newAddImagesArray{
    if (_imagesArray.count + newAddImagesArray.count > MAXIMAGENUM) {
        return;
    }
    int newIndex = (int)_imagesArray.count;
    _imagesArray = [_imagesArray arrayByAddingObjectsFromArray:newAddImagesArray];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (int i = newIndex; i < _imagesArray.count; i++) {
        UIImage *image = _imagesArray[i];
        ImageViewWithDelete *imageViewWithDelete = [[ImageViewWithDelete alloc] initWithFrame:[self imageFrame:i]];
        [imageViewWithDelete.imageView setImage:image];
        imageViewWithDelete.deleteButton.tag = i;
        [imageViewWithDelete.deleteButton addTarget:self action:@selector(deleteImageAction:) forControlEvents:UIControlEventTouchUpInside];
        imageViewWithDelete.alpha = 0;
        [self addSubview:imageViewWithDelete];
        [tempArray addObject:imageViewWithDelete];
        [UIView animateWithDuration:Duration animations:^{
            imageViewWithDelete.alpha = 1;
        }];
    }
    imageViewsArray = [imageViewsArray arrayByAddingObjectsFromArray:tempArray];
    if (_imagesArray.count == MAXIMAGENUM) {
        [_addButton removeFromSuperview];
    } else {
        [UIView animateWithDuration:Duration animations:^{
            _addButton.frame = [self addButtonFrame:_imagesArray.count];
        }];
    }
    
    int itemCount = (int)_imagesArray.count + 1;
    int totalRows = itemCount / NumberOfRow - (itemCount % NumberOfRow ? 0 : 1) + 1;
    CGRect newFrame = self.frame;
    newFrame.size.height = totalRows * size;
    self.frame = newFrame;
}

-(void)deleteImageAction:(UIButton*)button{
    [self deleteImage:button.tag];
}

-(void)deleteImage:(NSInteger)index{
    NSLog(@"delete %lu",index);
    NSMutableArray *imagesTempArray = [[NSMutableArray alloc] initWithArray:self.imagesArray];
    NSMutableArray *imageViewsTempArray = [[NSMutableArray alloc] initWithArray:imageViewsArray];
    int arrayCount = (int)imagesTempArray.count;
    if (arrayCount == MAXIMAGENUM) {
        _addButton.frame = [self addButtonFrame:arrayCount];
        [self addSubview:_addButton];
    }
    ImageViewWithDelete *imageViewWithDelete = [imageViewsArray objectAtIndex:index];
    [UIView animateWithDuration:Duration animations:^{
        imageViewWithDelete.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [imageViewWithDelete removeFromSuperview];
            if (index == arrayCount - 1) {
                [imagesTempArray removeLastObject];
                [imageViewsTempArray removeLastObject];
                _imagesArray = imagesTempArray;
                imageViewsArray = imageViewsTempArray;
                [self adjustFrame];
            }
        }
    }];
    
    if (index != arrayCount - 1) {
        int nextIndex = (int)index + 1;
        for (int i = nextIndex; i < imagesTempArray.count; i++) {
            [UIView animateWithDuration:Duration animations:^{
                ImageViewWithDelete *imageViewWithDeleteTemp = [imageViewsArray objectAtIndex:i];
                int nowIndex = i - 1;
                imageViewWithDeleteTemp.frame = [self imageFrame:nowIndex];
            } completion:^(BOOL finished) {
                if (finished && i == arrayCount - 1) {
                    [imagesTempArray removeObjectAtIndex:index];
                    [imageViewsTempArray removeObjectAtIndex:index];
                    for (int j = 0; j < imageViewsTempArray.count; j++) {
                        ImageViewWithDelete *imageViewWithDelete = [imageViewsTempArray objectAtIndex:j];
                        imageViewWithDelete.deleteButton.tag = j;
                    }
                    _imagesArray = imagesTempArray;
                    imageViewsArray = imageViewsTempArray;
                    [self adjustFrame];
                }
            }];
        }
    }
    [UIView animateWithDuration:Duration
                     animations:^{
                         _addButton.frame = [self addButtonFrame:_imagesArray.count - 1];
                     }];
}

-(void)adjustFrame{
    int itemCount = (int)_imagesArray.count + 1;
    int totalRows = itemCount / NumberOfRow - (itemCount % NumberOfRow ? 0 : 1) + 1;
    CGRect newFrame = self.frame;
    newFrame.size.height = totalRows * size;
    self.frame = newFrame;
}

-(void)showCurrentTag{
    for (ImageViewWithDelete *imageViewWithDelete in imageViewsArray) {
        NSLog(@"%lu",imageViewWithDelete.deleteButton.tag);
    }
}

-(void)handlePanGesture:(UIPanGestureRecognizer*)paramSender{
    if (paramSender.state != UIGestureRecognizerStateEnded && paramSender.state != UIGestureRecognizerStateFailed) {
        CGPoint location = [paramSender locationInView:paramSender.view.superview];
        paramSender.view.center = location;
    }
}

-(void)addPanGesture:(UIView*)view index:(NSInteger)index{
    
}

@end
