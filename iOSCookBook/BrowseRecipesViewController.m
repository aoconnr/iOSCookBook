//
//  BrowseRecipesViewController.m
//  iOSCookBook
//
//  Created by Andrew O'Connor on 18/01/2013.
//  Copyright (c) 2013 Andrew O'Connor. All rights reserved.
//

#import "BrowseRecipesViewController.h"
#import "RecipeViewController.h"

@interface BrowseRecipesViewController ()

@end

@implementation BrowseRecipesViewController
@synthesize rowSelectedPreviously;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    self.title = @"Recipes";
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

-(void)tableView: (UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  NSString *selected = [tableViewData objectAtIndex:indexPath.row];
  RecipeViewController *thirdView = [[RecipeViewController alloc] initWithNibName:@"RecipeViewController" bundle:nil];
  thirdView.selectedData = selected;
  [self.navigationController pushViewController:thirdView animated:TRUE];
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableViewData removeObjectAtIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView
didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView reloadData];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  if (rowSelectedPreviously == 0) {
    tableViewData = [NSMutableArray arrayWithObjects:@"Recipe 0",@"Recipe 1", nil];
  }
  else if(rowSelectedPreviously == 1){
    tableViewData = [NSMutableArray arrayWithObjects:@"Recipe 2",@"Recipe 3", nil];
  }
  else{
    tableViewData = [NSMutableArray arrayWithObjects:@"Recipe 6",@"Recipe 16", nil];
  }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
