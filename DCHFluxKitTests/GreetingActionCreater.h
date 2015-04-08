//
//  GreetingActionCreater.h
//  DCHFluxKit
//
//  Created by Derek Chen on 3/24/15.
//  Copyright (c) 2015 seraphcxl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DCHFluxKit/DCHFluxKit.h>

extern NSString * const GreetingActionDomain;

typedef NS_ENUM(NSUInteger, GreetingActionCode) {
    GreetingActionCode_Hello,
    GreetingActionCode_Sum,
};

@interface GreetingActionCreater : NSObject <DCHEventCreater>

+ (id <DCHEvent>)createActionWithDomain:(NSString *)domain andCode:(NSUInteger)code;
+ (id <DCHEvent>)createEventWithUUID:(NSString *)uuid Domain:(NSString *)domain code:(NSUInteger)code runningType:(DCHEventRunningType)runningType andPayload:(id <NSCopying>)payload;

@end
