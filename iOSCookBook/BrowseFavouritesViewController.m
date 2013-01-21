//
//  BrowseFavouritesViewController.m
//  iOSCookBook
//
//  Created by Andrew O'Connor on 19/01/2013.
//  Copyright (c) 2013 Andrew O'Connor. All rights reserved.
//

#import "BrowseFavouritesViewController.h"

@interface BrowseFavouritesViewController ()

@end

@implementation BrowseFavouritesViewController
@synthesize model;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        self.title = @"Favourites";
        //Get the recipes from the model which have been set as favourites
        model = [[iOSCookBookModel alloc] init];
        tableViewData = [model getFavourites];
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
  
  //TODO: Add correct images here
  UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
  imgView.image = [tableViewData objectAtIndex:indexPath.row][2];
  cell.imageView.image = imgView.image;
  
  return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //get the selected row's recipe id
    NSArray *rec = [tableViewData objectAtIndex:indexPath.row];
    int selected = [[rec objectAtIndex:1] intValue];
    RecipeViewController *thirdView = [[RecipeViewController alloc] initWithNibName:@"RecipeViewController" bundle:nil];

    //send the selected recipe to the next view
    Recipe *r = [model getRecipe:selected];
    thirdView.recipe = r;  [self.navigationController pushViewController:thirdView animated:TRUE];
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
