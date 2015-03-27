//
//  GreetingViewModel.m
//  DCHFluxKit
//
//  Created by Derek Chen on 3/24/15.
//  Copyright (c) 2015 seraphcxl. All rights reserved.
//

#import "GreetingViewModel.h"

@implementation GreetingViewModel

@synthesize greeting = _greeting;

- (BOOL)respondEvent:(id <DCHEvent>)event from:(id)source withCompletionHandler:(DCHEventResponderCompletionHandler)completionHandler {
    BOOL result = NO;
    do {
        if (event == nil || completionHandler == nil) {
            break;
        }
        self.inputEvent = event;
        self.outputEvent = event;
        
        NSDictionary *dic = (NSDictionary *)[event payload];
        self.greeting = [NSString stringWithFormat:@"Hello, %@.", [dic objectForKey:@"Name"]];
        
        completionHandler(self, event, nil);
        
        [self emitChange];
        
        result = YES;
    } while (NO);
    return result;
}

@end
