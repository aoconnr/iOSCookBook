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
        
        //get the category data to be displayed from the model
        model = [iOSCookBookModel new];
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
    //get the category name of the selected row
    NSString *category = [tableViewData objectAtIndex:indexPath.row];
    //get the array of recipes within that category and pass it to the next view
    NSMutableArray *r = [model getRecipesByCategory:category];
    secondView.title = category;
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
