//
//  RecipeViewController.m
//  iOSCookBook
//
//  Created by Andrew O'Connor on 13/01/2013.
//  Copyright (c) 2013 Andrew O'Connor. All rights reserved.
//

#import "RecipeViewController.h"
#import "ViewController.h"

@interface RecipeViewController (){
  AVAudioPlayer *avPlayer;
}

@end

@implementation RecipeViewController
@synthesize selectedData;

UITextView *ingredList, *instrList, *catList;
UILabel *ingredLabel, *instrLabel, *catLabel, *name, *servings, *prepTime, *cookTime;
UIButton *timerExample;
UIImageView *imageView;
NSTimer *timer;

//test timer delay
int t= 3;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    
    self.title = @"Recipe";
  }
  return self;
}

-(void)timerStart{
  timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(tick) userInfo:nil repeats:YES];
}

-(void)tick{
  t--;
  if (t==0) {
    [avPlayer play];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Example" message:@"Example Timer finished" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
  }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 0) {
    [avPlayer stop];
  }
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
  [self.scroller setScrollEnabled:TRUE];
  
  
  name = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, 110, 30)];
//  name.text = @"Recipe Name";
  name.text = selectedData;
  [self.scroller addSubview:name];
  
  imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 40, 100, 100)];
  imageView.backgroundColor = [UIColor orangeColor];
  imageView.image = [UIImage imageNamed:@"DefaultRecipePic.gif"];
  [self.scroller addSubview:imageView];
  
  servings = [[UILabel alloc] initWithFrame:CGRectMake(5, 140, 97, 30)];
  servings.text = @"Servings: 0";
  servings.font = [UIFont systemFontOfSize:15];
  [self.scroller addSubview:servings];
  
  prepTime = [[UILabel alloc] initWithFrame:CGRectMake(110, 140, 97, 30)];
  prepTime.font = [UIFont systemFontOfSize:15];
  prepTime.text = @"Prep Time: 0";
  [self.scroller addSubview:prepTime];
  
  cookTime = [[UILabel alloc] initWithFrame:CGRectMake(210, 140, 97, 30)];
  cookTime.font = [UIFont systemFontOfSize:15];
  cookTime.text = @"Cook Time: 0";
  [self.scroller addSubview:cookTime];
  
  ingredLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 175, 150, 30)];
  ingredLabel.font = [UIFont systemFontOfSize:20];
  ingredLabel.text = @"Ingredients";
  [self.scroller addSubview:ingredLabel];
  
  //TODO: Expand when text added
  ingredList = [[UITextView alloc] initWithFrame:CGRectMake(5, 205, 300, 60)];
  ingredList.editable = FALSE;
  ingredList.scrollEnabled = FALSE;
  ingredList.text = @"2 whole rabbits \n4 carrots \n1 litre veg stock";
  [self.scroller addSubview:ingredList];
  
  instrLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 280, 150, 30)];
  instrLabel.font = [UIFont systemFontOfSize:20];
  instrLabel.text = @"Instructions";
  [self.scroller addSubview:instrLabel];
  
  //TODO: add timer button to each line
  instrList = [[UITextView alloc] initWithFrame:CGRectMake(5, 320, 250, 60)];
  instrList.editable = FALSE;
  instrList.scrollEnabled = FALSE;
  instrList.text = @"1. we'll need to make this adjust with instruction size\n2. And how we store it. Timer:4:00\n3. Bill is being a little shit";
  [self.scroller addSubview:instrList];
  
  timerExample = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [timerExample addTarget:self action:@selector(timerStart) forControlEvents:UIControlEventTouchDown];
  [timerExample setTitle:@"Timer" forState:UIControlStateNormal];
  [timerExample setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  timerExample.frame = CGRectMake(220, 320, 80, 15);
  [self.scroller addSubview:timerExample];
  
  catLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 400, 150, 30)];
  catLabel.font = [UIFont systemFontOfSize:20];
  catLabel.text = @"Categories";
  [self.scroller addSubview:catLabel];
  
  catList = [[UITextView alloc] initWithFrame:CGRectMake(5, 440, 250, 30)];
  catList.editable = FALSE;
  catList.scrollEnabled = FALSE;
  catList.text = @"Testing";
  [self.scroller addSubview:catList];
  
  [self.scroller setContentSize:CGSizeMake(320, 550)];
  
  
  NSString *stringPath = [[NSBundle mainBundle] pathForResource:@"alarmclock" ofType:@"mp3"];
  NSURL *url = [NSURL fileURLWithPath:stringPath];
  
  NSError *error;
  
  avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
  [avPlayer setNumberOfLoops:2];
  [avPlayer setVolume:1.0];
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
