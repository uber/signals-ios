//
//  UBSignalTests.m
//  UberSignalsTests
//
//  Copyright (c) 2015 Uber Technologies, Inc.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import <XCTest/XCTest.h>

#import "UBSignalEmitter.h"

@interface UBSignalTests : XCTestCase
@end

@implementation UBSignalTests

- (void)testFireEmptySignal
{
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    
    __block BOOL fired;
    __block id callbackSelf;
    
    [emitter.onEmptySignal addObserver:self callback:^(typeof(self) self) {
        fired = YES;
        callbackSelf = self;
    }];
    
    emitter.onEmptySignal.fire();
    
    XCTAssert(fired, @"Signal fired");
    XCTAssertEqual(callbackSelf, self, @"Callback should contain correct self argument");
}

- (void)testFireSignalWithData
{
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    
    __block BOOL fired;
    __block id callbackSelf;
    __block NSNumber *callbackInteger;
    
    [emitter.onIntegerSignal addObserver:self callback:^(id self, NSNumber *integer) {
        fired = YES;
        callbackSelf = self;
        callbackInteger = integer;
    }];
    
    emitter.onIntegerSignal.fire(@(10));
    
    XCTAssert(fired, @"Signal fired");
    XCTAssertEqual(callbackSelf, self, @"Callback should contain correct self argument");
    XCTAssertEqual(callbackInteger, @(10), @"Should fire correct number");
}

- (void)testFireSignalWithTwoDataTypes
{
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    
    __block BOOL fired;
    __block id callbackSelf;
    __block NSString *callbackStringData;
    __block NSString *callbackOtherStringData;
    
    [emitter.onStringSignal addObserver:self callback:^(typeof(self) self, NSString *stringData, NSString *otherStringData) {
        fired = YES;
        callbackSelf = self;
        callbackStringData = stringData;
        callbackOtherStringData = otherStringData;
    }];
    
    emitter.onStringSignal.fire(@"First", @"Second");
    
    XCTAssert(fired, @"Signal fired");
    XCTAssertEqual(callbackSelf, self, @"Callback should contain correct self argument");
    XCTAssertEqual(callbackStringData, @"First", @"Should fire correct string");
    XCTAssertEqual(callbackOtherStringData, @"Second", @"Should fire correct string");
}

- (void)testFireSignalWithThreeDataTypes
{
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    
    __block BOOL fired;
    
    [emitter.onTripleSignal addObserver:self callback:^(id self, NSString *string1, NSString *string2, NSNumber *number1) {
        fired = YES;
        XCTAssertEqual(string1, @"string1", @"Should get correct argument");
        XCTAssertEqual(string2, @"string2", @"Should get correct argument");
        XCTAssertEqual(number1, @(1), @"Should get correct argument");
    }];
    
    emitter.onTripleSignal.fire(@"string1", @"string2", @(1));
    
    XCTAssert(fired, @"Signal fired");
}

- (void)testFireSignalWithFourDataType
{
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    
    __block BOOL fired;
    
    [emitter.onQuardrupleSignal addObserver:self callback:^(id self, NSString *string1, NSString *string2, NSNumber *number1, NSNumber *number2) {
        fired = YES;
        XCTAssertEqual(string1, @"string1", @"Should get correct argument");
        XCTAssertEqual(string2, @"string2", @"Should get correct argument");
        XCTAssertEqual(number1, @(1), @"Should get correct argument");
        XCTAssertEqual(number2, @(2), @"Should get correct argument");
    }];
    
    emitter.onQuardrupleSignal.fire(@"string1", @"string2", @(1), @(2));
    
    XCTAssert(fired, @"Signal fired");
}

- (void)testFireSignalWithFiveDataTypes
{
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    
    __block BOOL fired = NO;
    
    [emitter.onComplexSignal addObserver:self callback:^(id self, NSNumber *number1, NSNumber *number2, NSNumber *number3, NSNumber *number4, NSNumber *number5) {
        
        fired = YES;
        XCTAssertEqual(number1, @(1), @"Should get correct argument");
        XCTAssertEqual(number2, @(2), @"Should get correct argument");
        XCTAssertEqual(number3, @(3), @"Should get correct argument");
        XCTAssertEqual(number4, @(4), @"Should get correct argument");
        XCTAssertEqual(number5, @(5), @"Should get correct argument");
    }];
    
    emitter.onComplexSignal.fire(@(1), @(2), @(3), @(4), @(5));
    
    XCTAssert(fired, @"Signal fired");
}

- (void)testCreatingSignalWithUnsupportedProtocol
{
    XCTAssertThrows([[UBSignal alloc] initWithProtocol:@protocol(TestProtocol)], @"Should have thrown assert");
}

- (void)testFireSignalWithNilData
{
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    
    __block BOOL fired = NO;
    __block id callbackSelf = nil;
    __block NSString *callbackStringData = @"test";
    __block NSString *callbackOtherStringData = @"test";
    
    [emitter.onStringSignal addObserver:self callback:^(typeof(self) self, NSString *stringData, NSString *otherStringData) {
        fired = YES;
        callbackSelf = self;
        callbackStringData = stringData;
        callbackOtherStringData = otherStringData;
    }];
    
    emitter.onStringSignal.fire(nil, nil);
    
    XCTAssert(fired, @"Signal fired");
    XCTAssertEqual(callbackSelf, self, @"Callback should contain correct self argument");
    XCTAssertNil(callbackStringData, @"Should fire correct string");
    XCTAssertNil(callbackOtherStringData, @"Should fire correct string");
}

- (void)testFireSignalForSpecificObserver
{
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    
    __block BOOL firstSignalFired = NO;
    __block BOOL secondSignalFired = NO;
    
    UBSignalObserver *firstSignalObserver = [emitter.onEmptySignal addObserver:self callback:^(typeof(self) self) {
        firstSignalFired = YES;
    }];
    [emitter.onEmptySignal addObserver:self callback:^(typeof(self) self) {
        secondSignalFired = YES;
    }];
    
    emitter.onEmptySignal.fireForSignalObserver(firstSignalObserver);
    
    XCTAssertTrue(firstSignalFired, @"First signal fired");
    XCTAssertFalse(secondSignalFired, @"Second signal did not fire");
}

- (void)testFireSignalWithDataForSpecificObserver
{
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    
    __block BOOL firstSignalFired = NO;
    __block BOOL secondSignalFired = NO;
    
    UBSignalObserver *firstSignalObserver = [emitter.onIntegerSignal addObserver:self callback:^(id self, NSNumber *integer) {
        firstSignalFired = YES;
    }];
    [emitter.onIntegerSignal addObserver:self callback:^(id self, NSNumber *integer) {
        secondSignalFired = YES;
    }];
    
    emitter.onIntegerSignal.fireForSignalObserver(firstSignalObserver, @(10));
    
    XCTAssertTrue(firstSignalFired, @"First signal fired");
    XCTAssertFalse(secondSignalFired, @"Second signal did not fire");
}

- (void)testFireSignalWithTwoDataTypesForSpecificObserver
{
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    
    __block BOOL firstSignalFired = NO;
    __block BOOL secondSignalFired = NO;
    
    UBSignalObserver *firstSignalObserver = [emitter.onStringSignal addObserver:self callback:^(typeof(self) self, NSString *stringData, NSString *otherStringData) {
        firstSignalFired = YES;
    }];
    [emitter.onStringSignal addObserver:self callback:^(typeof(self) self, NSString *stringData, NSString *otherStringData) {
        secondSignalFired = YES;
    }];
    
    emitter.onStringSignal.fireForSignalObserver(firstSignalObserver, @"First", @"Second");
    
    XCTAssertTrue(firstSignalFired, @"First signal fired");
    XCTAssertFalse(secondSignalFired, @"Second signal did not fire");
}

- (void)testFireSignalWithThreeDataTypesForSpecificObserver
{
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    
    __block BOOL firstSignalFired = NO;
    __block BOOL secondSignalFired = NO;
    
    UBSignalObserver *firstSignalObserver = [emitter.onTripleSignal addObserver:self callback:^(id self, NSString *string1, NSString *string2, NSNumber *number1) {
        firstSignalFired = YES;
    }];
    [emitter.onTripleSignal addObserver:self callback:^(id self, NSString *string1, NSString *string2, NSNumber *number1) {
        secondSignalFired = YES;
    }];
    
    emitter.onTripleSignal.fireForSignalObserver(firstSignalObserver, @"string1", @"string2", @(1));
    
    XCTAssertTrue(firstSignalFired, @"First signal fired");
    XCTAssertFalse(secondSignalFired, @"Second signal did not fire");
}

- (void)testFireSignalWithFourDataTypeForSpecificObserver
{
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    
    __block BOOL firstSignalFired = NO;
    __block BOOL secondSignalFired = NO;
    
    UBSignalObserver *firstSignalObserver = [emitter.onQuardrupleSignal addObserver:self callback:^(id self, NSString *string1, NSString *string2, NSNumber *number1, NSNumber *number2) {
        firstSignalFired = YES;
    }];
    [emitter.onQuardrupleSignal addObserver:self callback:^(id self, NSString *string1, NSString *string2, NSNumber *number1, NSNumber *number2) {
        secondSignalFired = YES;
    }];
    
    emitter.onQuardrupleSignal.fireForSignalObserver(firstSignalObserver, @"string1", @"string2", @(1), @(2));
    
    XCTAssertTrue(firstSignalFired, @"First signal fired");
    XCTAssertFalse(secondSignalFired, @"Second signal did not fire");
}

- (void)testFireSignalWithFiveDataTypesForSpecificObserver
{
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    
    __block BOOL firstSignalFired = NO;
    __block BOOL secondSignalFired = NO;
    
    UBSignalObserver *firstSignalObserver = [emitter.onComplexSignal addObserver:self callback:^(id self, NSNumber *number1, NSNumber *number2, NSNumber *number3, NSNumber *number4, NSNumber *number5) {
        firstSignalFired = YES;
    }];
    [emitter.onComplexSignal addObserver:self callback:^(id self, NSNumber *number1, NSNumber *number2, NSNumber *number3, NSNumber *number4, NSNumber *number5) {
        secondSignalFired = YES;
    }];
    
    emitter.onComplexSignal.fireForSignalObserver(firstSignalObserver, @(1), @(2), @(3), @(4), @(5));
    
    XCTAssertTrue(firstSignalFired, @"First signal fired");
    XCTAssertFalse(secondSignalFired, @"Second signal did not fire");
}

- (void)testRemovingAnObserver
{
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    NSObject *observer1 = [[NSObject alloc] init];
    NSObject *observer2 = [[NSObject alloc] init];
    
    __block BOOL fired1 = NO;
    __block BOOL fired2 = NO;
    
    [emitter.onStringSignal addObserver:observer1 callback:^(id observer, NSString *stringData, NSString *otherStringData) {
        fired1 = YES;
    }];
    [emitter.onStringSignal addObserver:observer2 callback:^(id observer, NSString *stringData, NSString *otherStringData) {
        fired2 = YES;
    }];

    [emitter.onStringSignal removeObserver:observer1];
    
    emitter.onStringSignal.fire(nil, nil);

    XCTAssert(fired1 == NO, @"Signal should not have fired callbacks");
    XCTAssert(fired2 == YES, @"Signal should have fired callbacks");
}

- (void)testRemovingAllObservers
{
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    NSObject *observer1 = [[NSObject alloc] init];
    NSObject *observer2 = [[NSObject alloc] init];

    [emitter.onStringSignal addObserver:observer1 callback:^(id observer, NSString *stringData, NSString *otherStringData) {
        XCTFail(@"Signal should not have fired");
    }];
    [emitter.onStringSignal addObserver:observer2 callback:^(id observer, NSString *stringData, NSString *otherStringData) {
        XCTFail(@"Signal should not have fired");
    }];
    
    [emitter.onStringSignal removeAllObservers];
    emitter.onStringSignal.fire(nil, nil);
}

- (void)testCancelASignalObserver
{
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    
    __block BOOL fired1 = NO;
    __block BOOL fired2 = NO;
    
    UBSignalObserver *signalObserver = [emitter.onStringSignal addObserver:self callback:^(typeof(self) self, NSString *stringData, NSString *otherStringData) {
        fired1 = YES;
    }];
    [emitter.onStringSignal addObserver:self callback:^(typeof(self) self, NSString *stringData, NSString *otherStringData) {
        fired2 = YES;
    }];
    
    [signalObserver cancel];
    
    emitter.onStringSignal.fire(nil, nil);
    XCTAssert(fired1 == NO, @"Signal should not have fired callbacks");
    XCTAssert(fired2 == YES, @"Signal should have fired callbacks");
}

- (void)testCancelsAfterFire
{
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    NSObject *observer1 = [[NSObject alloc] init];

    __block NSUInteger fireCount = 0;
    
    UBSignalObserver *observer = [emitter.onStringSignal addObserver:observer1 callback:^(id observer, NSString *stringData, NSString *otherStringData) {
        fireCount++;
    }];

    emitter.onStringSignal.fire(nil, nil);
    
    observer.cancelsAfterNextFire = YES;
    
    emitter.onStringSignal.fire(nil, nil);
    emitter.onStringSignal.fire(nil, nil);
    
    XCTAssertEqual(fireCount, 2u, @"Signal fire should have been observed three times");
}

- (void)testCancelsAfterFireWithPreviousData
{
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    NSObject *observer1 = [[NSObject alloc] init];
    emitter.onStringSignal.fire(nil, nil);
    
    __block NSUInteger fireCount = 0;

    UBSignalObserver *observer = [emitter.onStringSignal addObserver:observer1 callback:^(id observer, NSString *stringData, NSString *otherStringData) {
        fireCount++;
    }];
    
    observer.cancelsAfterNextFire = YES;
    [observer firePreviousData];
    
    XCTAssertEqual(fireCount, 1u, @"Signal fire should have been observed one time");
    
    emitter.onStringSignal.fire(nil, nil);
    XCTAssertEqual(fireCount, 1u, @"Signal fire should have been observed one time");
}

- (void)testRetainingOfWeakSelfForDurationOfCallback
{
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    __block NSObject *observer = [[NSObject alloc] init];
    
    __block BOOL fired = NO;
    
    [emitter.onStringSignal addObserver:observer callback:^(id weakifiedObject, NSString *stringData, NSString *otherStringData) {
        fired = YES;
        observer = nil;
        XCTAssertNotNil(weakifiedObject, @"The weakified object should not have been collected");
    }];
    
    emitter.onStringSignal.fire(nil, nil);
    XCTAssert(fired, @"Signal should have fired callbacks");
}

- (void)testRemovalOfDeallocatedListeners
{
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    NSObject *observer = [[NSObject alloc] init];

    [emitter.onStringSignal addObserver:observer callback:^(id theWeakifiedObject, NSString *stringData, NSString *otherStringData) {
         XCTFail(@"Signal should not have fired callbacks on deallocated listener");
    }];
    
    observer = nil;
    emitter.onStringSignal.fire(nil, nil);
}

- (void)testLateFiringOfSignal
{
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    
    __block BOOL fired = NO;
    __block id callbackSelf = nil;
    __block NSString *callbackStringData;
    __block NSString *callbackOtherStringData;
    
    UBSignalObserver *signalObserver = [emitter.onStringSignal addObserver:self callback:^(typeof(self) self, NSString *stringData, NSString *otherStringData) {}];
    BOOL didFire = [signalObserver firePreviousData];
    
    emitter.onStringSignal.fire(@"First", @"Second");
    
    signalObserver = [emitter.onStringSignal addObserver:self callback:^(typeof(self) self, NSString *stringData, NSString *otherStringData) {
        fired = YES;
        callbackSelf = self;
        callbackStringData = stringData;
        callbackOtherStringData = otherStringData;
    }];
    
    BOOL didFire2 = [signalObserver firePreviousData];
    
    XCTAssertFalse(didFire, @"firePastData should not report data being fired");
    XCTAssertTrue(didFire2, @"firePastData should report data being fired");
    XCTAssert(fired, @"Signal fired");
    XCTAssertEqual(callbackSelf, self, @"Callback should contain correct self argument");
    XCTAssertEqual(callbackStringData, @"First", @"Should fire correct string");
    XCTAssertEqual(callbackOtherStringData, @"Second", @"Should fire correct string");
}

- (void)testSettingOperationQueueForCallback
{
    XCTestExpectation *fire1 = [self expectationWithDescription:@"Fire 1"];
    XCTestExpectation *fire2 = [self expectationWithDescription:@"Fire 2"];
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.qualityOfService = NSOperationQueuePriorityLow;
    
    [emitter.onStringSignal addObserver:self callback:^(id weakifiedObject, NSString *stringData, NSString *otherStringData) {
        XCTAssert(NSOperationQueue.currentQueue == NSOperationQueue.mainQueue, @"Should have been called on the correct queue");
        [fire1 fulfill];
    }];
    
    [emitter.onStringSignal addObserver:self callback:^(id weakifiedObject, NSString *stringData, NSString *otherStringData) {
        XCTAssert(NSOperationQueue.currentQueue == queue, @"Should have been called on the correct queue");
        [fire2 fulfill];
    }].operationQueue = queue;
    
    emitter.onStringSignal.fire(nil, nil);
    
    [self waitForExpectationsWithTimeout:0.2 handler:nil];
}

- (void)testFiringSignalOnSameOperationQueue
{
    XCTestExpectation *fire = [self expectationWithDescription:@"Fire"];
    
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.qualityOfService = NSOperationQueuePriorityLow;
    
    [emitter.onStringSignal addObserver:self callback:^(id weakifiedObject, NSString *stringData, NSString *otherStringData) {
        XCTAssert(NSOperationQueue.currentQueue == queue, @"Should have been called on the correct queue");
        [fire fulfill];
    }].operationQueue = queue;
    
    [queue addOperationWithBlock:^{
        emitter.onStringSignal.fire(nil, nil);
    }];
    
    [self waitForExpectationsWithTimeout:0.2 handler:nil];
}

- (void)testNilObserverCallback
{
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    XCTAssertThrowsSpecificNamed([emitter.onStringSignal addObserver:self callback:nil], NSException, NSInternalInconsistencyException, "Should have returned back a NSInternalInconsistencyException because the callback cannot be nil");
}

- (void)testDelegateAddCallback
{
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    
    __block BOOL fired = NO;
    emitter.onEmptySignal.observerAdded = ^(UBSignalObserver *signalObserver) {
        fired = YES;
    };
    
    [emitter.onEmptySignal addObserver:self callback:^(id self) {
        // this space left intentionally blank
    }];
    
    XCTAssertTrue(fired, @"observerAdded callback should have fired");
}

- (void)testDelegateRemoveCallbackOnCancel
{
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    
    __block UBSignalObserver *observer = nil;
    __block BOOL fired = NO;
    emitter.onEmptySignal.observerRemoved = ^(UBSignalObserver *signalObserver) {
        XCTAssertEqual(signalObserver, observer, @"signalObserver should be the same object as was originally returned by addObserver:");
        fired = YES;
    };
    
    observer = [emitter.onEmptySignal addObserver:self callback:^(id self) {
        // this space left intentionally blank
    }];
    [observer cancel];
    
    XCTAssertTrue(fired, @"observerRemoved callback should have fired");
}

- (void)testDelegateRemoveCallbackOnExplicitRemoval
{
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    
    __block UBSignalObserver *observer = nil;
    __block BOOL fired = NO;
    emitter.onEmptySignal.observerRemoved = ^(UBSignalObserver *signalObserver) {
        XCTAssertEqual(signalObserver, observer, @"signalObserver should be the same object as was originally returned by addObserver:");
        fired = YES;
    };
    
    observer = [emitter.onEmptySignal addObserver:self callback:^(id self) {
        // this space left intentionally blank
    }];
    [emitter.onEmptySignal removeObserver:self];
    
    XCTAssertTrue(fired, @"observerRemoved callback should have fired");
}

- (void)testDelegateRemoveCallbackOnObserverNil
{
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    
    __block UBSignalObserver *observer = nil;
    __block BOOL fired = NO;
    emitter.onEmptySignal.observerRemoved = ^(UBSignalObserver *signalObserver) {
        XCTAssertEqual(signalObserver, observer, @"signalObserver should be the same object as was originally returned by addObserver:");
        fired = YES;
    };
    
    NSObject *observerObject = [[NSObject alloc] init];
    observer = [emitter.onEmptySignal addObserver:observerObject callback:^(id self) {
        // this space left intentionally blank
    }];
    observerObject = nil;
    
    [emitter.onEmptySignal addObserver:self callback:^(id self) {
        // this space left intentionally blank
    }];
    
    XCTAssertTrue(fired, @"observerRemoved callback should have fired");
}

- (void)testMaxObservers
{
    UBSignal<EmptySignal> *signal = (UBSignal<EmptySignal> *)[[UBSignal alloc] initWithProtocol:@protocol(EmptySignal)];
    signal.maxObservers = 2;
    
    [signal addObserver:self callback:^(id self) {}];
    [signal addObserver:self callback:^(id self) {}];
    
    XCTAssertThrows([signal addObserver:self callback:^(id self) {}], @"Should have complained about max observers");
}

- (void)testSettingMaxObserversBelowObservers
{
    UBSignal<EmptySignal> *signal = (UBSignal<EmptySignal> *)[[UBSignal alloc] initWithProtocol:@protocol(EmptySignal)];
    [signal addObserver:self callback:^(id self) {}];
    [signal addObserver:self callback:^(id self) {}];
    
    XCTAssertNoThrow(signal.maxObservers = 2, @"Shouldn't have complained about max observers");
    XCTAssertThrows(signal.maxObservers = 1, @"Should have complained about max observers");
}

- (void)testAllArgumentCounts
{
    UBSignal<EmptySignal> *signal = (UBSignal<EmptySignal> *)[[UBSignal alloc] initWithProtocol:@protocol(EmptySignal)];
    signal.maxObservers = 2;
    
    [signal addObserver:self callback:^(id self) {}];
    [signal addObserver:self callback:^(id self) {}];
    
    XCTAssertThrows([signal addObserver:self callback:^(id self) {}], @"Should have complained about max observers");
}

- (void)testObservingWithoutCallback
{
    UBSignal<EmptySignal> *signal = (UBSignal<EmptySignal> *)[[UBSignal alloc] initWithProtocol:@protocol(EmptySignal)];
    XCTAssertThrows([signal addObserver:nil callback:^(id self) {}], @"Should have complained about nil observer");
    XCTAssertThrows([signal addObserver:self callback:nil], @"Should have complained about nil callback");
}

- (void)testRemovingListenerWhileInObserverCallback {
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    
    __block NSUInteger fireCount = 0;
    __block UBSignalObserver *observer = nil;
    __block UBSignalObserver *observer2 = nil;
    
    observer = [emitter.onEmptySignal addObserver:self callback:^(typeof(self) self) {
        fireCount++;
        [observer cancel];
    }];
    observer2 = [emitter.onEmptySignal addObserver:self callback:^(typeof(self) self) {
        fireCount++;
        [observer cancel];
    }];
    
    emitter.onEmptySignal.fire();
    
    XCTAssertEqual(fireCount, 2u, @"Signal fired");
}

- (void)testAddListenerWhileInObserverCallback {
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    
    __block NSUInteger fireCount = 0;

    [emitter.onEmptySignal addObserver:self callback:^(typeof(self) self) {
        fireCount++;
        [emitter.onEmptySignal addObserver:self callback:^(typeof(self) self) {
            fireCount++;
        }];
    }];
    
    emitter.onEmptySignal.fire();
    emitter.onEmptySignal.fire();
    
    XCTAssertEqual(fireCount, 3u, @"Signal fired");
}

- (void)testFiringShouldNotRetainObserver {
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    
    __block NSUInteger fireCount = 0;
    
    
    NSObject *observer = [[NSObject alloc] init];
    __weak NSObject *weakObserver = observer;
    
    @autoreleasepool {
        [emitter.onEmptySignal addObserver:observer callback:^(typeof(self) self) {
            fireCount++;
        }];
        emitter.onEmptySignal.fire();
        emitter.onEmptySignal.fire();
    }
    
    observer = nil;
    
    XCTAssertEqual(fireCount, 2u, @"Signal fired");
    XCTAssertNil(weakObserver, @"Should have deallocated observer");
}

- (void)testRemovingObserverWhileFiringShouldNotRetainObserver {
    UBSignalEmitter *emitter = [[UBSignalEmitter alloc] init];
    
    __block NSUInteger fireCount = 0;
    
    NSObject *observer = [[NSObject alloc] init];
    __weak NSObject *weakObserver = observer;
    
    @autoreleasepool {
        [emitter.onEmptySignal addObserver:observer callback:^(typeof(self) self) {
            fireCount++;
            [emitter.onEmptySignal removeObserver:observer];
        }];
        
        emitter.onEmptySignal.fire();
        emitter.onEmptySignal.fire();
        
        observer = nil;
    }
    XCTAssertEqual(fireCount, 1u, @"Signal fired");
    XCTAssertNil(weakObserver, @"Should have deallocated observer");
}

- (void)testUBSignalHelper
{
    UBSignal<EmptySignal> *emptySignalWithHelper = [UBSignal emptySignal];
    XCTAssertEqualObjects([emptySignalWithHelper class], [UBSignal class], @"Object created with helper factory method should be a UBSignal");
}

- (void)testDebugDescription
{
    UBSignal<EmptySignal> *signal = (UBSignal<EmptySignal> *)[[UBSignal alloc] initWithProtocol:@protocol(EmptySignal)];
    [signal addObserver:self callback:^(id self) {}];
    XCTAssert([[signal debugDescription] containsString:@"<UBSignal: "], @"Should contain string");
    XCTAssert([[signal debugDescription] containsString:@"NSArray"], @"Should contain string");
    XCTAssert([[signal debugDescription] containsString:@"<UBSignalObserver: "], @"Should contain string");
}

- (void)testAddingInvalidObservers
{
    UBSignal<EmptySignal> *signal = (UBSignal<EmptySignal> *)[[UBSignal alloc] initWithProtocol:@protocol(EmptySignal)];
    XCTAssertThrows([signal addObserver:nil callback:^(id self) {}], @"Should have asserted");
    XCTAssertThrows([signal addObserver:self callback:nil], @"Should have asserted");
}

@end
