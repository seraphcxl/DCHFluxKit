//
//  DCHViewModel.m
//  DCHFluxKit
//
//  Created by Derek Chen on 3/22/15.
//  Copyright (c) 2015 seraphcxl. All rights reserved.
//

#import "DCHViewModel.h"
#import "DCHEventOperationTicket.h"
#import <Tourbillon/DCHTourbillon.h>
#import <libextobjc/EXTScope.h>

@interface DCHViewModel ()

@property (nonatomic, strong) dispatch_queue_t eventQueue;
@property (nonatomic, strong) NSMutableDictionary *eventOperationTicketDic;

@end

@implementation DCHViewModel

@synthesize eventQueue = _eventQueue;
@synthesize eventOperationTicketDic = _eventOperationTicketDic;

- (void)dealloc {
    do {
        self.eventQueue = nil;
        [self.eventOperationTicketDic dch_threadSafe_uninit];
        self.eventOperationTicketDic = nil;
    } while (NO);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.eventQueue = dispatch_queue_create([[self dch_createMemoryID] UTF8String], DISPATCH_QUEUE_CONCURRENT);
        self.eventOperationTicketDic = [[NSMutableDictionary dictionary] dch_threadSafe_init:YES];
    }
    return self;
}

#pragma mark - DCHEventResponder
- (BOOL)respondEvent:(id <DCHEvent>)event from:(id)source withCompletionHandler:(DCHEventResponderCompletionHandler)completionHandler {
    return NO;
}

- (DCHEventOperationTicket *)emitChangeWithEvent:(id <DCHEvent>)event {
    return [self emitChangeWithEvent:event andCompletionHandler:nil];
}

- (DCHEventOperationTicket *)emitChangeWithEvent:(id <DCHEvent>)event andCompletionHandler:(DCHEventResponderCompletionHandler)completionHandler {
    return [self emitChangeWithEvent:event inMainThread:[NSThread isMainThread] withCompletionHandler:completionHandler];
}

- (DCHEventOperationTicket *)emitChangeWithEvent:(id <DCHEvent>)event inMainThread:(BOOL)isInMainThread withCompletionHandler:(DCHEventResponderCompletionHandler)completionHandler {
    __block DCHEventOperationTicket *result = nil;
    do {
        if (!event) {
            break;
        }
        
        result = [[DCHEventOperationTicket alloc] initWithEvent:event andHandler:self];
        
        @weakify(self);
        dispatch_block_t action = ^{
            result.working = YES;
            result.finished = NO;
            @strongify(self);
            do {
                if (result.isCanceled) {
                    break;
                }
                [self.eventResponder respondEvent:event from:self withCompletionHandler:^(id eventResponder, id <DCHEvent> outputEvent, NSError *error) {
                    if (completionHandler) {
                        completionHandler(eventResponder, outputEvent, error);
                    }
                }];
            } while (NO);
            result.finished = YES;
            result.working = NO;
            if (self) {
                [self.eventOperationTicketDic dch_threadSafe_removeObjectForKey:[result UUID]];
            }
        };
        
        dispatch_queue_t queue = self.eventQueue;
        if (isInMainThread) {
            queue = dispatch_get_main_queue();
        }
        
        switch ([event runningType]) {
            case DCHEventRunningType_Concurrent:
            {
                dispatch_async(queue, action);
                [self.eventOperationTicketDic dch_threadSafe_setObject:result forKey:[result UUID]];
            }
                break;
            case DCHEventRunningType_Serial:
            default:
            {
                dispatch_barrier_async(queue, action);
                [self.eventOperationTicketDic dch_threadSafe_setObject:result forKey:[result UUID]];
            }
                break;
        }
    } while (NO);
    return result;
}

- (NSArray *)allEventsInQueue {
    return [self.eventOperationTicketDic dch_threadSafe_allValues];
}

@end
