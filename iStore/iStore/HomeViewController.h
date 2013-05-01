//
//  HomeViewController.h
//  iStore
//
//  Created by cheonhyang on 13-4-25.
//  Copyright (c) 2013年 Tianxiang Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "DataManager.h"
#import "myCell.h"
#import "SectionHeader.h"
#import "DetailViewController.h"

@interface HomeViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,UISearchBarDelegate>{
    NSCache *searchCache;
}
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIView *searchBarView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, retain) DataManager * myDataM;
@property (nonatomic, retain) NSCache *searchCache;
@property (nonatomic, strong) UIActivityIndicatorView * activityIn;
@property NSIndexPath *selectedIndexPath;
@property BOOL needReload;
@end
