//
//  FavoriteViewController.m
//  iStore
//
//  Created by cheonhyang on 13-4-26.
//  Copyright (c) 2013年 Tianxiang Zhang. All rights reserved.
//

#import "FavoriteViewController.h"

@interface FavoriteViewController ()

@end

@implementation FavoriteViewController
@synthesize managedObjectContext;
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
    DataManager *shManager = [DataManager sharedManager];
    managedObjectContext = shManager.managedObjectContext;
    
      
}

-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"Will appear");
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FavoriteApp" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    NSError *error = nil;
    self.fetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    [self.tableview reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSLog(@"The number is %d", [self.fetchResults count]);
    return [self.fetchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    myTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myTableCell"forIndexPath:indexPath];
    FavoriteApp *favapp = [self.fetchResults objectAtIndex:indexPath.row];    
    cell.name.text = [favapp trackName];
    cell.seller.text = [favapp sellerName];
    cell.rating.text =[NSString stringWithFormat:@"%.1f",[[favapp rating] doubleValue] ];    
    cell.price.text =[NSString stringWithFormat:@"$%.2f",[[favapp price] doubleValue] ];
    
    cell.backgroundColor = [UIColor lightGrayColor];
    
    cell.icon.image = [UIImage imageWithData:[favapp icon]];
    
    cell.icon.layer.cornerRadius =12.0f;
    cell.icon.clipsToBounds = YES;
    
    // Configure the cell...
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewController *dvc = [[self storyboard] instantiateViewControllerWithIdentifier:@"DetailVC"];
    NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] init];
    FavoriteApp *favapp = [self.fetchResults objectAtIndex:indexPath.row];
    [tmpDic setObject: [favapp trackName] forKey:@"trackName"];
    [tmpDic setObject: [favapp sellerName] forKey:@"sellerName"];
    [tmpDic setObject: [favapp rating] forKey:@"averageUserRating"];
    [tmpDic setObject: [favapp appDetail] forKey:@"description"];
    [tmpDic setObject: [favapp trackViewUrl] forKey:@"trackViewUrl"];
    [tmpDic setObject: [UIImage imageWithData:[favapp icon]] forKey:@"myIconImage"];
    
    dvc.appAllInfo = tmpDic;
    [self.navigationController pushViewController:dvc animated:YES];
    
    
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate




@end
