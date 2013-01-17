//
//  instruction.h
//  iOSCookBook
//
//  Created by Natalie on 15/01/2013.
//  Copyright (c) 2013 Andrew O'Connor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface instruction : NSObject

@property (assign) NSInteger insId;
@property (assign) NSString *name;
@property (assign) NSInteger order;

-(id)initWithInstruction:(NSString*)i order:(int)o;
@end
