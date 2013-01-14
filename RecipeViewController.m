//
//  RecipeViewController.m
//  iOSCookBook
//
//  Created by Andrew O'Connor on 13/01/2013.
//  Copyright (c) 2013 Andrew O'Connor. All rights reserved.
//

#import "RecipeViewController.h"
#import "ViewController.h"

@interface RecipeViewController ()

@end

@implementation RecipeViewController

UITextView *ingredList, *instrList, *catList;
UILabel *ingredLabel, *instrLabel, *catLabel, *name, *servings, *prepTime, *cookTime;
UIButton *backButton;

-(IBAction)backPressed{
  ViewController *next = [[ViewController alloc] initWithNibName:nil bundle:nil];
  [self presentViewController:next animated:TRUE completion:nil];
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
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
  [self.scroller setScrollEnabled:TRUE];
  
  
  name = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, 110, 30)];
  name.text = @"Recipe Name";
  [self.scroller addSubview:name];
  
  servings = [[UILabel alloc] initWithFrame:CGRectMake(5, 40, 97, 30)];
  servings.text = @"Servings: 0";
  servings.font = [UIFont systemFontOfSize:15];
  [self.scroller addSubview:servings];
  
  prepTime = [[UILabel alloc] initWithFrame:CGRectMake(110, 40, 97, 30)];
  prepTime.font = [UIFont systemFontOfSize:15];
  prepTime.text = @"Prep Time: 0";
  [self.scroller addSubview:prepTime];
  
  cookTime = [[UILabel alloc] initWithFrame:CGRectMake(210, 40, 97, 30)];
  cookTime.font = [UIFont systemFontOfSize:15];
  cookTime.text = @"Cook Time: 0";
  [self.scroller addSubview:cookTime];
  
  ingredLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 75, 150, 30)];
  ingredLabel.font = [UIFont systemFontOfSize:20];
  ingredLabel.text = @"Ingredients";
  [self.scroller addSubview:ingredLabel];
  
  //TODO: Expand when text added
  ingredList = [[UITextView alloc] initWithFrame:CGRectMake(5, 105, 300, 60)];
  ingredList.editable = FALSE;
  ingredList.scrollEnabled = FALSE;
  ingredList.text = @"2 whole rabbits \n4 carrots \n1 litre veg stock";
  [self.scroller addSubview:ingredList];
  
  instrLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 180, 150, 30)];
  instrLabel.font = [UIFont systemFontOfSize:20];
  instrLabel.text = @"Instructions";
  [self.scroller addSubview:instrLabel];
  
  //TODO: add timer button to each line
  instrList = [[UITextView alloc] initWithFrame:CGRectMake(5, 220, 250, 60)];
  instrList.editable = FALSE;
  instrList.scrollEnabled = FALSE;
  instrList.text = @"1. we'll need to make this adjust with instruction size\n2. And how we store it\n3. Bill is being a little shit";
  [self.scroller addSubview:instrList];
  
  catLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 300, 150, 30)];
  catLabel.font = [UIFont systemFontOfSize:20];
  catLabel.text = @"Categories";
  [self.scroller addSubview:catLabel];
  
  catList = [[UITextView alloc] initWithFrame:CGRectMake(5, 340, 250, 30)];
  catList.editable = FALSE;
  catList.scrollEnabled = FALSE;
  catList.text = @"Testing";
  [self.scroller addSubview:catList];
  
  backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchDown];
  [backButton setTitle:@"Back" forState:UIControlStateNormal];
  backButton.frame = CGRectMake(210, 410, 100, 30);
  [self.scroller addSubview:backButton];
  
  [self.scroller setContentSize:CGSizeMake(320, 500)];
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
