//
//  ingredient.m
//  iOSCookBook
//
//  Created by Natalie on 15/01/2013.
//  Copyright (c) 2013 Andrew O'Connor. All rights reserved.
//

#import "ingredient.h"

@implementation ingredient
@synthesize name, order;


-(id)initWithIngredient:(NSString *)i order:(int)o{
    self = [super init];
    if (self){
        self.name = i;
        self.order = o;
    }
    return self;
}
@end
