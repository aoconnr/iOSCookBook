//
//  time.m
//  iOSCookBook
//
//  Created by Natalie on 18/01/2013.
//  Copyright (c) 2013 Andrew O'Connor. All rights reserved.
//

#import "timer.h"


@implementation timer

@synthesize secs, mins, hours;

-(id)initWithSeconds:(int)s{
    self = [super init];
    if (self){
        secs = s % 60;
        mins = s/60;
        hours = mins/60;
        mins = mins%60;
    }
    return self;
}

-(NSString*)getTimeAsString{
    NSString *time = [NSString new];
    
    return time;
}

-(NSString*)secondsToTimeString:(int)s{
    secs = s % 60;
    mins = s/60;
    hours = mins/60;
    mins = mins%60;
    return[NSString stringWithFormat:@"%02i:%02i:%02i", hours, mins, secs];
}


@end
