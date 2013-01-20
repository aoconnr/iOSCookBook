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


@interface RecipeViewController (){
  AVAudioPlayer *avPlayer;
}

@end

@implementation RecipeViewController
@synthesize selectedData, model, recipe;

UITextView *ingredList, *instrList, *catList;
UILabel *ingredLabel, *instrLabel, *catLabel, *name, *servings, *prepTime, *cookTime, *favLabel;
UIButton *timerExample;
UIImageView *imageView;
NSTimer *timer;
BOOL *timerRunning = FALSE;
//test items ---
int timeRemaining= 3;
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
  timeRemaining = [[testTimers objectAtIndex:[sender tag]] intValue]*60;
  timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(tick) userInfo:nil repeats:YES];
  timerRunning = TRUE;
}

-(void)tick{
  timeRemaining--;
  UIButton *timerButton = [self.scroller viewWithTag:buttonTag];
  int minutes = timeRemaining/60;
  int seconds = timeRemaining%60;
  if(timeRemaining<60)
    [timerButton setTitle:[NSString stringWithFormat:@"%i",seconds] forState:UIControlStateNormal];
  else
    [timerButton setTitle:[NSString stringWithFormat:@"%i:%i",minutes,seconds] forState:UIControlStateNormal];
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

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
  [self.scroller setScrollEnabled:TRUE];
  
  
  name = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, 110, 30)];
  name.text = [NSString stringWithFormat:@"%@",recipe.name];
  [self.scroller addSubview:name];
  
  imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 40, 100, 100)];
  imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",recipe.photo]];
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
    int plotY = 0;
    for (ingredient *i in recipe.ingredients){
        UITextView *ingredList = [[UITextView alloc] initWithFrame:CGRectMake(5, 205 + plotY, 300, 60)];
        ingredList.editable = FALSE;
        ingredList.scrollEnabled = FALSE;
        ingredList.text = i.name;
        [self.scroller addSubview:ingredList];
        plotY += 20;
    }
  
  instrLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 280, 150, 30)];
  instrLabel.font = [UIFont systemFontOfSize:20];
  instrLabel.text = @"Instructions";
  [self.scroller addSubview:instrLabel];
  
  int y_plot = 320;
  
  //Remains of some data used while testing timers
  /*testInstr = [NSMutableArray arrayWithObjects:@"Step one",@"Step two: this one has a timer added to it. the previous has a timer value of 0",@"Step3",@"Step4",@"Step5",@"Step6", nil];
  testTimers = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:1],[NSNumber numberWithInt:3],[NSNumber numberWithInt:0],[NSNumber numberWithInt:2],[NSNumber numberWithInt:9], nil];
  for (int i=0; i<[testInstr count]; i++){ */
  for (instruction *i in recipe.instructions){
    z++;
    int timerValue = [[testTimers objectAtIndex:i] intValue];
    if (timerValue > 0) {
      aButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
      aButton.frame = CGRectMake(5, y_plot+40, 150, 20);
      [aButton addTarget:self action:@selector(timerStart:) forControlEvents:UIControlEventTouchUpInside];
      [aButton setTitle:@"Timer" forState:UIControlStateNormal];
      [aButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      [aButton setTitle:[NSString stringWithFormat:@"Timer: %i:00",timerValue] forState:UIControlStateNormal];
      aButton.tag = i;
      [self.scroller addSubview:aButton];
    }
    aLabel = [[UITextView alloc] initWithFrame:CGRectMake(5, y_plot, 300, 40)];
    aLabel.text = [NSString stringWithFormat:@"%i. %@", i.order, i.name];
    aLabel.editable = FALSE;
    //+100 prevents values overlapping and related tags are always easy to get
    //dont know if we need to mess with the text after output just thought I'd leave it for now.
    aLabel.tag = z+100;
    [self.scroller addSubview:aLabel];
    y_plot += 65;
  }
  /*
    for (instruction *i in recipe.instructions){
        instrList = [[UITextView alloc] initWithFrame:CGRectMake(5, 320, 250, 60)];
        instrList.editable = FALSE;
        instrList.scrollEnabled = FALSE;
        instrList.text = [NSString stringWithFormat:@"%i. %@", i.order, i.name];
        [self.scroller addSubview:instrList];
    }
  */
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
    }
    
    favLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, y_plot+200, 200, 30)];
    favLabel.font = [UIFont systemFontOfSize:18];
    favLabel.text = @"Set as a favourite recipe:";
    [self.scroller addSubview:favLabel];
    
    favourite = [[UISwitch alloc] initWithFrame:CGRectMake(230, y_plot +200, 0, 0)];
    [favourite setOn:recipe.favourite];
    [favourite addTarget:self action:@selector(setFavourite:) forControlEvents:UIControlEventValueChanged];
    
    [self.scroller addSubview:favourite];
    [self.scroller setContentSize:CGSizeMake(320, y_plot+250)];
  
  
  NSString *stringPath = [[NSBundle mainBundle] pathForResource:@"alarmclock" ofType:@"mp3"];
  NSURL *url = [NSURL fileURLWithPath:stringPath];
  
  NSError *error;
  
  avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
  [avPlayer setNumberOfLoops:2];
  [avPlayer setVolume:1.0];
}


-(void)setFavourite:(id)sender{
    
    if (favourite.on){
        [model setFavouriteForRecipeID:recipe.rId to:1];
    }
    else {
        [model setFavouriteForRecipeID:recipe.rId to:0];
    }
    
    
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
