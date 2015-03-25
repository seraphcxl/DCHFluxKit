//
//  DCHDispatcher.m
//  DCHFluxKit
//
//  Created by Derek Chen on 3/22/15.
//  Copyright (c) 2015 seraphcxl. All rights reserved.
//

#import "DCHDispatcher.h"

@implementation DCHDispatcher

- (void)dealloc {
    do {
        self.parent = nil;        
    } while (NO);
}

- (NSArray *)handleEvent:(id <DCHEvent>)event withResponderCallback:(DCHEventResponderCompletionHandler)callback {
    NSArray *result = nil;
    do {
        if (!event) {
            break;
        }
        
        NSMutableArray *tmpResult = [NSMutableArray array];
        
        DCHEventOperationTicket *ticket = [super handleEvent:event withResponderCallback:callback];
        if (ticket) {
            [tmpResult addObject:ticket];
        }
        if (self.parent) {
            NSArray *tmpAry = [self.parent handleEvent:event withResponderCallback:^(id eventResponder, id <DCHEvent> outputEvent, NSError *error) {
                if (callback) {
                    callback(eventResponder, outputEvent, error);
                }
            }];
            if (tmpAry) {
                [tmpResult addObjectsFromArray:tmpAry];
            }
        }
        
        if (tmpResult && tmpResult.count > 0) {
            result = tmpResult;
        }
    } while (NO);
    return result;
}

@end
