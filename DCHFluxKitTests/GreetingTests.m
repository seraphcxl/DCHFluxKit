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

#import "DCHAsyncTest.h"

@interface GreetingTests : XCTestCase

@property (nonatomic, strong) GreetingDispatcher *dispatcher;
@property (nonatomic, strong) GreetingStore *store;
@property (nonatomic, strong) GreetingViewModel *viewModel;

@end

@implementation GreetingTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.dispatcher = [[GreetingDispatcher alloc] init];
    self.store = [[GreetingStore alloc] init];
    self.viewModel = [[GreetingViewModel alloc] init];
    
    id <DCHEvent> event = [GreetingActionCreater createActionWithDomain:GreetingActionDomain andCode:GreetingActionCode_Hello];
    
    [self.dispatcher addEventResponder:self.store forEvent:event];
    [self.store addEventResponder:self.viewModel forEvent:event];
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

@end
