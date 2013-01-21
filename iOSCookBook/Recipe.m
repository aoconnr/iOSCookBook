//
//  Recipe.m
//  iOSCookBook
//
//  Created by Natalie on 11/01/2013.
//  Copyright (c) 2013 Andrew O'Connor. All rights reserved.
//

#import "Recipe.h"

@implementation Recipe

@synthesize name, rId, categories, cookTime, photo, prepTime, quantity, favourite, rating, ingredients, instructions;


//initalise the recipe with empty values
-(id)init{
    self = [super init];
    if (self) {
        name = @"";
        cookTime = 0;
        photo = @"";
        prepTime = 0;
        quantity = 0;
        favourite = false;
        rating = 0;
        ingredients = [NSMutableArray new];
        instructions = [NSMutableArray new];
        categories = [NSMutableArray new];
        
    }
    return self;
}

//initialise to the given values
-(id)initWithrId:(int) rid name:(NSString *)n categories:(NSMutableArray *)c quantity:(int)q photo:(NSString *)p favourite:(int)f rating:(int)r prep:(int)prep cook:(int)cook instructions:(NSMutableArray *)ins ingredients:(NSMutableArray *)ing{
    self = [super init];
    if (self){
        rId = rid;
        name = n;
        categories = c;
        quantity = q;
        photo = p;
        favourite = f;
        rating = r;
        prepTime = prep;
        cookTime = cook;
        instructions = ins;
        ingredients = ing;
    }
    return self;
}

//initilize with given values, when no recipe id is available
-(id)initWithName:(NSString *)n categories:(NSMutableArray *)c quantity:(int)q photo:(NSString *)p favourite:(int)f rating:(int)r prep:(int)prep cook:(int)cook instructions:(NSMutableArray *)ins ingredients:(NSMutableArray *)ing{
    self = [super init];
    if (self){
        name = n;
        categories = c;
        quantity = q;
        photo = p;
        favourite = f;
        rating = r;
        prepTime = prep;
        cookTime = cook;
        instructions = ins;
        ingredients = ing;
    }
    return self;
}


@end
