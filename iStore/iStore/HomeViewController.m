//
//  HomeViewController.m
//  iStore
//
//  Created by cheonhyang on 13-4-25.
//  Copyright (c) 2013年 Tianxiang Zhang. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize searchCache;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.myDataM = [DataManager sharedManager];
    self.activityIn = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    
    CGPoint newCenter = self.view.center;
    newCenter.y -= 100;
    self.activityIn.center = newCenter;
    [self.view addSubview:self.activityIn];
    
    searchCache = [[NSCache alloc] init];
    NSMutableArray * previousSearch = [[NSMutableArray alloc] init];
    [searchCache setObject:previousSearch forKey:@"previousSearch"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UISearchBar Delegate
- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    self.backgroundImage.hidden = YES;
    [self.activityIn startAnimating];
    [self.searchBarView endEditing:YES];
    if ([self isOldSearch:searchBar.text] == NO){
        [self downloadFromApple:searchBar.text];
    }
    else{
        [self reloadCollectionView];
    }
}

-(BOOL) isOldSearch: (NSString *) keyword{
    NSMutableArray *previousSearch = [searchCache objectForKey:@"previousSearch"];
    BOOL already = NO;
    for (int i =0; i < [previousSearch count]; i++){
        if ([keyword isEqualToString:[[previousSearch objectAtIndex:i] objectForKey: @"keyword"]]){
            NSLog(@"Old search");
            self.myDataM.sortedAppsByStar = [[previousSearch objectAtIndex:i] objectForKey:@"results"];
            already = YES;
            break;
        }
        
    }
    return already;
}

- (void) downloadFromApple: (NSString *)  keyword{
    NSLog(@"downloadFromApple");
    NSString *searchString = [keyword stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    NSString *searchURL = [NSString stringWithFormat:@"https://itunes.apple.com/search?term=%@&country=us&entity=software", searchString];
    
    NSURL *url = [NSURL URLWithString:searchURL];
    GTMHTTPFetcher* myFetcher = [GTMHTTPFetcher fetcherWithRequest:[NSURLRequest requestWithURL:url]];
    [myFetcher beginFetchWithCompletionHandler:^(NSData *retrieveData, NSError *error) {
        if (error != nil){
            NSLog(@"Error when fetching data from apple");
        }
        else{
            NSDictionary * tmpResult = [NSJSONSerialization JSONObjectWithData:retrieveData options:NSJSONReadingMutableContainers error:nil];
            self.myDataM.allApps = [tmpResult objectForKey:@"results"];
            [self.myDataM sortByStar];
            NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc]init];
            [tmpDic setObject:keyword forKey:@"keyword"];
            [tmpDic setObject:self.myDataM.sortedAppsByStar forKey:@"results"];
            [[searchCache objectForKey:@"previousSearch"] addObject:tmpDic];
            
            [self reloadCollectionView];
        }
        
    }];
}

-(void)reloadCollectionView{
    self.needReload = NO;
    NSLog(@"Checking refresh ");
    [self.collectionView reloadData];
    [self performSelector:@selector(checkNeedReload) withObject:nil afterDelay:1.0f];
    
}

-(void)checkNeedReload{
    if (self.needReload == YES){
        
        [self reloadCollectionView];
    }
    else{
        [self.activityIn stopAnimating];
    }
}

#pragma mark - UICollectionView Datasource
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSLog(@"numberofItemsInSection called");
    return [[self.myDataM.sortedAppsByStar objectAtIndex:section] count];
}
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    NSLog(@"numberofSectionsInCollectionView called");
    
    return [self.myDataM.sortedAppsByStar count];
}
- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    myCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TypeCell" forIndexPath:indexPath];
    
    
    
    NSDictionary *tmpDic = [[self.myDataM.sortedAppsByStar objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
   
    cell.image.layer.cornerRadius = 12.0f;
    cell.image.clipsToBounds = YES;
    
    cell.name.text= [tmpDic objectForKey:@"trackName"];   
    cell.seller.text = [tmpDic objectForKey:@"sellerName"];
    cell.star.text =[NSString stringWithFormat:@"%.1f",[[tmpDic objectForKey:@"averageUserRating"] doubleValue]];

    cell.price.text =[NSString stringWithFormat:@"$%.2f",[[tmpDic objectForKey:@"price"] doubleValue]];

    cell.image.image = [tmpDic objectForKey:@"myIconImage"];
    
    
    if (cell.image.image == nil){
        self.needReload = YES;
    }
   
    
    return cell;
}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reuseView = nil;
    if (kind == UICollectionElementKindSectionHeader){
        SectionHeader * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeader" forIndexPath:indexPath];
        
        header.rating.text = [NSString stringWithFormat:@"Rating : %d+", 5-indexPath.section];
             
        reuseView = header;
       
    }    
    return reuseView;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Selected Item At Index called");
    self.selectedIndexPath = indexPath;
    DetailViewController *dvc = [[self storyboard] instantiateViewControllerWithIdentifier:@"DetailVC"];
    dvc.appAllInfo = [[self.myDataM.sortedAppsByStar objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:dvc animated:YES];
    
}


@end
