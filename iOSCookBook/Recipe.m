//
//  Recipe.m
//  iOSCookBook
//
//  Created by Natalie on 11/01/2013.
//  Copyright (c) 2013 Andrew O'Connor. All rights reserved.
//

#import "Recipe.h"

@implementation Recipe

@synthesize name, rId, category, cookTime, photo, prepTime, quantity, favourite, rating;


-(id)init{
    self = [super init];
    return self;
}
@end
