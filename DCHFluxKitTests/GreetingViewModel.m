//
//  GreetingViewModel.m
//  DCHFluxKit
//
//  Created by Derek Chen on 3/24/15.
//  Copyright (c) 2015 seraphcxl. All rights reserved.
//

#import "GreetingViewModel.h"
#import "GreetingEvent.h"

@implementation GreetingViewModel

@synthesize greeting = _greeting;

- (BOOL)respondEvent:(id <DCHEvent>)event from:(id)source withCompletionHandler:(DCHEventResponderCompletionHandler)completionHandler {
    BOOL result = NO;
    do {
        if (event == nil) {
            break;
        }
        id <DCHEvent> outputEvent = [(GreetingEvent *)event copy];
        NSDictionary *dic = (NSDictionary *)[event payload];
        self.greeting = [NSString stringWithFormat:@"Hello, %@.", [dic objectForKey:@"Name"]];
        
        if (completionHandler) {
            completionHandler(self, outputEvent, nil);
        }
        
        [self emitChangeWithEvent:outputEvent];
        
        result = YES;
    } while (NO);
    return result;
}

@end
