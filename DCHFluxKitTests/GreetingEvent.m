//
//  GreetingEvent.m
//  DCHFluxKit
//
//  Created by Derek Chen on 3/24/15.
//  Copyright (c) 2015 seraphcxl. All rights reserved.
//

#import "GreetingEvent.h"

@interface GreetingEvent ()

@property (nonatomic, copy) NSString *domainStr;
@property (nonatomic, assign) NSUInteger codeNum;
@property (nonatomic, strong) id payloadObj;

@end

@implementation GreetingEvent

@synthesize domainStr = _domainStr;
@synthesize codeNum = _codeNum;
@synthesize payloadObj = _payloadObj;

- (void)dealloc {
    do {
        self.domainStr = nil;
        self.payloadObj = nil;
    } while (NO);
}

- (NSString *)UUID {
    return [NSString stringWithFormat:@"%@_%lu", [self domain], (unsigned long)[self code]];
}

- (NSString *)domain {
    return [self.domainStr copy];
}

- (NSUInteger)code {
    return self.codeNum;
}

- (DCHEventRunningType)runningType {
    return DCHEventRunningType_Concurrent;
}

- (NSString *)eventDescription {
    return [NSString stringWithFormat:@"%@: %@ payload: %@", [self UUID], [super description], [self payload]];
}

- (id <NSCopying>)payload {
    return self.payloadObj;
}

- (instancetype)initWithUUID:(NSString *)uuid Domain:(NSString *)domain code:(NSUInteger)code runningType:(DCHEventRunningType)runningType andPayload:(id <NSCopying>)payload {
    self = [super init];
    if (self) {
        self.domainStr = domain;
        self.codeNum = code;
        self.payloadObj = payload;
    }
    return self;
}

- (void)setPayload:(id <NSCopying>)newPayload {
    self.payloadObj = newPayload;
}

- (id)copyWithZone:(NSZone *)zone {
    return [[GreetingEvent alloc] initWithUUID:self.UUID Domain:self.domain code:self.code runningType:DCHEventRunningType_Concurrent andPayload:self.payload];
}

@end
