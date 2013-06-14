//
//  FHKDetailViewController.h
//  FHKPullToRefresh
//
//  Created by Alan Livingston on 6/14/13.
//  Copyright (c) 2013 Alan Livingston. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FHKDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
