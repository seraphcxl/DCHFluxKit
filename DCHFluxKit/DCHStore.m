//
//  DCHStore.m
//  DCHFluxKit
//
//  Created by Derek Chen on 3/22/15.
//  Copyright (c) 2015 seraphcxl. All rights reserved.
//

#import "DCHStore.h"
#import "DCHEventOperationTicket.h"
#import <Tourbillon/DCHTourbillon.h>

@implementation DCHStore

- (void)dealloc {
    do {
        ;
    } while (NO);
}

#pragma mark - DCHEventResponder
- (BOOL)respondEvent:(id <DCHEvent>)event from:(id)source withCompletionHandler:(DCHEventResponderCompletionHandler)completionHandler {
    return NO;
}

- (BOOL)respondEvent:(id <DCHEvent>)event dependOn:(DCHStore *)store {
    BOOL result = NO;
    do {
        if (!event || !store || self == store) {
            break;
        }
        result = [store addEventResponder:self forEvent:event];
    } while (NO);
    return result;
}

- (BOOL)respondEventDomain:(NSString *)eventDomain code:(NSUInteger)eventCode dependOn:(DCHStore *)store {
    BOOL result = NO;
    do {
        if (!eventDomain || [eventDomain isEqualToString:@""] || !store || self == store) {
            break;
        }
        result = [store addEventResponder:self forEventDomain:eventDomain code:eventCode];
    } while (NO);
    return result;
}

- (DCHEventOperationTicket *)emitChangeWithEvent:(id <DCHEvent>)event {
    return [self emitChangeWithEvent:event inMainThread:[NSThread isMainThread] withCompletionHandler:^(id eventResponder, id <DCHEvent> outputEvent, NSError *error) {
        ;
    }];
}

- (DCHEventOperationTicket *)emitChangeWithEvent:(id <DCHEvent>)event andCompletionHandler:(DCHEventResponderCompletionHandler)completionHandler {
    return [self emitChangeWithEvent:event inMainThread:[NSThread isMainThread] withCompletionHandler:completionHandler];
}

- (DCHEventOperationTicket *)emitChangeWithEvent:(id <DCHEvent>)event inMainThread:(BOOL)isInMainThread withCompletionHandler:(DCHEventResponderCompletionHandler)completionHandler {
    DCHEventOperationTicket *result = nil;
    do {
        if (!event || !completionHandler) {
            break;
        }
        result = [self handleEvent:event inMainThread:isInMainThread withResponderCallback:completionHandler];
    } while (NO);
    return result;
}

@end
