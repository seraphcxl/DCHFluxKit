//
//  DCHAsyncTest.h
//  DCHFluxKit
//
//  Created by Derek Chen on 3/24/15.
//  Copyright (c) 2015 seraphcxl. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const NSTimeInterval kDCHAsyncTestExpectDefaultTimeoutInNanoSeconds;

extern NSString * const DCHAsyncTestErrorDomain;

typedef NS_ENUM(NSUInteger, DCHAsyncTestErrorCode) {
    DCHAsyncTestErrorCode_Timeout,
};

@class DCHAsyncTest;

typedef void(^DCHAsyncTestCompletionHandler)(BOOL promiseResult, NSError *error, NSDictionary *infoDic);
typedef BOOL(^DCHAsyncTestPromiseTest)();

@interface DCHAsyncTest : NSObject

+ (void)expect:(DCHAsyncTestPromiseTest)promiseTest withCompletionHandler:(DCHAsyncTestCompletionHandler)completionHandler;

+ (void)expect:(DCHAsyncTestPromiseTest)promiseTest withTimeout:(NSTimeInterval)seconds andCompletionHandler:(DCHAsyncTestCompletionHandler)completionHandler;

@end
