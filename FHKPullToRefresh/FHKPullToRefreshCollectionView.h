//
//  Copyright (c) 2013 Alan Livingston. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FHKPullToRefreshCollectionView : UICollectionViewController

@property (assign, nonatomic) BOOL pullToRefreshEnabled;
@property (strong, nonatomic) NSString *refreshText;
- (void)refresh;

@end
