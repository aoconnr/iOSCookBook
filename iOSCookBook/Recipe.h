//
//  Recipe.h
//  iOSCookBook
//
//  Created by Natalie on 11/01/2013.
//  Copyright (c) 2013 Andrew O'Connor. All rights reserved.
//
//  The Recipe class is an object which represents all the infomation of a single recipe.

#import <Foundation/Foundation.h>

@interface Recipe : NSObject

@property (assign) NSInteger rId;
@property (strong) NSString *name;
@property (strong) NSString *photo;
@property (strong) NSString *category;
@property (assign) NSInteger quantity;
@property (assign) BOOL favourite;
@property (assign) NSInteger rating;
@property (assign) NSInteger prepTime;
@property (assign) NSInteger cookTime;

-(id)init;

@end
