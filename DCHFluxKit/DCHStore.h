//
//  DCHStore.h
//  DCHFluxKit
//
//  Created by Derek Chen on 3/22/15.
//  Copyright (c) 2015 seraphcxl. All rights reserved.
//

#import "DCHEventObserver.h"
#import "DCHEventResponder.h"

@interface DCHStore : DCHEventObserver <DCHEventResponder>

- (BOOL)respondEvent:(id <DCHEvent>)event dependOn:(DCHStore *)store;

- (BOOL)respondEventDomain:(NSString *)eventDomain code:(NSUInteger)eventCode dependOn:(DCHStore *)store;

@end
