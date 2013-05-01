//
//  FavoriteApp.h
//  iStore
//
//  Created by cheonhyang on 13-4-26.
//  Copyright (c) 2013年 Tianxiang Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FavoriteApp : NSManagedObject

@property (nonatomic, retain) NSString * appDetail;
@property (nonatomic, retain) NSData * icon;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSString * sellerName;
@property (nonatomic, retain) NSString * trackName;
@property (nonatomic, retain) NSString * trackViewUrl;

@end
