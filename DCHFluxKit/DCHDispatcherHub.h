//
//  DCHDispatcher.h
//  DCHFluxKit
//
//  Created by Derek Chen on 3/22/15.
//  Copyright (c) 2015 seraphcxl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCHEventResponder.h"

@protocol DCHEvent;
@class DCHDispatcher;

@interface DCHDispatcherHub : NSObject

- (void)addDispatcher:(DCHDispatcher *)dispatcher;
- (void)removeDispatcher:(DCHDispatcher *)dispatcher;

- (NSArray *)handleEvent:(id <DCHEvent>)event inMainThread:(BOOL)isInMainThread withResponderCallback:(DCHEventResponderCompletionHandler)callback;

@end
