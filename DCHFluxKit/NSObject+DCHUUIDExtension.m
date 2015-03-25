//
//  NSObject+DCHUUIDExtension.m
//  DCHFluxKit
//
//  Created by Derek Chen on 3/23/15.
//  Copyright (c) 2015 seraphcxl. All rights reserved.
//

#import "NSObject+DCHUUIDExtension.h"

@implementation NSObject (DCHUUIDExtension)

- (NSString *)createMemoryID {
    NSString *result = nil;
    do {
        result = [NSString stringWithFormat:@"%@_%p", NSStringFromClass([self class]), self];
    } while (NO);
    return result;
}

@end
