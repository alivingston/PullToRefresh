//
//  Copyright (c) 2013 Alan Livingston. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "FHKPullToRefreshCollectionView.h"

#define MAXIMUM_SCROLL_HEIGHT 52.0f
#define REFRESH_ACTIVATION_HEIGHT 52.0f

@interface FHKPullToRefreshCollectionView ()

@property (nonatomic, retain) UIView *refreshHeaderView;
@property (nonatomic, retain) UILabel *refreshTitle;
@property (nonatomic, retain) UIImageView *refreshArrow;
@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinner;
@property (assign, nonatomic, getter = isDragging) BOOL dragging;
@property (assign, nonatomic, getter = isLoading) BOOL loading;
@property (nonatomic, copy) NSString *textPull;
@property (nonatomic, copy) NSString *textRelease;
@property (nonatomic, copy) NSString *textLoading;

- (void)setupStrings;
- (void)addPullToRefreshHeader;

@end

@implementation FHKPullToRefreshCollectionView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil) {

    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.pullToRefreshEnabled) {
        [self addPullToRefreshHeader];
    }

}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    CGRect refreshFrame = self.refreshHeaderView.frame;
    CGRect viewBounds = self.view.bounds;
    refreshFrame.size.width = viewBounds.size.width;
    [self.refreshHeaderView setFrame:refreshFrame];
}

- (void)setupStrings{
    self.textPull = @"Pull down to refresh...";
    self.textRelease = @"Release to refresh...";
    self.textLoading = @"Loading...";
}

- (void)addPullToRefreshHeader {
    [self setupStrings];
    UIView *refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - MAXIMUM_SCROLL_HEIGHT, 320, MAXIMUM_SCROLL_HEIGHT)];
    refreshHeaderView.backgroundColor = [UIColor redColor];
    
    UILabel *refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, MAXIMUM_SCROLL_HEIGHT)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    refreshLabel.textAlignment = NSTextAlignmentCenter;
    
    UIImageView *refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    refreshArrow.frame = CGRectMake(floorf((MAXIMUM_SCROLL_HEIGHT) / 2),
                                    (floorf(MAXIMUM_SCROLL_HEIGHT - 44) / 2),
                                    44, 44);
    
    UIActivityIndicatorView *refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner.frame = CGRectMake(floorf(floorf(MAXIMUM_SCROLL_HEIGHT - 20) / 2), floorf((MAXIMUM_SCROLL_HEIGHT - 20) / 2), 20, 20);
    refreshSpinner.hidesWhenStopped = YES;
    
    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:refreshArrow];
    [refreshHeaderView addSubview:refreshSpinner];
    
    self.refreshHeaderView = refreshHeaderView;
    self.refreshTitle = refreshLabel;
    self.refreshArrow = refreshArrow;
    self.refreshSpinner = refreshSpinner;
    [self.collectionView addSubview:refreshHeaderView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (!self.isLoading){
        self.dragging = YES;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y <= -MAXIMUM_SCROLL_HEIGHT){ // we've scrolled below the header - pin the header to top of screen
        NSLog(@"refresh header y: %f", self.refreshHeaderView.frame.origin.y);
        CGPoint contentOffset = scrollView.contentOffset;
        CGRect rect = self.refreshHeaderView.frame;
        rect.origin.y = contentOffset.y;
        rect.size.height = -contentOffset.y;
        rect.size.height = ceilf(rect.size.height);
        
        [self.refreshHeaderView setFrame:rect];
    }
    else {
        [self.refreshHeaderView setFrame:CGRectMake(0, 0 - MAXIMUM_SCROLL_HEIGHT, 320, MAXIMUM_SCROLL_HEIGHT)];
    }
    
    NSLog(@"offset: %f", scrollView.contentOffset.y);
    if (self.isLoading) {
        // Update the content inset
        if (scrollView.contentOffset.y > 0){ // scrolling 'up' - zero insets to 'hide' refresh viewer
            self.collectionView.contentInset = UIEdgeInsetsZero;
        }
        else if (scrollView.contentOffset.y >= -MAXIMUM_SCROLL_HEIGHT){
            NSLog(@"setting contentInset to: %f", -scrollView.contentOffset.y);
            self.collectionView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        }
    }
    else if (self.isDragging && scrollView.contentOffset.y < 0) {
         // Update the arrow direction and label - custom animation can be added here to animate the refresh icon between the max scroll height and activation height values
        if (scrollView.contentOffset.y < -REFRESH_ACTIVATION_HEIGHT) { // if we release now, we will activate the refresh
            [UIView animateWithDuration:0.25 animations:^{
                self.refreshTitle.text = self.textRelease;
                [self.refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            }];
        }
        else {
            [UIView animateWithDuration:0.25 animations:^{
                self.refreshTitle.text = self.textPull;
                [self.refreshArrow layer].transform = [self.refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
            }];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!self.isLoading) {
        self.dragging = NO;
        if (scrollView.contentOffset.y <= -REFRESH_ACTIVATION_HEIGHT) {
            [self startLoading];
        }
    }
}

- (void)startLoading {
    self.loading = YES;
    
    // Show the header
    [UIView animateWithDuration:0.3 animations:^{
        self.collectionView.contentInset = UIEdgeInsetsMake(MAXIMUM_SCROLL_HEIGHT, 0, 0, 0);
        self.refreshTitle.text = self.textLoading;
        self.refreshArrow.hidden = YES;
        [self.refreshSpinner startAnimating];
    }];
    
    // Refresh action!
    [self refresh];
}

- (void)stopLoading {
    self.loading = NO;
    
    // Hide the header
    [UIView animateWithDuration:0.3 animations:^{
        self.collectionView.contentInset = UIEdgeInsetsZero;
        [self.refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    }
                     completion:^(BOOL finished) {
                         [self stopLoadingComplete];
                     }];
}

- (void)stopLoadingComplete
{
    // Reset the header
    self.refreshTitle.text = self.textPull;
    self.refreshArrow.hidden = NO;
    [self.refreshSpinner stopAnimating];
}

- (void)refresh
{
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
}

@end
