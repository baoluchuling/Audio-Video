//
//  BCGridViewCell.h
//  BCAudioApp
//
//  Created by boluchuling on 2019/7/22.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BCGridViewCellDelegate <NSObject>

- (void)didSelectPreviewButton:(NSInteger)index;

@end

@class BCAsset;

@interface BCGridViewCell : UICollectionViewCell

@property (nonatomic, weak) id <BCGridViewCellDelegate> delegate;

@property (readonly) UIImageView *imageView;

@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, assign) NSInteger index;

- (void)updateImage:(BCAsset *)info;

@end


