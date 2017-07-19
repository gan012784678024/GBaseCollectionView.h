//
//  GBaseCollectionView.m
//  SDCycleScrollView
//
//  Created by zlq002 on 2017/7/19.
//  Copyright © 2017年 GSD. All rights reserved.
//

#import "GBaseCollectionView.h"
#import "CustomFlowLayout.h"
#import "CollectionViewCell.h"

NSString * const ID = @"CollectionViewCell";

@interface GBaseCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UIPageControl *pageView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, assign) int imageCount;

@end

@implementation GBaseCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

    }
    return self;
}
-(void)setImages:(NSArray *)images{
    if (_images != 	images){
        _images = images;
        [self.collectionView reloadData];
        [self setupViews];
        if (self.isScorll) {
            [self setupTimer];
        }
        
    }
}

-(void)setupViews{
    self.imageCount = (self.images.count*100);
    
    //从中间显示

    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.imageCount/2 inSection:0];
    self.currentIndexPath = indexPath;

    [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
}
- (UICollectionView *)collectionView
{
    if (!_collectionView){
        //如果只要正常轮播可使用被注释的flowLayout1

        UICollectionViewFlowLayout *flowLayout1 = nil;
        if (self.isNormal){
            //如果只要正常轮播可修改itemSize
            flowLayout1 = [[UICollectionViewFlowLayout alloc]init];
            
            flowLayout1.itemSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
            
        }else{
            flowLayout1 = [[CustomFlowLayout alloc] init];
            flowLayout1.itemSize = CGSizeMake(self.bounds.size.width*0.5, self.bounds.size.height*0.7);
        }
        flowLayout1.minimumLineSpacing = 0;
        flowLayout1.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout = flowLayout1;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];

        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.pagingEnabled = YES;
        
        [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:ID];
        _collectionView.backgroundColor = [UIColor orangeColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.scrollsToTop = NO;
        [self addSubview:_collectionView];
    }
    
    return _collectionView;
}

-(UIPageControl *)pageView{
    if(!_pageView){
        _pageView = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 30, [UIScreen mainScreen].bounds.size.width, 30)];
        
        [self addSubview:_pageView];
        _pageView.numberOfPages = self.images.count;
        _pageView.currentPage = 0;
        _pageView.pageIndicatorTintColor = [UIColor whiteColor];
        _pageView.currentPageIndicatorTintColor = [UIColor blueColor];
    }
    return _pageView;
}
#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    if (cell != nil){
        cell.imageView.image = [UIImage imageNamed:self.images[indexPath.item % (self.images.count)]];
//        cell.imageView.image = [UIImage imageNamed:@"1"];
        return cell;
         }
    
         return cell;

}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isScorll) {
        [self invalidateTimer];
    }
    

    if (self.currentIndexPath.item == indexPath.item){

        NSString *blockStr = [NSString stringWithFormat:@"%lu",(indexPath.item % self.images.count)];
        if (self.returnValueBlock) {
            //将自己的值传出去，完成传值
            self.returnValueBlock(blockStr);
        }

    }
    [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    self.currentIndexPath = indexPath;
    
    if (self.isScorll) {
        [self setupTimer];
    }
    
    
}



- (void)invalidateTimer
{
    [_timer invalidate];
    _timer = nil;
}

- (void)setupTimer
{
    [self invalidateTimer]; // 创建定时器前先停止定时器，不然会出现僵尸定时器，导致轮播频率错误
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

-(void)nextImage{

    int page = self.currentIndexPath.item % self.images.count;
    
    self.pageView.currentPage = page;
    
    if(0 != self.imageCount) {
        if (self.currentIndexPath != nil){

            NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:self.currentIndexPath.item + 1 inSection:0];
            if (self.currentIndexPath.item == self.imageCount - 1) {  //如果是最后一个图片，回到第一部分的最后一张图片

                newIndexPath = [NSIndexPath indexPathForItem:(_imageCount/2) inSection:0];

                self.currentIndexPath = newIndexPath;

                [_collectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
            }
            self.currentIndexPath = newIndexPath;
            [_collectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            
        }
    }

}



- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.isScorll) {
        [self invalidateTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.isScorll) {
        [self setupTimer];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    NSInteger page = self.currentIndexPath.item % self.images.count;
    
    self.pageView.currentPage = page;
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint pInView = [self convertPoint:self.collectionView.center toView:self.collectionView];
    // 获取这一点的indexPath
    NSIndexPath *indexPathNow = [self.collectionView indexPathForItemAtPoint:pInView];
    // 赋值给记录当前坐标的变量
    self.currentIndexPath = indexPathNow;
    [_collectionView scrollToItemAtIndexPath:indexPathNow atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
}

@end


