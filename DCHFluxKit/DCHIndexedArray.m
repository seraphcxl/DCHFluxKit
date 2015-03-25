//
//  DCHIndexedArray.m
//  DCHFluxKit
//
//  Created by Derek Chen on 3/23/15.
//  Copyright (c) 2015 seraphcxl. All rights reserved.
//

#import "DCHIndexedArray.h"

@interface DCHIndexedArray ()

@property (nonatomic, strong) NSMutableArray *ary;
@property (nonatomic, strong) NSMutableDictionary *IndexDic;

@end

@implementation DCHIndexedArray

@synthesize ary = _ary;
@synthesize IndexDic = _IndexDic;

- (void)dealloc {
    do {
        self.IndexDic = nil;
        self.ary = nil;
    } while (NO);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.ary = [NSMutableArray array];
        self.IndexDic = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)addObject:(id)anObject withIndex:(NSString *)index {
    do {
        if (!anObject || !index || [index isEqualToString:@""]) {
            break;
        }
        [self.ary addObject:anObject];
        [self.IndexDic setObject:anObject forKey:index];
    } while (NO);
}

- (void)removeObjectWithIndex:(NSString *)index {
    do {
        if (!index || [index isEqualToString:@""]) {
            break;
        }
        id obj = [self.IndexDic objectForKey:index];
        if (!obj) {
            break;
        }
        [self.IndexDic removeObjectForKey:index];
        [self.ary removeObject:obj];
    } while (NO);
}

- (void)removeAllObjects {
    do {
        [self.IndexDic removeAllObjects];
        [self.ary removeAllObjects];
    } while (NO);
}

- (BOOL)containsObjectWithIndex:(NSString *)index {
    BOOL result = NO;
    do {
        if (!index || [index isEqualToString:@""]) {
            break;
        }
        result = [self.IndexDic objectForKey:index];
    } while (NO);
    return result;
}

- (id)objectAtIndex:(NSUInteger)index {
    id result = nil;
    do {
        result = [self.ary objectAtIndex:index];
    } while (NO);
    return result;
}

- (void)enumerateObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block {
    do {
        if (!block) {
            break;
        }
        [self.ary enumerateObjectsUsingBlock:block];
    } while (NO);
}

- (NSUInteger)count {
    return self.ary.count;
}

@end
