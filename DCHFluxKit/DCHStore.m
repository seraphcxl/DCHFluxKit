//
//  DCHStore.m
//  DCHFluxKit
//
//  Created by Derek Chen on 3/22/15.
//  Copyright (c) 2015 seraphcxl. All rights reserved.
//

#import "DCHStore.h"
#import "DCHEventOperationTicket.h"

@implementation DCHStore

@synthesize inputEvent = _inputEvent;
@synthesize outputEvent = _outputEvent;

- (void)dealloc {
    do {
        self.outputEvent = nil;
        self.inputEvent = nil;
    } while (NO);
}

#pragma mark - DCHEventResponder
- (BOOL)respondEvent:(id <DCHEvent>)event withCompletionHandler:(DCHEventResponderCompletionHandler)completionHandler {
    return NO;
}

- (BOOL)respondEvent:(id <DCHEvent>)event waitFor:(DCHEventObserver *)eventObserver {
    BOOL result = NO;
    do {
        if (!event || !eventObserver || self == eventObserver) {
            break;
        }
        result = [eventObserver addEventResponder:self forEvent:event];
    } while (NO);
    return result;
}

- (DCHEventOperationTicket *)emitChange {
    return [self emitChangeWithEvent:self.outputEvent];
}

- (DCHEventOperationTicket *)emitChangeWithEvent:(id <DCHEvent>)event {
    DCHEventOperationTicket *result = nil;
    do {
        if (!event) {
            break;
        }
        result = [self handleEvent:event withResponderCallback:^(id eventResponder, id<DCHEvent> outputEvent, NSError *error) {
            if (error) {
                NSLog(@"%@", error);
            }
        }];
    } while (NO);
    return result;
}

@end
