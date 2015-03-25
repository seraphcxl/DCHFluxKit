//
//  DCHEventResponder.h
//  DCHFluxKit
//
//  Created by Derek Chen on 3/21/15.
//  Copyright (c) 2015 seraphcxl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCHEvent.h"

@class DCHEventOperationTicket;

typedef void(^DCHEventResponderCompletionHandler)(id eventResponder, id <DCHEvent>outputEvent, NSError *error);

@protocol DCHEventResponder <NSObject>

@required
- (BOOL)respondEvent:(id <DCHEvent>)event withCompletionHandler:(DCHEventResponderCompletionHandler)completionHandler;

@optional
@property (nonatomic, copy) id <DCHEvent> inputEvent;
@property (nonatomic, copy) id <DCHEvent> outputEvent;

- (BOOL)respondEvent:(id <DCHEvent>)event waitFor:(NSArray *)eventResponders withCompletionHandler:(DCHEventResponderCompletionHandler)completionHandler;

- (DCHEventOperationTicket *)emitChange;
- (DCHEventOperationTicket *)emitChangeWithEvent:(id <DCHEvent>)event;

@end