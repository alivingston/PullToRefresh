//
//  Copyright (c) 2013 Alan Livingston. All rights reserved.
//

#import "FHKTestCollectionViewController.h"

@interface FHKTestCollectionViewController ()

@end

@implementation FHKTestCollectionViewController

-(void)awakeFromNib
{
    [self setPullToRefreshEnabled:YES];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.collectionView setAlwaysBounceVertical:YES];
}

-(void)refresh
{
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:3.0];
}

@end
