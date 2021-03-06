//
//  SCMultipleCornerView.m
//  SDDouYu
//
//  Created by Allen on 16/5/15.
//  Copyright © 2016年 com.sybercare.enterprise. All rights reserved.
//

#import "SDMultipleCornerView.h"
#import "UIImageView+Corner.h"
NSString *const SDMultipleCornerViewImageIdentifier = @"SDMultipleCornerViewImageIdentifier";
NSString *const SDMultipleCornerViewTitleIdentifier = @"SDMultipleCornerViewTitleIdentifier";

#pragma mark - SDCornerView -

static CGFloat const kCornerViewScale = 0.8;

//上面是图片,下面是文字,图片高度占总高度的比例是kCornerViewScale,图片垂直居中正方形分布
@interface SDCornerView ()


@end
@implementation SDCornerView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initWithDefaults];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self initWithDefaults];
    }
    return self;
}
- (void)initWithDefaults{
    self.backgroundColor         = [UIColor whiteColor];
    self.imageView.backgroundColor = [UIColor clearColor];
    self.imageView               = [[UIImageView alloc] init];
    self.textLable               = [[UILabel alloc] init];
    self.imageView.contentMode   = UIViewContentModeScaleAspectFit;
    self.textLable.textAlignment = NSTextAlignmentCenter;
    self.textLable.textColor     = [UIColor blackColor];
    self.textLable.font          = [UIFont systemFontOfSize:15];
    [self addSubview:self.imageView];
    [self addSubview:self.textLable];
}
- (void)layoutSubviews{
//    self.imageView.layer.cornerRadius = (self.frame.size.height * kCornerViewScale) / 2;
//    self.imageView.clipsToBounds = YES;
    [self.textLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.equalTo(self);
        make.height.mas_equalTo(self.frame.size.height * (1 - kCornerViewScale));
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self);
        CGSize size = CGSizeMake(self.frame.size.height * kCornerViewScale, self.frame.size.height *  kCornerViewScale);
        make.size.mas_equalTo(size);
    }];
}
- (void)setImage:(NSURL *)url text:(NSString *)text{
//    [self.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"douyu"]];
    [self.imageView setImageViewCorner:url placeholderImage:[UIImage imageNamed:@"douyu"]];
    self.textLable.text = text;
}
- (void)setLocalImage:(UIImage *)url text:(NSString *)text{
    self.imageView.image = url;
    self.textLable.text = text;
}

@end

#pragma mark - SDMultipleCornerViewCell -
@implementation SDMultipleCornerViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.cornerView = [[SDCornerView alloc] init];
        self.cornerView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.cornerView];;
    }
    return self;
}
- (void)layoutSubviews{
    [self.cornerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.bottom.equalTo(self);
    }];
}
@end

#pragma mark - SDMultipleCornerView -
static NSString *const KMultipleCornerViewCellIdentifier = @"KMultipleCornerViewCellIdentifier";

@interface SDMultipleCornerView ()<UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSMutableArray<__kindof SDGameCategoryModel *> *data;

@property (nonatomic, copy) selectedMultipleBlock complection;
@end
@implementation SDMultipleCornerView{
    CGSize loaclitemSize;
}

- (NSMutableArray *)data{
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initWithSubCollectionView];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self initWithSubCollectionView];
    }
    return self;
}
- (void)initWithSubCollectionView{
    self.flowlayout                         = [[UICollectionViewFlowLayout alloc] init];
    self.flowlayout.scrollDirection         = UICollectionViewScrollDirectionHorizontal;
    self.flowlayout.minimumInteritemSpacing = 0;
    self.flowlayout.minimumLineSpacing      = 0;
    loaclitemSize                           = CGSizeMake(0, 0);
    self.collectionView                     = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:self.flowlayout];
     NSLog(@"%s,%@",__FUNCTION__,NSStringFromCGRect(self.frame));
    self.collectionView.backgroundColor     = [UIColor whiteColor];
    self.collectionView.delegate            = self;
    self.collectionView.dataSource          = self;
    [self.collectionView registerClass:[SDMultipleCornerViewCell class] forCellWithReuseIdentifier:KMultipleCornerViewCellIdentifier];
    [self addSubview:self.collectionView];
}
- (void)layoutSubviews{
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.bottom.equalTo(self);;
    }];
}
#pragma mark - UICollectionView delagate and datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.data.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SDMultipleCornerViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KMultipleCornerViewCellIdentifier forIndexPath:indexPath];
    SDGameCategoryModel *model = self.data[indexPath.item];
    [cell.cornerView setImage:[NSURL URLWithString:model.icon_url] text:model.tag_name];
    return cell;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return loaclitemSize;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.complection(self.data[indexPath.row]);
}
#pragma mark - private method
- (void)setScrollDirection:(UICollectionViewScrollDirection )scrollDirection{
    self.flowlayout.scrollDirection  = scrollDirection;
}
- (void)setItemSize:(CGSize)itemSize{
    loaclitemSize  = itemSize;
    [self.collectionView reloadData];
}

- (void)setDatas:(NSArray *)datas selected:(void (^)(id))selectedComplander{
    [self.data removeAllObjects];
    [self.data addObjectsFromArray:datas];
    [self.collectionView reloadData];
    self.complection = selectedComplander;
    if (self.delegate && [self.delegate respondsToSelector:@selector(sdmultipleCornerViewDidScroll:)]) {
        [self.delegate sdmultipleCornerViewDidScroll:0];
    }
}
//- (void)willMoveToSuperview:(UIView *)newSuperview{
//    NSLog(@"%s",__func__);
//    [self.collectionView reloadData];
//}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offsetX = self.collectionView.contentOffset.x;
    if (self.delegate && [self.delegate respondsToSelector:@selector(sdmultipleCornerViewDidScroll:)]){
        [self.delegate sdmultipleCornerViewDidScroll:offsetX > 200 ? 1 : 0];
    }
}
@end


