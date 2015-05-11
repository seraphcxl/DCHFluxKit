//
//  GreetingStore.m
//  DCHFluxKit
//
//  Created by Derek Chen on 3/24/15.
//  Copyright (c) 2015 seraphcxl. All rights reserved.
//

#import "GreetingStore.h"
#import "GreetingEvent.h"

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

- (BOOL)respondEvent:(id <DCHEvent>)event from:(id)source withCompletionHandler:(DCHEventResponderCompletionHandler)completionHandler {
    BOOL result = NO;
    do {
        if (event == nil) {
            break;
        }
        id <DCHEvent> outputEvent = [(GreetingEvent *)event copy];
        self.name = @"Suise";
        [outputEvent setPayload:[NSDictionary dictionaryWithObject:@"Suise" forKey:@"Name"]];
        
        if (completionHandler) {
            completionHandler(self, outputEvent, nil);
        }
        
        [self emitChangeWithEvent:outputEvent andCompletionHandler:completionHandler];
        
        result = YES;
    } while (NO);
    return result;
}

@end
