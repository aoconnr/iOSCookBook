//
//  iOSCookBookModel.h
//  iOSCookBook
//
//  Created by Natalie on 11/01/2013.
//  Copyright (c) 2013 Andrew O'Connor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Recipe.h"


@interface iOSCookBookModel : NSObject


@property (strong) NSString *databaseName;
@property (strong) NSString *databasePath;

-(id)init;
-(Recipe*)getRecipe:(NSInteger)n;
-(void)addRecipe:(Recipe*)r;
-(NSArray*)getRecipes;
-(NSArray*)getFavourites;
-(NSArray*)getCatergories;
-(NSArray*)getRecipesByCategory:(NSString*)s;

@end
