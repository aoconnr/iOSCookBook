//
//  BrowseViewController.h
//  iOSCookBook
//
//  Created by Andrew O'Connor on 13/01/2013.
//  Copyright (c) 2013 Andrew O'Connor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowseViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *menu;
@property (nonatomic, strong) NSArray *menuItems;

@end
