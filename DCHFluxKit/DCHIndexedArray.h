//
//  DCHIndexedArray.h
//  DCHFluxKit
//
//  Created by Derek Chen on 3/23/15.
//  Copyright (c) 2015 seraphcxl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCHIndexedArray : NSObject

- (void)addObject:(id)anObject withIndex:(NSString *)index;
- (void)removeObjectWithIndex:(NSString *)index;
- (void)removeAllObjects;
- (BOOL)containsObjectWithIndex:(NSString *)index;
- (id)objectAtIndex:(NSUInteger)index;
- (void)enumerateObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block;
- (NSUInteger)count;

@end
