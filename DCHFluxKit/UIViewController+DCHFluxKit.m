//
//  UIViewController+DCHFluxKit.m
//  DCHFluxKit
//
//  Created by Derek Chen on 3/22/15.
//  Copyright (c) 2015 seraphcxl. All rights reserved.
//

#import "UIViewController+DCHFluxKit.h"

@implementation UIViewController (DCHFluxKit)

#pragma mark - DCHEventResponder
- (BOOL)respondEvent:(id <DCHEvent>)event withCompletionHandler:(DCHEventResponderCompletionHandler)completionHandler {
    BOOL result = NO;
    do {
        if (event == nil || completionHandler == nil) {
            break;
        }
        result = YES;
    } while (NO);
    return result;
}

@end
