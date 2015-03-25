//
//  DCHDispatcher.h
//  DCHFluxKit
//
//  Created by Derek Chen on 3/22/15.
//  Copyright (c) 2015 seraphcxl. All rights reserved.
//

#import "DCHEventObserver.h"

@interface DCHDispatcher : DCHEventObserver

@property (nonatomic, weak) DCHDispatcher *parent;

- (NSArray *)handleEvent:(id <DCHEvent>)event withResponderCallback:(DCHEventResponderCompletionHandler)callback;

@end
