//
//  Copyright (c) 2013 Alan Livingston. All rights reserved.
//

#import "FHKRefreshControl.h"
#import <QuartzCore/QuartzCore.h>

@interface FHKRefreshControl ()

@property (assign, nonatomic) BOOL loading;
@property (strong, nonatomic) UIImageView *refreshImage;
@property (strong, nonatomic) UILabel *refreshLabel;
@property (strong, nonatomic) UIActivityIndicatorView *refreshSpinner;

@end

@implementation FHKRefreshControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)startLoading {
    self.loading = YES;
    
    // Show the header
    [UIView animateWithDuration:0.3 animations:^{
//        self.collectionView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
//        self.refreshLabel.text = self.textLoading;
        self.refreshImage.hidden = YES;
        [self.refreshSpinner startAnimating];
    }];
}

- (void)stopLoading {
    self.loading = NO;
    
    // Hide the header
    [UIView animateWithDuration:0.3 animations:^{
//        self.collectionView.contentInset = UIEdgeInsetsZero;
        [self.refreshImage layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    }
                     completion:^(BOOL finished) {
                         [self stopLoadingComplete];
                     }];
}

- (void)stopLoadingComplete {
    // Reset the header
//    self.refreshLabel.text = self.textPull;
    self.refreshImage.hidden = NO;
    [self.refreshSpinner stopAnimating];
}



@end
