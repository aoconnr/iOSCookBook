//
//  BrowseRecipesViewController.h
//  iOSCookBook
//
//  Created by Andrew O'Connor on 18/01/2013.
//  Copyright (c) 2013 Andrew O'Connor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowseRecipesViewController : UIViewController{
  NSMutableArray *tableViewData;
  
  int rowSelectedPreviously;
}

@property (nonatomic) int rowSelectedPreviously;
@end
