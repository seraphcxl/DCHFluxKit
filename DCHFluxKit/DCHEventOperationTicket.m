//
//  DCHEventOperationTicket.m
//  DCHFluxKit
//
//  Created by Derek Chen on 3/24/15.
//  Copyright (c) 2015 seraphcxl. All rights reserved.
//

#import "DCHEventOperationTicket.h"
#import "NSObject+DCHUUIDExtension.h"

@interface DCHEventOperationTicket ()

@property (nonatomic, copy) id <DCHEvent> event;

@end

@implementation DCHEventOperationTicket

@synthesize event = _event;
@synthesize working = _working;
@synthesize canceled = _canceled;
@synthesize finished = _finished;

- (void)dealloc {
    do {
        self.event = nil;
    } while (NO);
}

- (instancetype)initWithEvent:(id<DCHEvent>)event {
    if (!event) {
        return nil;
    }
    self = [self init];
    if (self) {
        self.event = event;
    }
    return self;
}

- (NSString *)UUID {
    return [self createMemoryID];
}

@end
