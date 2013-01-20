//
//  BrowseFavouritesViewController.h
//  iOSCookBook
//
//  Created by Andrew O'Connor on 19/01/2013.
//  Copyright (c) 2013 Andrew O'Connor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iOSCookBookModel.h"

@interface BrowseFavouritesViewController : UIViewController{
  NSMutableArray *tableViewData;
}

@property (strong) iOSCookBookModel *model;

@end
