//
//  DCHWeakWarpper.h
//  DCHFluxKit
//
//  Created by Derek Chen on 3/21/15.
//  Copyright (c) 2015 seraphcxl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCHWeakWarpper : NSObject

@property (nonatomic, weak, readonly) id object;

- (instancetype)initWithObject:(id)object;

@end
