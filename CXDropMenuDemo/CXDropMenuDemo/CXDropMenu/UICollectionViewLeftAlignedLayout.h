
#import <UIKit/UIKit.h>

@interface UICollectionViewLayoutAttributes (LeftAligned)

- (void)leftAlignFrameWithSectionInset:(UIEdgeInsets)sectionInset;

@end


@interface UICollectionViewLeftAlignedLayout : UICollectionViewFlowLayout <UICollectionViewDelegateFlowLayout>

@end

