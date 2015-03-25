//
//  GreetingStore.m
//  DCHFluxKit
//
//  Created by Derek Chen on 3/24/15.
//  Copyright (c) 2015 seraphcxl. All rights reserved.
//

#import "GreetingStore.h"

@interface GreetingStore ()

@property (nonatomic, copy) NSString *name;

@end

@implementation GreetingStore

@synthesize name;

- (void)dealloc {
    do {
        self.name = nil;
    } while (NO);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.name = nil;
    }
    return self;
}

- (BOOL)respondEvent:(id <DCHEvent>)event withCompletionHandler:(DCHEventResponderCompletionHandler)completionHandler {
    BOOL result = NO;
    do {
        if (event == nil || completionHandler == nil) {
            break;
        }
        self.inputEvent = event;
        self.outputEvent = event;
        self.name = @"Suise";
        [self.outputEvent setPayload:[NSDictionary dictionaryWithObject:@"Suise" forKey:@"Name"]];
        
        completionHandler(self, event, nil);
        
        [self emitChange];
        
        result = YES;
    } while (NO);
    return result;
}

@end
