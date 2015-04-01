//
//  GreetingDispatcherHub.h
//  DCHFluxKit
//
//  Created by Derek Chen on 4/1/15.
//  Copyright (c) 2015 seraphcxl. All rights reserved.
//

#import "DCHDispatcherHub.h"
#import <Tourbillon/DCHTourbillon.h>

@interface GreetingDispatcherHub : DCHDispatcherHub

DCH_DEFINE_SINGLETON_FOR_HEADER(GreetingDispatcherHub)

@end
