//
//  DCHAsyncTest.m
//  DCHFluxKit
//
//  Created by Derek Chen on 3/24/15.
//  Copyright (c) 2015 seraphcxl. All rights reserved.
//

#import "DCHAsyncTest.h"
#import <BlocksKit/BlocksKit.h>

static const NSTimeInterval kDCHAsyncTestExpectDefaultTimeoutInSeconds = (10);  // 10Sec
static const NSTimeInterval kDCHAsyncTestPromiseTestTimerInSeconds = (0.2);
NSString * const DCHAsyncTestErrorDomain = @"DCHAsyncTestErrorDomain";

@interface DCHAsyncTest ()

- (void)expect:(DCHAsyncTestPromiseTest)promiseTest withTimeout:(NSTimeInterval)seconds andCompletionHandler:(DCHAsyncTestCompletionHandler)completionHandler;

@end

@implementation DCHAsyncTest

+ (void)expect:(DCHAsyncTestPromiseTest)promiseTest withCompletionHandler:(DCHAsyncTestCompletionHandler)completionHandler {
    return [self expect:promiseTest withTimeout:kDCHAsyncTestExpectDefaultTimeoutInSeconds andCompletionHandler:completionHandler];
}

+ (void)expect:(DCHAsyncTestPromiseTest)promiseTest withTimeout:(NSTimeInterval)seconds andCompletionHandler:(DCHAsyncTestCompletionHandler)completionHandler {
    do {
        if (!promiseTest || !completionHandler) {
            break;
        }
        if (!(seconds > kDCHAsyncTestPromiseTestTimerInSeconds)) {
            seconds += kDCHAsyncTestPromiseTestTimerInSeconds;
        }
        [[[DCHAsyncTest alloc] init] expect:promiseTest withTimeout:seconds andCompletionHandler:completionHandler];
    } while (NO);
}

- (void)dealloc {
    do {
        ;
    } while (NO);
}

- (void)expect:(DCHAsyncTestPromiseTest)promiseTest withTimeout:(NSTimeInterval)seconds andCompletionHandler:(DCHAsyncTestCompletionHandler)completionHandler {
    do {
        if (!promiseTest || !completionHandler) {
            break;
        }
        __block BOOL promiseSucceed = NO;
        NSUInteger repeatLimit = seconds / kDCHAsyncTestPromiseTestTimerInSeconds;
        __block NSUInteger repeatCount = 0;
        [NSTimer bk_scheduledTimerWithTimeInterval:kDCHAsyncTestPromiseTestTimerInSeconds block:^(NSTimer *timer) {
            promiseSucceed = promiseTest();
            ++repeatCount;
            
            NSLog(@"timer: %@; loop: %lu; promiseSucceed: %d", timer, (unsigned long)repeatCount, promiseSucceed);
            
            if (promiseSucceed || !(repeatCount < repeatLimit)) {
                [timer invalidate];
            }
        } repeats:YES];
        
        while (!promiseSucceed && repeatCount < repeatLimit) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[[NSDate date] dateByAddingTimeInterval:kDCHAsyncTestPromiseTestTimerInSeconds]];
        }
        
        NSError *err = nil;
        if (!(repeatCount < repeatLimit)) {
            err = [NSError errorWithDomain:DCHAsyncTestErrorDomain code:DCHAsyncTestErrorCode_Timeout userInfo:nil];
        }
        completionHandler(promiseSucceed, err, nil);
    } while (NO);
}

@end
