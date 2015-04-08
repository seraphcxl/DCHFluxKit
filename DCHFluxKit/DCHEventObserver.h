//
//  DCHEventObserver.h
//  DCHFluxKit
//
//  Created by Derek Chen on 3/21/15.
//  Copyright (c) 2015 seraphcxl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCHEventResponder.h"

@class DCHEventOperationTicket;

@interface DCHEventObserver : NSObject

@property (nonatomic, strong, readonly) NSMutableDictionary *eventOperationTicketDic;

- (DCHEventOperationTicket *)handleEvent:(id <DCHEvent>)event inMainThread:(BOOL)isInMainThread withResponderCallback:(DCHEventResponderCompletionHandler)callback;

- (NSArray *)allEventsInQueue;

- (BOOL)addEventResponder:(id <DCHEventResponder>)eventResponder forEvent:(id <DCHEvent>)event;

- (BOOL)removeEventResponder:(id <DCHEventResponder>)eventResponder forEvent:(id <DCHEvent>)event;

- (BOOL)removeAllRespondersForEvent:(id <DCHEvent>)event;

- (BOOL)removeEventResponder:(id <DCHEventResponder>)eventResponder;

- (NSArray *)handlingEvents;

@end
