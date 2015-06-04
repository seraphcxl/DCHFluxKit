//
//  DCHIndexedArray.m
//  DCHFluxKit
//
//  Created by Derek Chen on 3/23/15.
//  Copyright (c) 2015 seraphcxl. All rights reserved.
//

#import "DCHIndexedArray.h"
#import <Tourbillon/DCHTourbillon.h>

@interface DCHIndexedArray ()

@property (nonatomic, strong) NSMutableArray *ary;
@property (nonatomic, strong) NSMutableDictionary *IndexDic;

@end

@implementation DCHIndexedArray

@synthesize ary = _ary;
@synthesize IndexDic = _IndexDic;

- (void)dealloc {
    do {
        [self.IndexDic dch_threadSafe_uninit];
        self.IndexDic = nil;
        [self.ary dch_threadSafe_uninit];
        self.ary = nil;
    } while (NO);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.ary = [[NSMutableArray array] dch_threadSafe_init:YES];
        self.IndexDic = [[NSMutableDictionary dictionary] dch_threadSafe_init:YES];
    }
    return self;
}

- (void)addObject:(id)anObject withIndex:(NSString *)index {
    do {
        if (!anObject || !index || [index isEqualToString:@""]) {
            break;
        }
        [self.ary dch_threadSafe_addObject:anObject];
        [self.IndexDic dch_threadSafe_setObject:anObject forKey:index];
    } while (NO);
}

- (void)removeObjectWithIndex:(NSString *)index {
    do {
        if (!index || [index isEqualToString:@""]) {
            break;
        }
        id obj = [self.IndexDic dch_threadSafe_objectForKey:index];
        if (!obj) {
            break;
        }
        [self.IndexDic dch_threadSafe_removeObjectForKey:index];
        [self.ary dch_threadSafe_removeObject:obj];
    } while (NO);
}

- (void)removeAllObjects {
    do {
        [self.IndexDic dch_threadSafe_removeAllObjects];
        [self.ary dch_threadSafe_removeAllObjects];
    } while (NO);
}

- (BOOL)containsObjectWithIndex:(NSString *)index {
    BOOL result = NO;
    do {
        if (!index || [index isEqualToString:@""]) {
            break;
        }
        if ([self.IndexDic dch_threadSafe_objectForKey:index]) {
            result = YES;
        }
    } while (NO);
    return result;
}

- (id)objectAtIndex:(NSUInteger)index {
    id result = nil;
    do {
        result = [self.ary dch_threadSafe_objectAtIndex:index];
    } while (NO);
    return result;
}

- (void)enumerateObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block {
    do {
        if (!block) {
            break;
        }
        [self.ary dch_threadSafe_enumerateObjectsUsingBlock:block];
    } while (NO);
}

- (NSUInteger)count {
    return self.ary.dch_threadSafe_count;
}

@end
