//
//  UBBaseSignal.h
//  UberSignals
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

#import "UBSignalObserver.h"

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^UBSignalObserverChange)(UBSignalObserver *signalObserver);

/**
 Internal base class for signals. You should not instantiate this directly. Instead, use UBSignal or one of your created signal subclasses.
 */
@interface UBBaseSignal : NSObject

@property (nonatomic, assign) NSUInteger maxObservers;
@property (nonatomic, strong) UBSignalObserverChange observerAdded;
@property (nonatomic, strong) UBSignalObserverChange observerRemoved;

- (instancetype)initWithProtocol:(Protocol *)protocol;
- (void)removeObserver:(NSObject *)observer;
- (void)removeAllObservers;

@end

NS_ASSUME_NONNULL_END
