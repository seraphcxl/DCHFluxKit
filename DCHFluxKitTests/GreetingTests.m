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
#import "GreetingDispatcherHub.h"
#import "GreetingEvent.h"
#import "GreetingStore.h"
#import "GreetingViewModel.h"
#import "SumStore.h"

#import <Tourbillon/DCHTourbillon.h>

@interface GreetingTests : XCTestCase

@property (nonatomic, strong) GreetingStore *store;
@property (nonatomic, strong) GreetingViewModel *viewModel;
@property (nonatomic, strong) NSMutableArray *sumStores;
@property (nonatomic, assign) NSInteger num;

@end

@implementation GreetingTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.num = 99;
    self.store = [[GreetingStore alloc] init];
    self.viewModel = [[GreetingViewModel alloc] init];
    self.sumStores = [NSMutableArray array];
    
    id <DCHEvent> event = [GreetingActionCreater createActionWithDomain:GreetingActionDomain andCode:GreetingActionCode_Hello];
    
    [[GreetingDispatcher sharedGreetingDispatcher] addEventResponder:self.store forEvent:event];
    [self.store addEventResponder:self.viewModel forEvent:event];
    
    id <DCHEvent> sumEvent = [GreetingActionCreater createActionWithDomain:GreetingActionDomain andCode:GreetingActionCode_Sum];
    SumStore *sumStore0 = [[SumStore alloc] init];
    sumStore0.factor = 1;
    SumStore *sumStore1 = [[SumStore alloc] init];
    sumStore1.factor = 2;
    SumStore *sumStore2 = [[SumStore alloc] init];
    sumStore2.factor = 3;
    
    [self.sumStores addObject:sumStore2];
    [self.sumStores addObject:sumStore1];
    [self.sumStores addObject:sumStore0];
    
    NSLog(@"sumStore0: %@", sumStore0);
    NSLog(@"sumStore1: %@", sumStore1);
    NSLog(@"sumStore2: %@", sumStore2);
    
    SumStore *sumStore3 = [[SumStore alloc] init];
    sumStore3.factor = 5;
    [self.sumStores addObject:sumStore3];
    
    NSLog(@"sumStore3: %@", sumStore3);
    
    [sumStore2 respondEvent:sumEvent dependOn:sumStore1];
    [sumStore1 respondEvent:sumEvent dependOn:sumStore0];
    [[GreetingDispatcher sharedGreetingDispatcher] addEventResponder:sumStore0 forEvent:sumEvent];
    
    [[GreetingDispatcher sharedGreetingDispatcher] addEventResponder:sumStore3 forEvent:sumEvent];
    
    [[GreetingDispatcherHub sharedGreetingDispatcherHub] addDispatcher:[GreetingDispatcher sharedGreetingDispatcher]];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//- (void)testExample {
//    // This is an example of a functional test case.
//    XCTAssert(YES, @"Pass");
//}

//- (void)testPerformanceExample0 {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        do {
//            for (NSUInteger i = 0; i < 100000; ++i) {
//                NSInteger x = _num;
//            }
//        } while (NO);
//        // Put the code you want to measure the time of here.
//    }];
//}
//
//- (void)testPerformanceExample1 {
//    [self measureBlock:^{
//        do {
//            for (NSUInteger i = 0; i < 100000; ++i) {
//                NSInteger y = self.num;
//            }
//        } while (NO);
//        // Put the code you want to measure the time of here.
//    }];
//}

- (void)test4Greeting {
    do {
        NSArray *tickets = [[GreetingDispatcherHub sharedGreetingDispatcherHub] handleEvent:[GreetingActionCreater createActionWithDomain:GreetingActionDomain andCode:GreetingActionCode_Hello] inMainThread:NO withResponderCallback:^(id eventResponder, id <DCHEvent> outputEvent, NSError *error) {
            if (error) {
                NSLog(@"%@", [error description]);
            } else {
                NSLog(@"Responder: %@; Event: %@;", eventResponder, [outputEvent eventDescription]);
            }
        }];
        
        NSLog(@"handle event over with tickets: %@", tickets);
        
        [DCHAsyncTest expect:^BOOL{
            return [self.viewModel.greeting isEqualToString:@"Hello, Suise."];
        } withCompletionHandler:^(BOOL promiseResult, NSError *error, NSDictionary *infoDic) {
            NSLog(@"PromiseResult: %d, Error: %@, Info: %@", promiseResult, error, infoDic);
        }];
        
        NSArray *tickets1 = [[GreetingDispatcherHub sharedGreetingDispatcherHub] handleEvent:[GreetingActionCreater createActionWithDomain:GreetingActionDomain andCode:GreetingActionCode_Sum] inMainThread:YES withResponderCallback:^(id eventResponder, id <DCHEvent> outputEvent, NSError *error) {
            if (error) {
                NSLog(@"%@", [error description]);
            } else {
                NSLog(@"Responder: %@; Event: %@;", eventResponder, [outputEvent eventDescription]);
            }
        }];
        
        NSLog(@"handle event over with tickets: %@", tickets1);
        
        [DCHAsyncTest expect:^BOOL{
            SumStore *sumStore = self.sumStores.firstObject;
            return sumStore.result == 6;
        } withCompletionHandler:^(BOOL promiseResult, NSError *error, NSDictionary *infoDic) {
            NSLog(@"PromiseResult: %d, Error: %@, Info: %@", promiseResult, error, infoDic);
        }];
        
        [DCHAsyncTest expect:^BOOL{
            SumStore *sumStore = self.sumStores.lastObject;
            return sumStore.result == 5;
        } withCompletionHandler:^(BOOL promiseResult, NSError *error, NSDictionary *infoDic) {
            NSLog(@"PromiseResult: %d, Error: %@, Info: %@", promiseResult, error, infoDic);
        }];
    } while (NO);
}

@end
