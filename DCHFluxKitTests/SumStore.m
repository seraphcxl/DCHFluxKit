//
//  SumStore.m
//  DCHFluxKit
//
//  Created by Derek Chen on 3/25/15.
//  Copyright (c) 2015 seraphcxl. All rights reserved.
//

#import "SumStore.h"

@interface SumStore ()

@property (nonatomic, assign) NSUInteger result;

@end

@implementation SumStore

- (BOOL)respondEvent:(id <DCHEvent>)event from:(id)source withCompletionHandler:(DCHEventResponderCompletionHandler)completionHandler {
    BOOL result = NO;
    do {
        if (event == nil || completionHandler == nil) {
            break;
        }
        self.inputEvent = event;
        self.outputEvent = event;
        
        NSDictionary *payload = (NSDictionary *)[self.outputEvent payload];
        if (payload) {
            NSNumber *num = [payload objectForKey:@"Num"];
            if (num) {
                self.result = [num unsignedIntegerValue] + self.factor;
            }
        } else {
            self.result += self.factor;
        }
        [self.outputEvent setPayload:[NSDictionary dictionaryWithObject:[NSNumber numberWithUnsignedLong:self.result] forKey:@"Num"]];
        
        completionHandler(self, event, nil);
        
        [self emitChange];
        
        result = YES;
    } while (NO);
    return result;
}

@end
