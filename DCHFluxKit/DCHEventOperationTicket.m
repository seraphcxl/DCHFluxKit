//
//  DCHEventOperationTicket.m
//  DCHFluxKit
//
//  Created by Derek Chen on 3/24/15.
//  Copyright (c) 2015 seraphcxl. All rights reserved.
//

#import "DCHEventOperationTicket.h"
#import "DCHEventObserver.h"
#import <Tourbillon/DCHTourbillon.h>

@interface DCHEventOperationTicket ()

@property (nonatomic, copy) id <DCHEvent> event;
@property (nonatomic, weak) id eventHandler;

@end

@implementation DCHEventOperationTicket

@synthesize event = _event;
@synthesize eventHandler = _eventHandler;
@synthesize working = _working;
@synthesize canceled = _canceled;
@synthesize finished = _finished;

- (void)dealloc {
    do {
        self.eventHandler = nil;
        self.event = nil;
    } while (NO);
}

- (instancetype)initWithEvent:(id <DCHEvent>)event andHandler:(id)handler {
    if (!event || !handler) {
        return nil;
    }
    self = [self init];
    if (self) {
        self.event = event;
        self.eventHandler = handler;
    }
    return self;
}

- (NSString *)UUID {
    return [self dch_createMemoryID];
}

@end
