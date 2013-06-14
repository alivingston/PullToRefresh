//
//  FHKMasterViewController.h
//  FHKPullToRefresh
//
//  Created by Alan Livingston on 6/14/13.
//  Copyright (c) 2013 Alan Livingston. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@interface FHKMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
