//
//  DCHEvent.h
//  DCHFluxKit
//
//  Created by Derek Chen on 4/15/15.
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

- (BOOL)mainThreadRequired;

- (DCHEventRunningType)runningType;

- (NSString *)eventDescription;

- (id <NSCopying>)payload;

- (instancetype)initWithDomain:(NSString *)domain code:(NSUInteger)code mainThreadRequired:(BOOL)mainThreadRequired runningType:(DCHEventRunningType)runningType andPayload:(id <NSCopying>)payload;

@optional
- (void)setPayload:(id <NSCopying>)newPayload;

@end

@interface DCHEvent : NSObject <DCHEvent>

+ (NSString *)createUUIDByDomain:(NSString *)domain andCode:(NSUInteger)code;

@end
