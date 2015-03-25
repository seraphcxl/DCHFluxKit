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

@interface DCHEventObserver ()

@property (nonatomic, strong) NSMutableDictionary *eventDic;
@property (nonatomic, strong) dispatch_queue_t eventQueue;
@property (nonatomic, strong) NSMutableDictionary *eventOperationTicketDic;

- (BOOL)addEventResponder:(id <DCHEventResponder>)eventResponder forEventUUID:(NSString *)eventUUID;
- (BOOL)addChainEventResponders:(NSArray *)eventResponders forEventUUID:(NSString *)eventUUID;
- (BOOL)removeEventResponder:(id <DCHEventResponder>)eventResponder forEventUUID:(NSString *)eventUUID;
- (BOOL)removeChainEventResponders:(NSArray *)eventResponders forEventUUID:(NSString *)eventUUID;

@end

@implementation DCHEventObserver

@synthesize eventDic = _eventDic;
@synthesize eventQueue = _eventQueue;
@synthesize eventOperationTicketDic = _eventOperationTicketDic;

- (void)dealloc {
    do {
        self.eventQueue = nil;
        self.eventOperationTicketDic = nil;
        self.eventDic = nil;
    } while (NO);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.eventDic = [NSMutableDictionary dictionary];
        self.eventQueue = dispatch_queue_create([[self createMemoryID] UTF8String], DISPATCH_QUEUE_CONCURRENT);
        self.eventOperationTicketDic = [NSMutableDictionary dictionary];
    }
    return self;
}

- (DCHEventOperationTicket *)handleEvent:(id <DCHEvent>)event withResponderCallback:(DCHEventResponderCompletionHandler)callback {
    __block DCHEventOperationTicket *result = nil;
    do {
        if (event == nil) {
            break;
        }
        
        NSString *eventUUID = [event UUID];
        DCHIndexedArray *indexAry = [self.eventDic objectForKey:eventUUID];
        if (!indexAry) {
            break;
        }
            
        result = [[DCHEventOperationTicket alloc] initWithEvent:event];
        
        dispatch_block_t action = ^{
            result.working = YES;
            do {
                NSString *eventUUID = [event UUID];
                DCHIndexedArray *indexAry = [self.eventDic objectForKey:eventUUID];
                if (!indexAry || result.isCanceled) {
                    break;
                }
                [indexAry enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    do {
                        if (result.isCanceled || obj == nil || ![obj isKindOfClass:[DCHIndexedArray class]]) {
                            *stop = YES;
                            break;
                        }
                        NSMutableArray *eventAry = (NSMutableArray *)obj;
                        id <DCHEvent> tmpEvent = [(NSObject *)event copy];
                        
                        [eventAry enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                            do {
                                if (result.isCanceled || !obj || ![obj isKindOfClass:[DCHWeakWarpper class]]) {
                                    *stop = YES;
                                    break;
                                }
                                DCHWeakWarpper *weakWarpper = (DCHWeakWarpper *)obj;
                                id <DCHEventResponder> eventResponder = weakWarpper.object;
                                if (eventResponder) {
                                    [eventResponder respondEvent:tmpEvent withCompletionHandler:^(id eventResponder, id <DCHEvent> outputEvent, NSError *error) {
                                        if (callback) {
                                            callback(eventResponder, outputEvent, error);
                                        }
                                    }];
                                }
                            } while (NO);
                        }];
                    } while (NO);
                }];
            } while (NO);
            result.working = NO;
            [self.eventOperationTicketDic removeObjectForKey:[result UUID]];
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

- (BOOL)addChainEventResponders:(NSArray *)eventResponders forEvent:(id <DCHEvent>)event {
    BOOL result = NO;
    do {
        if (eventResponders == nil || eventResponders.count == 0 || event == nil) {
            break;
        }
        
        result = [self addChainEventResponders:eventResponders forEventUUID:[event UUID]];
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

- (BOOL)removeChainEventResponders:(NSArray *)eventResponders forEvent:(id <DCHEvent>)event {
    BOOL result = NO;
    do {
        if (eventResponders == nil || eventResponders.count == 0 || event == nil) {
            break;
        }
        
        result = [self removeChainEventResponders:eventResponders forEventUUID:[event UUID]];
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
        [self.eventDic removeObjectForKey:eventUUID];
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
        NSArray *allKeys = [self.eventDic allKeys];
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

- (BOOL)removeChainEventResponders:(NSArray *)eventResponders {
    BOOL result = NO;
    do {
        if (eventResponders == nil || eventResponders.count == 0) {
            break;
        }
        NSArray *allKeys = [self.eventDic allKeys];
        __block BOOL enumBlockResult = YES;
        [allKeys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            do {
                if (!obj || ![obj isKindOfClass:[NSString class]]) {
                    *stop = YES;
                    enumBlockResult = NO;
                    break;
                }
                NSString *eventUUID = (NSString *)obj;
                [self removeChainEventResponders:eventResponders forEventUUID:eventUUID];
            } while (NO);
        }];
        if (!enumBlockResult) {
            break;
        }
        result = YES;
    } while (NO);
    return result;
}

#pragma mark - Private
- (BOOL)addEventResponder:(id <DCHEventResponder>)eventResponder forEventUUID:(NSString *)eventUUID {
    BOOL result = NO;
    do {
        if (eventResponder == nil || eventUUID == nil || ![eventResponder isKindOfClass:[NSObject class]]) {
            break;
        }
        
        DCHIndexedArray *indexAry = [self.eventDic objectForKey:eventUUID];
        NSString *idx = [(NSObject *)eventResponder createMemoryID];
        
        if (!indexAry) {
            indexAry = [[DCHIndexedArray alloc] init];
            [self.eventDic setObject:indexAry forKey:eventUUID];
        }
        
        if (![indexAry containsObjectWithIndex:idx]) {
            NSMutableArray *eventAry = [NSMutableArray arrayWithCapacity:1];
            DCHWeakWarpper *weakWarpper = [[DCHWeakWarpper alloc] initWithObject:eventResponder];
            
            [eventAry addObject:weakWarpper];
            [indexAry addObject:eventAry withIndex:idx];
        }
        result = YES;
    } while (NO);
    return result;
}

- (BOOL)addChainEventResponders:(NSArray *)eventResponders forEventUUID:(NSString *)eventUUID {
    BOOL result = NO;
    do {
        if (eventResponders == nil || eventResponders.count == 0 || eventUUID == nil) {
            break;
        }
        DCHIndexedArray *indexAry = [self.eventDic objectForKey:eventUUID];
        if (!indexAry) {
            indexAry = [[DCHIndexedArray alloc] init];
            [self.eventDic setObject:indexAry forKey:eventUUID];
        }
        NSMutableString *idxOutside = [NSMutableString string];
        NSMutableArray *eventAry = [NSMutableArray arrayWithCapacity:eventResponders.count];
        __block BOOL enumBlockResult = YES;
        [eventResponders enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            do {
                id <DCHEventResponder> eventResponder = obj;
                if (!obj || ![eventResponder isKindOfClass:[NSObject class]]) {
                    *stop = YES;
                    enumBlockResult = NO;
                    break;
                }
                
                NSString *idxInside = [(NSObject *)eventResponder createMemoryID];
                DCHWeakWarpper *weakWarpper = [[DCHWeakWarpper alloc] initWithObject:eventResponder];
                [eventAry addObject:weakWarpper];
                
                [idxOutside appendString:idxInside];
            } while (NO);
        }];
        if (!enumBlockResult) {
            break;
        }
        if (![indexAry containsObjectWithIndex:idxOutside]) {
            [indexAry addObject:eventAry withIndex:idxOutside];
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
        DCHIndexedArray *indexAry = [self.eventDic objectForKey:eventUUID];
        if (indexAry) {
            NSString *idx = [(NSObject *)eventResponder createMemoryID];
            [indexAry removeObjectWithIndex:idx];
            if (indexAry.count == 0) {
                [self.eventDic removeObjectForKey:eventUUID];
            }
        }
        result = YES;
    } while (NO);
    return result;
}

- (BOOL)removeChainEventResponders:(NSArray *)eventResponders forEventUUID:(NSString *)eventUUID {
    BOOL result = NO;
    do {
        if (eventResponders == nil || eventResponders.count == 0 || eventUUID == nil) {
            break;
        }
        DCHIndexedArray *indexAry = [self.eventDic objectForKey:eventUUID];
        if (indexAry) {
            NSMutableString *idxOutside = [NSMutableString string];
            __block BOOL enumBlockResult = YES;
            [eventResponders enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                do {
                    id <DCHEventResponder> eventResponder = obj;
                    if (!obj || ![eventResponder isKindOfClass:[NSObject class]]) {
                        *stop = YES;
                        enumBlockResult = NO;
                        break;
                    }
                    
                    NSString *idxInside = [(NSObject *)eventResponder createMemoryID];
                    [idxOutside appendString:idxInside];
                } while (NO);
            }];
            if (!enumBlockResult) {
                break;
            }
            [indexAry removeObjectWithIndex:idxOutside];
            if (indexAry.count == 0) {
                [self.eventDic removeObjectForKey:eventUUID];
            }
        }
        result = YES;
    } while (NO);
    return result;
}

@end
