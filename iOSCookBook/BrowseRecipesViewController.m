//
//  BrowseRecipesViewController.m
//  iOSCookBook
//
//  Created by Andrew O'Connor on 18/01/2013.
//  Copyright (c) 2013 Andrew O'Connor. All rights reserved.
//

#import "BrowseRecipesViewController.h"

@interface BrowseRecipesViewController ()

@end

@implementation BrowseRecipesViewController
@synthesize recipeList, model;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    self.title = @"Recipes";
     model = [iOSCookBookModel new];
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
  cell.textLabel.text = [tableViewData objectAtIndex:indexPath.row][0];
  
  UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
  //imgView.image = [UIImage imageNamed:@"DefaultRecipePic.gif"];
  imgView.image = [tableViewData objectAtIndex:indexPath.row][2];
  cell.imageView.image = imgView.image;
  
  return cell;
}

-(void)tableView: (UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //get the selected row's recipe id
    NSArray *rec = [tableViewData objectAtIndex:indexPath.row];
    int selected = [[rec objectAtIndex:1] intValue];
    RecipeViewController *thirdView = [[RecipeViewController alloc] initWithNibName:@"RecipeViewController" bundle:nil];
    //send the selected recipe to the next view
    Recipe *r = [model getRecipe:selected];
    thirdView.recipe = r;
  [self.navigationController pushViewController:thirdView animated:TRUE];
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //delete the selected recipe
    NSArray *rec = [tableViewData objectAtIndex:indexPath.row];
    int selected = [[rec objectAtIndex:1] intValue];
    [tableViewData removeObjectAtIndex:indexPath.row];
    [model deleteRecipe:selected];
}

- (void)tableView:(UITableView *)tableView
didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView reloadData];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
    
    tableViewData = recipeList;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
