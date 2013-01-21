//
//  RecipeViewController.h
//  iOSCookBook
//
//  Created by Andrew O'Connor on 13/01/2013.
//  Copyright (c) 2013 Andrew O'Connor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Twitter/Twitter.h>
#import "Recipe.h"
#import "iOSCookBookModel.h"

@interface RecipeViewController : UIViewController{
  NSString *selectedData;
  SLComposeViewController *slcomposeViewController;
}
@property (assign) int timeRemaining;

@property (nonatomic, readwrite, copy) NSString *selectedData;
@property (weak, nonatomic) IBOutlet UIScrollView *scroller;
@property (strong, nonatomic) Recipe *recipe;
@property (strong, nonatomic) iOSCookBookModel *model;

-(void)setFavourite:(id)sender;
-(IBAction)tweet;
@end
