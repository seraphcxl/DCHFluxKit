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

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ %lu", [super description], (unsigned long)self.factor];
}

- (BOOL)respondEvent:(id <DCHEvent>)event from:(id)source withCompletionHandler:(DCHEventResponderCompletionHandler)completionHandler {
    BOOL result = NO;
    do {
        if (event == nil) {
            break;
        }
        id <DCHEvent> outputEvent = [event copyWithZone:nil];
        NSDictionary *payload = (NSDictionary *)[outputEvent payload];
        if (payload) {
            NSNumber *num = [payload objectForKey:@"Num"];
            if (num) {
                self.result = [num unsignedIntegerValue] + self.factor;
            }
        } else {
            self.result += self.factor;
        }
        [outputEvent setPayload:[NSDictionary dictionaryWithObject:[NSNumber numberWithUnsignedLong:self.result] forKey:@"Num"]];
        
        if (completionHandler) {
            completionHandler(self, outputEvent, nil);
        }
        
        [self emitChangeWithEvent:outputEvent andCompletionHandler:completionHandler];
        
        result = YES;
    } while (NO);
    return result;
}

@end
