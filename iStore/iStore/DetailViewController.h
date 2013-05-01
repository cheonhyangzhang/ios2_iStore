//
//  DetailViewController.h
//  iStore
//
//  Created by cheonhyang on 13-4-25.
//  Copyright (c) 2013年 Tianxiang Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "FavoriteApp.h"
#import "DataManager.h"
#import <QuartzCore/QuartzCore.h>

@interface DetailViewController : UIViewController{
    NSManagedObjectContext *managedObjectContext;//needed
}
@property (weak, nonatomic) IBOutlet UIButton *buttonLike;
@property (weak, nonatomic) IBOutlet UIView *downHalf;
@property (weak, nonatomic) IBOutlet UIView *upHalf;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *seller;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *rating;
@property (weak, nonatomic) IBOutlet UILabel *price;
- (IBAction)likeButton:(id)sender;
- (IBAction)buyButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *description;
@property (nonatomic, strong) NSDictionary * appAllInfo;
@property (nonatomic) BOOL  liked;
@end
