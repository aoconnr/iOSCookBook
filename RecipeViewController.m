//
//  RecipeViewController.m
//  iOSCookBook
//
//  Created by Andrew O'Connor on 13/01/2013.
//  Copyright (c) 2013 Andrew O'Connor. All rights reserved.
//

#import "RecipeViewController.h"
#import "ViewController.h"
#import "ingredient.h"
#import "instruction.h"
#import "DYRateView.h"

@interface RecipeViewController (){
  AVAudioPlayer *avPlayer;
}

@end

@implementation RecipeViewController
@synthesize selectedData, model, recipe, timeRemaining;

UITextView *ingredList, *instrList, *catList;
UILabel *ingredLabel, *instrLabel, *catLabel, *name, *servings, *prepTime, *cookTime, *favLabel;
UIButton *timerExample, *twitterButton;
UIImageView *imageView;
NSTimer *timer;
BOOL *timerRunning = FALSE;
NSMutableDictionary *timerDict;
//test items ---
//int timeRemaining = 10;
int z;
int buttonTag;
UIButton *aButton;
UITextView *aLabel;
NSMutableArray *testInstr, *testTimers;
UISwitch *favourite;
//--------------


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    
    self.title = @"Recipe";
    model = [[iOSCookBookModel alloc] init];
  }
  return self;
}

-(void)timerStart:(id)sender{
  //TODO: Add alert for user about cancelling timer
  if (timerRunning == TRUE) {
    [timer invalidate];
    UIButton *timerButton = [self.scroller viewWithTag:buttonTag];
    [timerButton setTitle:[NSString stringWithFormat:@"Timer: %i:00",[[testTimers objectAtIndex:buttonTag] intValue]] forState:UIControlStateNormal];
  }
  buttonTag = [sender tag];
  timeRemaining = [sender tag];
  timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(tick) userInfo:nil repeats:YES];
  timerRunning = TRUE;
}

-(void)tick{
  timeRemaining--;

  UIButton *timerButton = [self.scroller viewWithTag:buttonTag];
  int hours = timeRemaining/3600;
  int minutes = (timeRemaining%3600)/60;
  int seconds = timeRemaining%60;
  if(timeRemaining<60)
    [timerButton setTitle:[NSString stringWithFormat:@"Timer: %i",seconds] forState:UIControlStateNormal];
  else if (timeRemaining < 3600)
    [timerButton setTitle:[NSString stringWithFormat:@"Timer: %i:%i",minutes,seconds] forState:UIControlStateNormal];
  else
    [timerButton setTitle:[NSString stringWithFormat:@"Timer: %i:%i:%i",hours,minutes,seconds] forState:UIControlStateNormal];
  if (timeRemaining==0) {
    [avPlayer play];
    [timerButton setTitle:[NSString stringWithFormat:@"Timer: %i:00",[[testTimers objectAtIndex:buttonTag] intValue]] forState:UIControlStateNormal];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Example" message:@"Example Timer finished" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [timer invalidate];
    timerRunning = FALSE;
  }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 0) {
    [avPlayer stop];
  }
}


-(IBAction)tweet{
  TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
  [twitter addImage:imageView.image];
  [twitter addURL:[NSURL URLWithString:@"https://twitter.com/"]];
  [twitter setInitialText:@"Sent by iOSCookBook test app"];
  twitter.completionHandler = ^(TWTweetComposeViewControllerResult result) {
    NSString *title = @"Twitter Status";
    NSString *msg;
    if (result == TWTweetComposeViewControllerResultCancelled) {
      msg = @"Tweet was cancelled";
    }
    else if (result == TWTweetComposeViewControllerResultDone){
      msg = @"Tweet was sent";
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [self dismissViewControllerAnimated:TRUE completion:nil];
  };
  [self presentModalViewController:twitter animated:TRUE];
  
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
  [self.scroller setScrollEnabled:TRUE];
  
  
  name = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, 110, 30)];
  name.text = [NSString stringWithFormat:@"%@",recipe.name];
  [self.scroller addSubview:name];
  
    
    //TODO: Set image
  imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 40, 100, 100)];
  imageView.image = recipe.photo;
  [self.scroller addSubview:imageView];
                    
                            
  servings = [[UILabel alloc] initWithFrame:CGRectMake(5, 140, 97, 30)];
  servings.text = [NSString stringWithFormat:@"Serves: %i",recipe.quantity];
  servings.font = [UIFont systemFontOfSize:15];
  [self.scroller addSubview:servings];
  
  prepTime = [[UILabel alloc] initWithFrame:CGRectMake(110, 140, 97, 30)];
  prepTime.font = [UIFont systemFontOfSize:15];
  prepTime.text = [NSString stringWithFormat:@"Prep time: %i",recipe.prepTime];
  [self.scroller addSubview:prepTime];
  
  cookTime = [[UILabel alloc] initWithFrame:CGRectMake(210, 140, 97, 30)];
  cookTime.font = [UIFont systemFontOfSize:15];
  cookTime.text = [NSString stringWithFormat:@"Cook time: %i",recipe.cookTime];
  [self.scroller addSubview:cookTime];
  
  ingredLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 175, 150, 30)];
  ingredLabel.font = [UIFont systemFontOfSize:20];
  ingredLabel.text = @"Ingredients";
  [self.scroller addSubview:ingredLabel];
  
  //TODO: Expand when text added
    int y_plot = 215;
    for (ingredient *i in recipe.ingredients){
        UITextView *ingredList = [[UITextView alloc] initWithFrame:CGRectMake(5, 0 + y_plot, 300, 20)];
        ingredList.editable = FALSE;
        ingredList.scrollEnabled = FALSE;
        ingredList.text = i.name;
        [self.scroller addSubview:ingredList];
        y_plot += 30;
    }
  
  instrLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, y_plot+45, 150, 30)];
  instrLabel.font = [UIFont systemFontOfSize:20];
  instrLabel.text = @"Instructions";
  [self.scroller addSubview:instrLabel];
  
  y_plot += 80;
  
  timerDict = [[NSMutableDictionary alloc] init];
  for (instruction *i in recipe.instructions){
    z++;
    int timerValue = i.timer;
    if (timerValue > 0) {
      int hours = timerValue/3600;
      int minutes = (timerValue%3600)/60;
      int seconds = timerValue%60;
      aButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
      aButton.frame = CGRectMake(5, y_plot+40, 150, 20);
      [aButton addTarget:self action:@selector(timerStart:) forControlEvents:UIControlEventTouchUpInside];
      [aButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      if(timerValue<60)
        [aButton setTitle:[NSString stringWithFormat:@"Timer: %i",seconds] forState:UIControlStateNormal];
      else if (timerValue < 3600)
        [aButton setTitle:[NSString stringWithFormat:@"Timer: %i:%i",minutes,seconds] forState:UIControlStateNormal];
      else
        [aButton setTitle:[NSString stringWithFormat:@"Timer: %i:%i:%i",hours,minutes,seconds] forState:UIControlStateNormal];
      aButton.tag = timerValue;
      [self.scroller addSubview:aButton];
    }
    aLabel = [[UITextView alloc] initWithFrame:CGRectMake(5, y_plot, 300, 40)];
    aLabel.text = [NSString stringWithFormat:@"%i. %@", i.order, i.name];
    aLabel.editable = FALSE;
    //+100 prevents values overlapping and related tags are always easy to get
    //dont know if we need to mess with the text after output just thought I'd leave it for now.
    aLabel.tag = i.order+100;
    [self.scroller addSubview:aLabel];
    y_plot += 65;
  }
  
  catLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, y_plot+80, 150, 30)];
  catLabel.font = [UIFont systemFontOfSize:20];
  catLabel.text = @"Categories";
  [self.scroller addSubview:catLabel];
  
    for (NSString *c in recipe.categories){
      catList = [[UITextView alloc] initWithFrame:CGRectMake(5, y_plot+120, 250, 30)];
      catList.editable = FALSE;
      catList.scrollEnabled = FALSE;
      catList.text = c;
      [self.scroller addSubview:catList];
        y_plot +=20;
    }
    
    //add the rating stars to the view
    DYRateView *rateView = [[DYRateView alloc] initWithFrame:CGRectMake(5, y_plot+140, 100, 14)];
    rateView.rate = recipe.rating;
    rateView.alignment=RateViewAlignmentLeft;
    rateView.editable=YES;
    rateView.delegate=self;
    [self.scroller addSubview:rateView];
    
    
    //Add a label to explain the favourites switch
    favLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, y_plot+200, 200, 30)];
    favLabel.font = [UIFont systemFontOfSize:18];
    favLabel.text = @"Set as a favourite recipe:";
    [self.scroller addSubview:favLabel];
    
    //Add the favourites switch to the view
    favourite = [[UISwitch alloc] initWithFrame:CGRectMake(230, y_plot +200, 0, 0)];
    [favourite setOn:recipe.favourite];
    [favourite addTarget:self action:@selector(setFavourite:) forControlEvents:UIControlEventValueChanged];
  
  twitterButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  twitterButton.frame = CGRectMake((210), y_plot+150, 100, 40);
  [twitterButton setTitle:@"Send Tweet" forState:UIControlStateNormal];
  [twitterButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [twitterButton addTarget:self action:@selector(tweet) forControlEvents:UIControlEventTouchDown];
  [self.scroller addSubview:twitterButton];
  
    [self.scroller addSubview:favourite];
    
    
    [self.scroller setContentSize:CGSizeMake(320, y_plot+250)];
  
  
  NSString *stringPath = [[NSBundle mainBundle] pathForResource:@"alarmclock" ofType:@"mp3"];
  NSURL *url = [NSURL fileURLWithPath:stringPath];
  
  NSError *error;
  
  avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
  [avPlayer setNumberOfLoops:2];
  [avPlayer setVolume:1.0];
}


//when the 'favourites' swtich is toggled, call the model method to set the favourites value in the db
-(void)setFavourite:(id)sender{
    
    if (favourite.on){
        [model setFavouriteForRecipeID:recipe.rId to:1];
    }
    else {
        [model setFavouriteForRecipeID:recipe.rId to:0];
    }
}


//When the rating stars are changed, call the model to save the new rating
-(void)rateView:(DYRateView *)rateView changedToNewRate:(NSNumber *)rate {
    
    [model setRatingForRecipeID:recipe.rId to:[rate intValue]];
}



- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
