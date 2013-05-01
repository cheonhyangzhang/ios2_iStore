//
//  DetailViewController.m
//  iStore
//
//  Created by cheonhyang on 13-4-25.
//  Copyright (c) 2013年 Tianxiang Zhang. All rights reserved.
//

#import "DetailViewController.h"


@interface DetailViewController ()

@end

@implementation DetailViewController
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
    NSLog(@"DetailViewController didload");
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self fillViews];
    DataManager *shmagener = [DataManager sharedManager];
    managedObjectContext = shmagener.managedObjectContext;
//    self.buttonLike.titleLabel.text = @"just A test";
    
    
    
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [self setLikeButtonBehavior];
}
- (void)setLikeButtonBehavior{
    NSLog(@"setLikeButton Behavior");
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FavoriteApp" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    NSError *error = nil;
    NSMutableArray *tmpResult = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    self.liked = NO;
    for (int i = 0; i < [tmpResult count]; i++){
        NSString * tmpStr = [[tmpResult objectAtIndex:i] trackName];
        if ([tmpStr isEqualToString:[self.appAllInfo objectForKey:@"trackName"]]){
            self.liked = YES;
            break;
        }
    }
    if (self.liked == YES){
//        self.likeButtonItem.titleLabel.text = @"Unlike";
        
        [self.buttonLike setTitle:@"Unlike" forState: UIControlStateNormal];
        NSLog(@"Liked YES");
        
    }
    else{
//        self.likeButtonItem.titleLabel.text = @"Like";
        [self.buttonLike setTitle:@"Like" forState: UIControlStateNormal];
        
        NSLog(@"Liked NO");
    }
}


-(void)fillViews{
    if (self.appAllInfo !=nil){
//        NSLog(@"appAllInfo is %@", self.appAllInfo);
        self.iconImage.image = [self.appAllInfo objectForKey:@"myIconImage"];
        self.iconImage.layer.cornerRadius = 12.0f;
        self.iconImage.clipsToBounds = YES;
        
        self.name.text = [self.appAllInfo objectForKey:@"trackName"];
        self.seller.text = [self.appAllInfo objectForKey:@"sellerName"];
        self.rating.text = [NSString stringWithFormat:@"%.1f",[[self.appAllInfo objectForKey:@"averageUserRating"] doubleValue]];
        self.price.text = [NSString stringWithFormat:@"$%.2f",[[self.appAllInfo objectForKey:@"price"] doubleValue]];
        self.description.text = [self.appAllInfo objectForKey:@"description"];
        
        self.upHalf.layer.cornerRadius = 12.0f;
        self.upHalf.clipsToBounds = YES;
        self.downHalf.layer.cornerRadius = 12.0f;
        self.downHalf.clipsToBounds = YES;
        self.description.layer.cornerRadius = 12.0f;
        self.description.clipsToBounds = YES;
        self.description.editable = NO;
        
        
    }
    else{
        NSLog(@"Error with the data");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)likeButton:(id)sender {
   

    if (self.liked == NO){
        FavoriteApp * favapp = (FavoriteApp *) [NSEntityDescription insertNewObjectForEntityForName:@"FavoriteApp" inManagedObjectContext:managedObjectContext];
        [favapp setIcon: UIImagePNGRepresentation([self.appAllInfo objectForKey:@"myIconImage"])];
        [favapp setRating:[self.appAllInfo objectForKey:@"averageUserRating"]];
        [favapp setPrice:[self.appAllInfo objectForKey: @"price"]];
        [favapp setSellerName:[self.appAllInfo objectForKey:@"sellerName"]];
        [favapp setTrackName:[self.appAllInfo objectForKey:@"trackName"]];
        [favapp setAppDetail:[self.appAllInfo objectForKey:@"description"]];
        [favapp setTrackViewUrl:[self.appAllInfo objectForKey:@"trackViewUrl"]];
    
        NSError *error = nil;
        if (![managedObjectContext save:&error]){
            NSLog(@"Save error!");
        
        }
        else{
            NSLog(@"Save success!");
        }
    }
    else{
        //Delete an app
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"FavoriteApp" inManagedObjectContext:managedObjectContext];
        [request setEntity:entity];
        NSPredicate *querryP = [NSPredicate predicateWithFormat:@"trackName == %@", [self.appAllInfo objectForKey:@"trackName"]];
        [request setPredicate:querryP];
        NSError *error = nil;

        NSMutableArray *tmpResult = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        
//        NSLog(@"Result is %@", tmpResult);
        [managedObjectContext deleteObject: [tmpResult objectAtIndex:0]];
        if (![managedObjectContext save:&error]){
            NSLog(@"Delete error!");
            
        }
        else{
            NSLog(@"Delete success!");
        }

    }
    
    //NSLog(@"Fav app entity is :%@",favapp);
    
    [self setLikeButtonBehavior];    
}

- (IBAction)buyButton:(id)sender {
    NSLog(@"Buy clicked");
    NSURL *appURL = [NSURL URLWithString: [self.appAllInfo objectForKey:@"trackViewUrl"]];
    NSLog(@"URL is %@",appURL);
    
    [[UIApplication sharedApplication] openURL:appURL];
}
@end
