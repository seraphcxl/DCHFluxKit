//
//  DCHDispatcher.m
//  DCHFluxKit
//
//  Created by Derek Chen on 3/22/15.
//  Copyright (c) 2015 seraphcxl. All rights reserved.
//

#import "DCHDispatcherHub.h"
#import "DCHEvent.h"
#import "DCHIndexedArray.h"
#import "DCHDispatcher.h"
#import <Tourbillon/DCHTourbillon.h>

@interface DCHDispatcherHub ()

@property (nonatomic, strong) DCHIndexedArray *eventObserverAry;

@end

@implementation DCHDispatcherHub

- (void)dealloc {
    do {
        self.eventObserverAry = nil;
    } while (NO);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.eventObserverAry = [[DCHIndexedArray alloc] init];
    }
    return self;
}

- (void)addDispatcher:(DCHDispatcher *)dispatcher {
    do {
        if (!dispatcher) {
            break;
        }
        NSString *eventObserverUUID = [dispatcher createMemoryID];
        if ([self.eventObserverAry containsObjectWithIndex:eventObserverUUID]) {
            break;
        }
        [self.eventObserverAry addObject:dispatcher withIndex:eventObserverUUID];
    } while (NO);
}

- (void)removeDispatcher:(DCHDispatcher *)dispatcher {
    do {
        if (!dispatcher) {
            break;
        }
        NSString *eventObserverUUID = [dispatcher createMemoryID];
        [self.eventObserverAry removeObjectWithIndex:eventObserverUUID];
    } while (NO);
}

- (NSArray *)handleEvent:(id <DCHEvent>)event inMainThread:(BOOL)isInMainThread withResponderCallback:(DCHEventResponderCompletionHandler)callback {
    NSArray *result = nil;
    do {
        if (!event) {
            break;
        }
        
        NSMutableArray *tmpResult = [NSMutableArray array];
        
        [self.eventObserverAry enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            do {
                if (![obj isKindOfClass:[DCHEventObserver class]]) {
                    break;
                }
                DCHEventObserver *eventObserver = (DCHEventObserver *)obj;
                DCHEventOperationTicket *ticket = [eventObserver handleEvent:event inMainThread:isInMainThread withResponderCallback:callback];
                if (ticket) {
                    [tmpResult addObject:ticket];
                }
            } while (NO);
        }];
        
        if (tmpResult && tmpResult.count > 0) {
            result = tmpResult;
        }
    } while (NO);
    return result;
}

@end
