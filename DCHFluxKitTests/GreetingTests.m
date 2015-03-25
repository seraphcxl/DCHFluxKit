//
//  GreetingTests.m
//  DCHFluxKit
//
//  Created by Derek Chen on 3/24/15.
//  Copyright (c) 2015 seraphcxl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "GreetingActionCreater.h"
#import "GreetingDispatcher.h"
#import "GreetingEvent.h"
#import "GreetingStore.h"
#import "GreetingViewModel.h"
#import "SumStore.h"

#import "DCHAsyncTest.h"

@interface GreetingTests : XCTestCase

@property (nonatomic, strong) GreetingDispatcher *dispatcher;
@property (nonatomic, strong) GreetingStore *store;
@property (nonatomic, strong) GreetingViewModel *viewModel;
@property (nonatomic, strong) NSMutableArray *sumStores;

@end

@implementation GreetingTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.dispatcher = [[GreetingDispatcher alloc] init];
    self.store = [[GreetingStore alloc] init];
    self.viewModel = [[GreetingViewModel alloc] init];
    self.sumStores = [NSMutableArray array];
    
    id <DCHEvent> event = [GreetingActionCreater createActionWithDomain:GreetingActionDomain andCode:GreetingActionCode_Hello];
    
    [self.dispatcher addEventResponder:self.store forEvent:event];
    [self.store addEventResponder:self.viewModel forEvent:event];
    
    id <DCHEvent> sumEvent = [GreetingActionCreater createActionWithDomain:GreetingActionDomain andCode:GreetingActionCode_Sum];
    SumStore *sumStore0 = [[SumStore alloc] init];
    sumStore0.factor = 1;
    SumStore *sumStore1 = [[SumStore alloc] init];
    sumStore1.factor = 2;
    SumStore *sumStore2 = [[SumStore alloc] init];
    sumStore2.factor = 3;
    
    [self.sumStores addObject:sumStore0];
    [self.sumStores addObject:sumStore1];
    [self.sumStores addObject:sumStore2];
    
    [sumStore2 respondEvent:sumEvent waitFor:sumStore1];
    [sumStore1 respondEvent:sumEvent waitFor:sumStore0];
    [self.dispatcher addEventResponder:sumStore0 forEvent:sumEvent];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)test4Greeting {
    do {
        NSArray *tickets = [self.dispatcher handleEvent:[GreetingActionCreater createActionWithDomain:GreetingActionDomain andCode:GreetingActionCode_Hello] withResponderCallback:^(id eventResponder, id <DCHEvent> outputEvent, NSError *error) {
            if (error) {
                NSLog(@"%@", [error description]);
            }
        }];
        
        NSLog(@"handle event over with tickets: %@", tickets);
        
        [DCHAsyncTest expect:^BOOL{
            return [self.viewModel.greeting isEqualToString:@"Hello, Suise."];
        } withCompletionHandler:^(BOOL promiseResult, NSError *error, NSDictionary *infoDic) {
            NSLog(@"PromiseResult: %d, Error: %@, Info: %@", promiseResult, error, infoDic);
        }];
    } while (NO);
}

- (void)test4Sum {
    do {
        NSArray *tickets = [self.dispatcher handleEvent:[GreetingActionCreater createActionWithDomain:GreetingActionDomain andCode:GreetingActionCode_Sum] withResponderCallback:^(id eventResponder, id <DCHEvent> outputEvent, NSError *error) {
            if (error) {
                NSLog(@"%@", [error description]);
            }
        }];
        
        NSLog(@"handle event over with tickets: %@", tickets);
        
        [DCHAsyncTest expect:^BOOL{
            SumStore *sumStore = self.sumStores.lastObject;
            return sumStore.result == 6;
        } withCompletionHandler:^(BOOL promiseResult, NSError *error, NSDictionary *infoDic) {
            NSLog(@"PromiseResult: %d, Error: %@, Info: %@", promiseResult, error, infoDic);
        }];
    } while (NO);
}

@end
