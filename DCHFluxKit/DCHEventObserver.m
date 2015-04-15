//
//  DCHEventObserver.m
//  DCHFluxKit
//
//  Created by Derek Chen on 3/21/15.
//  Copyright (c) 2015 seraphcxl. All rights reserved.
//

#import "DCHEventObserver.h"
#import "DCHWeakWarpper.h"
#import "DCHIndexedArray.h"
#import "NSObject+DCHUUIDExtension.h"
#import "DCHEventOperationTicket.h"
#import <Tourbillon/DCHTourbillon.h>
#import <libextobjc/EXTScope.h>

@interface DCHEventObserver ()

@property (nonatomic, strong) NSMutableDictionary *eventDic;
@property (nonatomic, strong) dispatch_queue_t eventQueue;
@property (nonatomic, strong) NSMutableDictionary *eventOperationTicketDic;

- (BOOL)addEventResponder:(id <DCHEventResponder>)eventResponder forEventUUID:(NSString *)eventUUID;
- (BOOL)removeEventResponder:(id <DCHEventResponder>)eventResponder forEventUUID:(NSString *)eventUUID;

@end

@implementation DCHEventObserver

@synthesize eventDic = _eventDic;
@synthesize eventQueue = _eventQueue;
@synthesize eventOperationTicketDic = _eventOperationTicketDic;

- (void)dealloc {
    do {
        self.eventQueue = nil;
        [self.eventOperationTicketDic threadSafe_uninit];
        self.eventOperationTicketDic = nil;
        [self.eventDic threadSafe_uninit];
        self.eventDic = nil;
    } while (NO);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.eventDic = [[NSMutableDictionary dictionary] threadSafe_init:YES];
        self.eventQueue = dispatch_queue_create([[self createMemoryID] UTF8String], DISPATCH_QUEUE_CONCURRENT);
        self.eventOperationTicketDic = [[NSMutableDictionary dictionary] threadSafe_init:YES];
    }
    return self;
}

- (DCHEventOperationTicket *)handleEvent:(id<DCHEvent>)event inMainThread:(BOOL)isInMainThread withResponderCallback:(DCHEventResponderCompletionHandler)callback {
    __block DCHEventOperationTicket *result = nil;
    do {
        if (event == nil) {
            break;
        }
        
        NSString *eventUUID = [event UUID];
        DCHIndexedArray *indexAry = [self.eventDic threadSafe_objectForKey:eventUUID];
        if (!indexAry) {
            break;
        }
            
        result = [[DCHEventOperationTicket alloc] initWithEvent:event];
        
        @weakify(self);
        dispatch_block_t action = ^{
            result.working = YES;
            result.finished = NO;
            @strongify(self);
            do {
                NSString *eventUUID = [event UUID];
                DCHIndexedArray *indexAry = [self.eventDic threadSafe_objectForKey:eventUUID];
                if (!indexAry || result.isCanceled) {
                    break;
                }
                [indexAry enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    do {
                        if (result.isCanceled || obj == nil || ![obj isKindOfClass:[DCHWeakWarpper class]]) {
                            *stop = YES;
                            break;
                        }
                        DCHWeakWarpper *weakWarpper = (DCHWeakWarpper *)obj;
                        id <DCHEventResponder> eventResponder = weakWarpper.object;
                        if (eventResponder) {
                            [eventResponder respondEvent:event from:self withCompletionHandler:^(id eventReponder, id <DCHEvent> outputEvent, NSError *error) {
                                if (callback) {
                                    callback(eventResponder, outputEvent, error);
                                }
                            }];
                        }
                    } while (NO);
                }];
            } while (NO);
            result.finished = YES;
            result.working = NO;
            if (self) {
                [self.eventOperationTicketDic threadSafe_removeObjectForKey:[result UUID]];
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
                [self.eventOperationTicketDic threadSafe_setObject:result forKey:[result UUID]];
            }
                break;
            case DCHEventRunningType_Serial:
            default:
            {
                dispatch_barrier_async(queue, action);
                [self.eventOperationTicketDic threadSafe_setObject:result forKey:[result UUID]];
            }
                break;
        }
    } while (NO);
    return result;
}

- (NSArray *)allEventsInQueue {
    return [self.eventOperationTicketDic threadSafe_allValues];
}

- (BOOL)addEventResponder:(id <DCHEventResponder>)eventResponder forEvent:(id <DCHEvent>)event {
    BOOL result = NO;
    do {
        if (eventResponder == nil || event == nil || ![eventResponder isKindOfClass:[NSObject class]]) {
            break;
        }
        
        result = [self addEventResponder:eventResponder forEventUUID:[event UUID]];
    } while (NO);
    return result;
}

- (BOOL)addEventResponder:(id<DCHEventResponder>)eventResponder forEventDomain:(NSString *)eventDomain code:(NSUInteger)eventCode {
    BOOL result = NO;
    do {
        if (eventResponder == nil || eventDomain == nil || [eventDomain isEqualToString:@""] || ![eventResponder isKindOfClass:[NSObject class]]) {
            break;
        }
        
        result = [self addEventResponder:eventResponder forEventUUID:[DCHEvent createUUIDByDomain:eventDomain andCode:eventCode]];
    } while (NO);
    return result;
}

- (BOOL)removeEventResponder:(id <DCHEventResponder>)eventResponder forEvent:(id <DCHEvent>)event {
    BOOL result = NO;
    do {
        if (eventResponder == nil || event == nil || ![eventResponder isKindOfClass:[NSObject class]]) {
            break;
        }
        
        result = [self removeEventResponder:eventResponder forEventUUID:[event UUID]];
    } while (NO);
    return result;
}

- (BOOL)removeEventResponder:(id<DCHEventResponder>)eventResponder forEventDomain:(NSString *)eventDomain code:(NSUInteger)eventCode {
    BOOL result = NO;
    do {
        if (eventResponder == nil || eventDomain == nil || [eventDomain isEqualToString:@""] || ![eventResponder isKindOfClass:[NSObject class]]) {
            break;
        }
        
        result = [self removeEventResponder:eventResponder forEventUUID:[DCHEvent createUUIDByDomain:eventDomain andCode:eventCode]];
    } while (NO);
    return result;
}

- (BOOL)removeAllRespondersForEvent:(id <DCHEvent>)event {
    BOOL result = NO;
    do {
        if (event == nil) {
            break;
        }
        NSString *eventUUID = [event UUID];
        [self.eventDic threadSafe_removeObjectForKey:eventUUID];
        result = YES;
    } while (NO);
    return result;
}

- (BOOL)removeAllRespondersForEventDomain:(NSString *)eventDomain code:(NSUInteger)eventCode {
    BOOL result = NO;
    do {
        if (eventDomain == nil || [eventDomain isEqualToString:@""]) {
            break;
        }
        NSString *eventUUID = [DCHEvent createUUIDByDomain:eventDomain andCode:eventCode];
        [self.eventDic threadSafe_removeObjectForKey:eventUUID];
        result = YES;
    } while (NO);
    return result;
}

- (BOOL)removeEventResponder:(id <DCHEventResponder>)eventResponder {
    BOOL result = NO;
    do {
        if (eventResponder == nil) {
            break;
        }
        NSArray *allKeys = [self.eventDic threadSafe_allKeys];
        __block BOOL enumBlockResult = YES;
        [allKeys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            do {
                if (!obj || ![obj isKindOfClass:[NSString class]]) {
                    *stop = YES;
                    enumBlockResult = NO;
                    break;
                }
                NSString *eventUUID = (NSString *)obj;
                [self removeEventResponder:eventResponder forEventUUID:eventUUID];
            } while (NO);
        }];
        if (!enumBlockResult) {
            break;
        }
        result = YES;
    } while (NO);
    return result;
}

- (NSArray *)handlingEvents {
    return [self.eventDic threadSafe_allKeys];
}

#pragma mark - Private
- (BOOL)addEventResponder:(id <DCHEventResponder>)eventResponder forEventUUID:(NSString *)eventUUID {
    BOOL result = NO;
    do {
        if (eventResponder == nil || eventUUID == nil || ![eventResponder isKindOfClass:[NSObject class]]) {
            break;
        }
        
        DCHIndexedArray *indexAry = [self.eventDic threadSafe_objectForKey:eventUUID];
        NSString *idx = [(NSObject *)eventResponder createMemoryID];
        
        if (!indexAry) {
            indexAry = [[DCHIndexedArray alloc] init];
            [self.eventDic threadSafe_setObject:indexAry forKey:eventUUID];
        }
        
        if (![indexAry containsObjectWithIndex:idx]) {
            DCHWeakWarpper *weakWarpper = [[DCHWeakWarpper alloc] initWithObject:eventResponder];
            
            [indexAry addObject:weakWarpper withIndex:idx];
        }
        result = YES;
    } while (NO);
    return result;
}

- (BOOL)removeEventResponder:(id <DCHEventResponder>)eventResponder forEventUUID:(NSString *)eventUUID {
    BOOL result = NO;
    do {
        if (eventResponder == nil || eventUUID == nil || ![eventResponder isKindOfClass:[NSObject class]]) {
            break;
        }
        DCHIndexedArray *indexAry = [self.eventDic threadSafe_objectForKey:eventUUID];
        if (indexAry) {
            NSString *idx = [(NSObject *)eventResponder createMemoryID];
            [indexAry removeObjectWithIndex:idx];
            if (indexAry.count == 0) {
                [self.eventDic threadSafe_removeObjectForKey:eventUUID];
            }
        }
        result = YES;
    } while (NO);
    return result;
}

@end
