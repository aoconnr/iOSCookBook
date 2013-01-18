//
//  time.h
//  iOSCookBook
//
//  Created by Natalie on 18/01/2013.
//  Copyright (c) 2013 Andrew O'Connor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface timer : NSObject


@property (assign) int secs;
@property (assign) int mins;
@property (assign) int hours;

-(id)initWithSeconds:(int)s;

-(NSString*)getTimeAsString;

-(NSString*)secondsToTimeString:(int)s;
@end