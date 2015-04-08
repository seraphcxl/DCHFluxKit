//
//  DCHEventCreater.h
//  DCHFluxKit
//
//  Created by Derek Chen on 4/8/15.
//  Copyright (c) 2015 seraphcxl. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DCHEvent;

@protocol DCHEventCreater <NSObject>

+ (id <DCHEvent>)createEventWithUUID:(NSString *)uuid Domain:(NSString *)domain code:(NSUInteger)code runningType:(DCHEventRunningType)runningType andPayload:(id <NSCopying>)payload;

@end
