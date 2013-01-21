//
//  BrowseCategoriesViewController.h
//  iOSCookBook
//
//  Created by Andrew O'Connor on 18/01/2013.
//  Copyright (c) 2013 Andrew O'Connor. All rights reserved.
//
// This is the view which displays the different user-added categories, which can then be selected to see recipes within the selected category

#import <UIKit/UIKit.h>
#import "iOSCookBookModel.h"

@interface BrowseCategoriesViewController : UIViewController{
  NSArray *tableViewData;
}

@property (strong) iOSCookBookModel *model;
@end
