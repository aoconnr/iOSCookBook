//
//  instruction.m
//  iOSCookBook
//
//  Created by Natalie on 15/01/2013.
//  Copyright (c) 2013 Andrew O'Connor. All rights reserved.
//

#import "instruction.h"

@implementation instruction


-(id)initWithInstruction:(NSString *)i order:(int)o{
    self = [super init];
    if (self){
        self.name = i;
        self.order = o;
    }
    return self;
}
@end