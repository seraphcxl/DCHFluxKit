//
//  DCHViewModel.m
//  DCHFluxKit
//
//  Created by Derek Chen on 3/22/15.
//  Copyright (c) 2015 seraphcxl. All rights reserved.
//

#import "DCHViewModel.h"
#import "DCHEventOperationTicket.h"
#import "NSObject+DCHUUIDExtension.h"

@interface DCHViewModel ()

@property (nonatomic, strong) dispatch_queue_t eventQueue;
@property (nonatomic, strong) NSMutableDictionary *eventOperationTicketDic;

@end

@implementation DCHViewModel

@synthesize inputEvent = _inputEvent;
@synthesize outputEvent = _outputEvent;
@synthesize eventQueue = _eventQueue;
@synthesize eventOperationTicketDic = _eventOperationTicketDic;

- (void)dealloc {
    do {
        self.eventQueue = nil;
        self.eventOperationTicketDic = nil;
        self.outputEvent = nil;
        self.inputEvent = nil;
    } while (NO);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.eventQueue = dispatch_queue_create([[self createMemoryID] UTF8String], DISPATCH_QUEUE_CONCURRENT);
        self.eventOperationTicketDic = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - DCHEventResponder
- (BOOL)respondEvent:(id <DCHEvent>)event from:(id)source withCompletionHandler:(DCHEventResponderCompletionHandler)completionHandler {
    return NO;
}

- (DCHEventOperationTicket *)emitChange {
    return [self emitChangeWithEvent:self.outputEvent];
}

- (DCHEventOperationTicket *)emitChangeWithEvent:(id <DCHEvent>)event {
    __block DCHEventOperationTicket *result = nil;
    do {
        if (!event) {
            break;
        }
        
        result = [[DCHEventOperationTicket alloc] initWithEvent:event];
        
        __weak typeof(self) weakSelf = self;
        dispatch_block_t action = ^{
            result.working = YES;
            result.finished = NO;
            typeof(self) strongSelf = weakSelf;
            do {
                
                if (!strongSelf) {
                    break;
                }
                if (result.isCanceled) {
                    break;
                }
                [strongSelf.eventResponder respondEvent:event from:strongSelf withCompletionHandler:^(id eventResponder, id <DCHEvent> outputEvent, NSError *error) {
                    if (error) {
                        NSLog(@"%@", error);
                    }
                }];
            } while (NO);
            result.finished = YES;
            result.working = NO;
            if (strongSelf) {
                [strongSelf.eventOperationTicketDic removeObjectForKey:[result UUID]];
            }
        };
        
        switch ([event runningType]) {
            case DCHEventRunningType_Concurrent:
            {
                dispatch_async(self.eventQueue, action);
                [self.eventOperationTicketDic setObject:result forKey:[result UUID]];
            }
                break;
            case DCHEventRunningType_Serial:
            default:
            {
                dispatch_barrier_async(self.eventQueue, action);
                [self.eventOperationTicketDic setObject:result forKey:[result UUID]];
            }
                break;
        }
    } while (NO);
    return result;
}

- (NSArray *)allEventsInQueue {
    return [self.eventOperationTicketDic allValues];
}

@end
