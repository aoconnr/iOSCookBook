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
#import "ingredient.h"
#import "instruction.h"

@interface iOSCookBookModel : NSObject


@property (strong) NSString *databaseName;
@property (strong) NSString *databasePath;

-(id)init;
-(Recipe*)getRecipe:(int)n;
-(void)addRecipe:(Recipe*)r;

-(NSMutableArray*)getFavourites;
-(NSMutableArray*)getCategories;
-(NSMutableArray*)getRecipesByCategory:(NSString*)s;
-(void)addPhoto:(NSString*)photo toRecipe:(int)r;
-(void)deleteRecipe:(int)r;

@end
