//
//  instruction.m
//  iOSCookBook
//
//  Created by Natalie on 15/01/2013.
//  Copyright (c) 2013 Andrew O'Connor. All rights reserved.
//

#import "instruction.h"

@implementation instruction

@synthesize name, order, timer;

//initialises the instruction to the given values
-(id)initWithInstruction:(NSString *)i order:(int)o timer:(int)t{
    self = [super init];
    if (self){
        self.name = i;
        self.order = o;
        self.timer = t;
    }
    return self;
}
@end
