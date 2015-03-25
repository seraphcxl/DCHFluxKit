//
//  DCHEvent.h
//  DCHFluxKit
//
//  Created by Derek Chen on 3/21/15.
//  Copyright (c) 2015 seraphcxl. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DCHEventRunningType) {
    DCHEventRunningType_Serial,
    DCHEventRunningType_Concurrent,
};

@protocol DCHEvent <NSObject, NSCopying>

@required
- (NSString *)UUID;

- (NSString *)domain;

- (NSUInteger)code;

- (DCHEventRunningType)runningType;

- (NSString *)description;

- (id <NSCopying>)payload;

- (instancetype)initWithUUID:(NSString *)uuid Domain:(NSString *)domain code:(NSUInteger)code runningType:(DCHEventRunningType)runningType andPayload:(id <NSCopying>)payload;

@optional
- (void)setPayload:(id <NSCopying>)newPayload;

@end
