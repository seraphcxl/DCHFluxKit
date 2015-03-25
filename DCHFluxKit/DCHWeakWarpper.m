//
//  DCHWeakWarpper.m
//  DCHFluxKit
//
//  Created by Derek Chen on 3/21/15.
//  Copyright (c) 2015 seraphcxl. All rights reserved.
//

#import "DCHWeakWarpper.h"

@interface DCHWeakWarpper ()

@property (nonatomic, weak) id object;

@end

@implementation DCHWeakWarpper

@synthesize object = _object;

- (void)dealloc {
    do {
        self.object = nil;
    } while (NO);
}

- (instancetype)initWithObject:(id)object {
    if (object == nil) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        self.object = object;
    }
    return self;
}

@end
