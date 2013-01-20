//
//  BrowseCategoriesViewController.m
//  iOSCookBook
//
//  Created by Andrew O'Connor on 18/01/2013.
//  Copyright (c) 2013 Andrew O'Connor. All rights reserved.
//

#import "BrowseCategoriesViewController.h"
#import "BrowseRecipesViewController.h"

@interface BrowseCategoriesViewController ()

@end

@implementation BrowseCategoriesViewController

@synthesize model;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        model = [iOSCookBookModel new];
     // tableViewData = [[NSArray alloc] initWithObjects:@"1st Category", @"2nd Category", @"3rd Category", nil];
        tableViewData = [model getCategories];

      self.title = @"Categories";
    }
    return self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return [tableViewData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainCell"];
  
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainCell"];
  }
  
  cell.textLabel.text = [tableViewData objectAtIndex:indexPath.row];
  
  return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  BrowseRecipesViewController *secondView = [[BrowseRecipesViewController alloc] initWithNibName:@"BrowseRecipesViewController" bundle:nil];
  //secondView.rowSelectedPreviously = indexPath.row;
    NSMutableArray *r = [model getRecipesByCategory:[tableViewData objectAtIndex:indexPath.row]];

  secondView.recipeList = r;
  [self.navigationController pushViewController:secondView animated:TRUE];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
