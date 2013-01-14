//
//  BrowseViewController.h
//  iOSCookBook
//
//  Created by Andrew O'Connor on 13/01/2013.
//  Copyright (c) 2013 Andrew O'Connor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowseViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *menu;
@property (nonatomic, strong) NSArray *MenuItems;

@end
