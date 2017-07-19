//
//  GBaseCollectionView.h
//  SDCycleScrollView
//
//  Created by zlq002 on 2017/7/19.
//  Copyright © 2017年 GSD. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ReturnValueBlock) (NSString *strValue);
@interface GBaseCollectionView : UIView

@property (nonatomic, strong) NSArray *images;

@property (nonatomic, assign) BOOL *isScorll;//是否自动滚动
@property (nonatomic, assign) BOOL isNormal;
@property(nonatomic, copy) ReturnValueBlock returnValueBlock;
@end
