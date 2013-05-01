//
//  FavoriteViewController.h
//  iStore
//
//  Created by cheonhyang on 13-4-26.
//  Copyright (c) 2013年 Tianxiang Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "myTableCell.h"
#import "DataManager.h"
#import "FavoriteApp.h"
#import "DetailViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface FavoriteViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>{
    NSManagedObjectContext * managedObjectContext;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSMutableArray * fetchResults;

@end
