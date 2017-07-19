//
//  CollectionViewCell.m
//  testLY
//
//  Created by zlq002 on 2017/7/19.
//  Copyright © 2017年 zlq002. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupImageView];

    }
    
    return self;
}

- (void)setupImageView
{
    UIImageView *imageView = [[UIImageView alloc] init];

    _imageView = imageView;
    [self.contentView addSubview:imageView];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _imageView.frame = self.bounds;
}
@end
