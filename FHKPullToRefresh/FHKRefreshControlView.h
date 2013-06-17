//
//  Copyright (c) 2013 Alan Livingston. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FHKRefreshControlView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *refreshImage;
@property (weak, nonatomic) IBOutlet UILabel *refreshInstructions;
@property (weak, nonatomic) IBOutlet UILabel *refreshSubtitle;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *refreshSpinner;

@end
