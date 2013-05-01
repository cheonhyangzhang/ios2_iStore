//
//  DataManager.m
//  iStore
//
//  Created by cheonhyang on 13-4-25.
//  Copyright (c) 2013年 Tianxiang Zhang. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

@synthesize allApps;
@synthesize sortedAppsByStar;
@synthesize managedObjectContext;
#pragma mark - Singleton Methods

+ (id)sharedManager{
    static DataManager *sharedDataManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDataManager = [[self alloc] init];
    });
    return sharedDataManager;
}

- (void)sortByStar{
    self.sortedAppsByStar = [[NSMutableArray alloc] init];
    NSLog(@"Sort by Star called");
    if (self.allApps == nil){
        NSLog(@"allApps is nil");
    }
    else{
        NSMutableArray * star5 = [[NSMutableArray alloc] init];
        NSMutableArray * star4 = [[NSMutableArray alloc] init];
        NSMutableArray * star3 = [[NSMutableArray alloc] init];
        NSMutableArray * star2 = [[NSMutableArray alloc] init];
        NSMutableArray * star1 = [[NSMutableArray alloc] init];
        NSMutableArray * star0 = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [self.allApps count]; i ++){
            double rates = [[[self.allApps objectAtIndex:i] objectForKey:@"averageUserRating"] doubleValue];
//            NSLog(@"Rating: %f\n", rates);
            
            NSMutableDictionary *tmpDic = [self.allApps objectAtIndex:i];
            
            NSURL *url = [NSURL URLWithString: [tmpDic objectForKey:@"artworkUrl60"] ];
            GTMHTTPFetcher* myFetcher = [GTMHTTPFetcher fetcherWithRequest:[NSURLRequest requestWithURL:url]];
            [myFetcher beginFetchWithCompletionHandler:^(NSData *retrieveData, NSError *error) {
                if (error != nil){
                    NSLog(@"Error when fetching data from apple");
                }
                else{
                     UIImage*  tmpPic = [[UIImage alloc] initWithData:retrieveData];
                    [tmpDic setObject:tmpPic forKey:@"myIconImage"];
                }
                
            }];
            
            if (rates >=5.0f){
                [star5 addObject:tmpDic];
            }
            else if (rates >=4.0f){
                [star4 addObject:tmpDic];
            }
            else if (rates >=3.0f){
                [star3 addObject:tmpDic];
            }
            else if (rates >=2.0f){
                [star2 addObject:tmpDic];
            }
            else if (rates >=1.0f){
                [star1 addObject:tmpDic];
            }
            else {
                [star0 addObject:tmpDic];
            }
            
            
        }//end for
        
        [self.sortedAppsByStar addObject:star5];
        [self.sortedAppsByStar addObject:star4];
        [self.sortedAppsByStar addObject:star3];
        [self.sortedAppsByStar addObject:star2];
        [self.sortedAppsByStar addObject:star1];
        [self.sortedAppsByStar addObject:star0];
        
//        NSLog(@"The sorted App in Data is %@", self.sortedAppsByStar);
    }//end of else
    
    NSLog(@"Sort all done");
    
}

- (id) init{
    if (self = [super init]){
    }
    return self;
}


@end
