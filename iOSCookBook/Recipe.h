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
@property (strong) NSMutableArray *categories;
@property (assign) NSInteger quantity;
@property (assign) BOOL favourite;
@property (assign) NSInteger rating;
@property (assign) NSInteger prepTime;
@property (assign) NSInteger cookTime;
@property (strong) NSMutableArray *ingredients;
@property (strong) NSMutableArray *instructions;

-(id)initWithRId:(NSInteger)rID;
-(id)initWithrId:(int) rid name:(NSString*)n categories:(NSMutableArray*)c quantity:(int)q photo:(NSString*)p favourite:(int)f rating:(int)r prep:(int)prep cook:(int)cook instructions:(NSMutableArray*)ins ingredients:(NSMutableArray*)ing;
@end
