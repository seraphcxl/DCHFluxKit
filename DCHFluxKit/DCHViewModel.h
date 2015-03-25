//
//  DCHViewModel.h
//  DCHFluxKit
//
//  Created by Derek Chen on 3/22/15.
//  Copyright (c) 2015 seraphcxl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCHEventResponder.h"

@interface DCHViewModel : NSObject <DCHEventResponder>

@property (nonatomic, weak) id <DCHEventResponder> eventResponder;

@property (nonatomic, strong, readonly) NSMutableDictionary *eventOperationTicketDic;

- (NSArray *)allEventsInQueue;

@end
