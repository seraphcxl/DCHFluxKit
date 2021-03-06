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

+ (id <DCHEvent>)createEventWithDomain:(NSString *)domain code:(NSUInteger)code mainThreadRequired:(BOOL)mainThreadRequired runningType:(DCHEventRunningType)runningType andPayload:(id <NSCopying>)payload;

@end
