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
@class DCHEventObserver;

typedef void(^DCHEventResponderCompletionHandler)(id eventResponder, id <DCHEvent> outputEvent, NSError *error);

@protocol DCHEventResponder <NSObject>

@required
- (BOOL)respondEvent:(id <DCHEvent>)event from:(id)source withCompletionHandler:(DCHEventResponderCompletionHandler)completionHandler;

@optional
- (DCHEventOperationTicket *)emitChangeWithEvent:(id <DCHEvent>)event;
- (DCHEventOperationTicket *)emitChangeWithEvent:(id <DCHEvent>)event andCompletionHandler:(DCHEventResponderCompletionHandler)completionHandler;
- (DCHEventOperationTicket *)emitChangeWithEvent:(id <DCHEvent>)event inMainThread:(BOOL)isInMainThread withCompletionHandler:(DCHEventResponderCompletionHandler)completionHandler;

@end
