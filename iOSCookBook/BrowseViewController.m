//
//  BrowseViewController.m
//  iOSCookBook
//
//  Created by Andrew O'Connor on 13/01/2013.
//  Copyright (c) 2013 Andrew O'Connor. All rights reserved.
//

#import "BrowseViewController.h"
#import "RecipeViewController.h"

@interface BrowseViewController ()

@end

@implementation BrowseViewController
@synthesize menu, menuItems;


//Table view data source------------------------------

// Return the number of sections.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  // Return the number of rows in the section.
  // Usually the number of items in your array (the one that holds your list)
  return [menuItems count];
}

// Configure the cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell;
  
  cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  
  cell.textLabel.text = [menuItems objectAtIndex:indexPath.row];
  return cell;
}

//Table view delegate---------------------------------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  // Navigation logic may go here. Create and push another view controller.
  // If you want to push another view upon tapping one of the cells on your table.
  switch (indexPath.row) {
    case 0:
      NSLog([NSString stringWithFormat:@"%i", 0]);
      break;
    case 1:
      NSLog([NSString stringWithFormat:@"%i", 1]);
      break;
    case 2:
      NSLog([NSString stringWithFormat:@"%i", 2]);
      break;
    case 3:
      NSLog([NSString stringWithFormat:@"%i", 3]);
      break;
    case 4:
      NSLog([NSString stringWithFormat:@"%i", 4]);
      break;
    case 5:
      NSLog([NSString stringWithFormat:@"%i", 5]);
      break;
      
    default:
      break;
  }
   RecipeViewController *detailViewController = [[RecipeViewController alloc] initWithNibName:nil bundle:nil];
   // ...
   // Pass the selected object to the new view controller.
   //[self.navigationController pushViewController:detailViewController animated:YES];
  [self presentViewController:detailViewController animated:TRUE completion:nil];
   
}

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
  menuItems = [[NSArray alloc] initWithObjects:@"Item No. 0", @"Item No. 1", @"Item No. 2", @"Item No. 3", @"Item No. 4", @"Item No. 5", nil];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
