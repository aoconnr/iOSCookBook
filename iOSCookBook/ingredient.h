//
//  ingredient.h
//  iOSCookBook
//
//  Created by Natalie on 15/01/2013.
//  Copyright (c) 2013 Andrew O'Connor. All rights reserved.
//
// Represents an ingredient including its name and ordering

#import <Foundation/Foundation.h>

@interface ingredient : NSObject

@property (assign) NSInteger ingId;
@property (strong) NSString *name;
@property (assign) NSInteger order;

-(id)initWithIngredient:(NSString*)i order:(int)o;

@end