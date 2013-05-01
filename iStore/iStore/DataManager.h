//
//  DataManager.h
//  iStore
//
//  Created by cheonhyang on 13-4-25.
//  Copyright (c) 2013年 Tianxiang Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GTMHTTPFetcher.h"


@interface DataManager : NSObject{
    NSArray * allApps;
    NSMutableArray * sortedAppsByStar;
    NSManagedObjectContext *managedObjectContext;
}
@property (nonatomic, retain) NSArray * allApps;
@property (nonatomic, retain) NSMutableArray * sortedAppsByStar;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;


+(id)sharedManager;
- (void)sortByStar;
@end
