//
//  DCHEventOperationTicket.h
//  DCHFluxKit
//
//  Created by Derek Chen on 3/24/15.
//  Copyright (c) 2015 seraphcxl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCHEvent.h"

@class DCHEventObserver;

@interface DCHEventOperationTicket : NSObject

@property (nonatomic, copy, readonly) id <DCHEvent> event;

@property (nonatomic, weak, readonly) id eventHandler;

@property (nonatomic, assign, getter=isWorking) BOOL working;

@property (nonatomic, assign, getter=isCanceled) BOOL canceled;

@property (nonatomic, assign, getter=isFinished) BOOL finished;

- (instancetype)initWithEvent:(id <DCHEvent>)event andHandler:(id)handler;

- (NSString *)UUID;

- (void)cancel;

@end
