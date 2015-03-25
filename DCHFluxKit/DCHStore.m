//
//  DCHStore.m
//  DCHFluxKit
//
//  Created by Derek Chen on 3/22/15.
//  Copyright (c) 2015 seraphcxl. All rights reserved.
//

#import "DCHStore.h"
#import "DCHEventOperationTicket.h"
#import "DCHWeakWarpper.h"

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

//- (BOOL)respondEvent:(id <DCHEvent>)event waitFor:(NSArray *)eventResponders withCompletionHandler:(DCHEventResponderCompletionHandler)completionHandler {
//    BOOL result = NO;
//    do {
//        if (event == nil || eventResponders || eventResponders.count == 0) {
//            break;
//        }
//        if (eventResponders.count == 1) {
//            DCHWeakWarpper *weakWarpper = (DCHWeakWarpper *)[eventResponders objectAtIndex:0];
//            id <DCHEventResponder> eventResponder = weakWarpper.object;
//            [eventResponder respondEvent:event withCompletionHandler:^(id eventResponder, id<DCHEvent> outputEvent, NSError *error) {
//                [self respondEvent:outputEvent withCompletionHandler:^(id eventResponder, id<DCHEvent> outputEvent, NSError *error) {
//                    if (error) {
//                        NSLog(@"%@", error);
//                    }
//                }];
//            }];
//        } else if (eventResponders.count > 1) {
//            DCHWeakWarpper *weakWarpper = (DCHWeakWarpper *)[eventResponders lastObject];
//            id <DCHEventResponder> eventResponder = weakWarpper.object;
//            NSMutableArray *tmpEventResponders = [NSMutableArray arrayWithArray:eventResponders];
//            [tmpEventResponders removeLastObject];
//            [eventResponder respondEvent:event waitFor:tmpEventResponders withCompletionHandler:^(id eventResponder, id<DCHEvent> outputEvent, NSError *error) {
//                [self respondEvent:outputEvent withCompletionHandler:^(id eventResponder, id<DCHEvent> outputEvent, NSError *error) {
//                    if (error) {
//                        NSLog(@"%@", error);
//                    }
//                }];
//            }];
//        }
//        result = YES;
//    } while (NO);
//    return result;
//}

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
