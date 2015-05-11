//
//  DCHEvent.m
//  DCHFluxKit
//
//  Created by Derek Chen on 4/15/15.
//  Copyright (c) 2015 seraphcxl. All rights reserved.
//

#import "DCHEvent.h"

@interface DCHEvent ()

@property (nonatomic, copy) NSString *domainStr;
@property (nonatomic, assign) NSUInteger codeNum;
@property (nonatomic, assign) BOOL mainThreadRequiredSign;
@property (nonatomic, assign) DCHEventRunningType runningTypeEnum;
@property (nonatomic, strong) id <NSCopying> payloadObj;

@end

@implementation DCHEvent

+ (NSString *)createUUIDByDomain:(NSString *)domain andCode:(NSUInteger)code {
    NSString *result = nil;
    do {
        if (!domain || [domain isEqualToString:@""]) {
            break;
        }
        result = [NSString stringWithFormat:@"%@_%lu", domain, (unsigned long)code];
    } while (NO);
    return result;
}

- (void)dealloc {
    do {
        self.payloadObj = nil;
        self.domainStr = nil;
    } while (NO);
}

- (NSString *)UUID {
    return [DCHEvent createUUIDByDomain:[self domain] andCode:[self code]];
}

- (NSString *)domain {
    return self.domainStr;
}

- (NSUInteger)code {
    return self.codeNum;
}

- (BOOL)mainThreadRequired {
    return self.mainThreadRequiredSign;
}

- (DCHEventRunningType)runningType {
    return self.runningTypeEnum;
}

- (NSString *)eventDescription {
    return [NSString stringWithFormat:@"%@: %@ payload: %@", [self UUID], [super description], [self payload]];
}

- (id <NSCopying>)payload {
    return self.payloadObj;
}

- (instancetype)initWithDomain:(NSString *)domain code:(NSUInteger)code mainThreadRequired:(BOOL)mainThreadRequired runningType:(DCHEventRunningType)runningType andPayload:(id <NSCopying>)payload {
    self = [super init];
    if (self) {
        self.domainStr = domain;
        self.codeNum = code;
        self.mainThreadRequiredSign = mainThreadRequired;
        self.runningTypeEnum = runningType;
        self.payloadObj = payload;
    }
    return self;
}

- (void)setPayload:(id <NSCopying>)newPayload {
    self.payloadObj = newPayload;
}

- (id)copyWithZone:(NSZone *)zone {
    return [[[self class] alloc] initWithDomain:[self domain] code:[self code] mainThreadRequired:[self mainThreadRequired] runningType:[self runningType] andPayload:[self payload]];
}

@end
