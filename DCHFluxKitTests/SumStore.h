//
//  SumStore.h
//  DCHFluxKit
//
//  Created by Derek Chen on 3/25/15.
//  Copyright (c) 2015 seraphcxl. All rights reserved.
//

#import <DCHFluxKit/DCHFluxKit.h>

@interface SumStore : DCHStore

@property (nonatomic, assign) NSUInteger factor;
@property (nonatomic, assign, readonly) NSUInteger result;

@end
