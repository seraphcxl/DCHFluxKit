//
//  GreetingActionCreater.m
//  DCHFluxKit
//
//  Created by Derek Chen on 3/24/15.
//  Copyright (c) 2015 seraphcxl. All rights reserved.
//

#import "GreetingActionCreater.h"
#import "GreetingEvent.h"

NSString * const GreetingActionDomain = @"GreetingActionDomain";

@implementation GreetingActionCreater

+ (id <DCHEvent>)createActionWithDomain:(NSString *)domain andCode:(NSUInteger)code {
    return [[GreetingEvent alloc] initWithDomain:domain code:code runningType:DCHEventRunningType_Concurrent andPayload:nil];
}

+ (id <DCHEvent>)createEventWithDomain:(NSString *)domain code:(NSUInteger)code runningType:(DCHEventRunningType)runningType andPayload:(id <NSCopying>)payload {
    return [[GreetingEvent alloc] initWithDomain:domain code:code runningType:runningType andPayload:payload];
}

@end
