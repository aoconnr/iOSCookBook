//
//  instruction.h
//  iOSCookBook
//
//  Created by Natalie on 15/01/2013.
//  Copyright (c) 2013 Andrew O'Connor. All rights reserved.
//
//Represents an individual instruction for a recipe, including its name, order, and the assiciated timer (if present)

#import <Foundation/Foundation.h>

@interface instruction : NSObject

@property (assign) NSInteger insId;
@property (strong) NSString *name;
@property (assign) NSInteger order;
@property (assign) int timer;

-(id)initWithInstruction:(NSString*)i order:(int)o timer:(int)t;
@end
