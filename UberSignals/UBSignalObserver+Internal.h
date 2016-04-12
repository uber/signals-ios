//
//  UBSignalObserver+Internal.h
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

#import "UBSignal+Internal.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^UBSignalCallback) (id listener, ...);
typedef void (^UBSignalCallbackArgCount1) (id listener, id arg1);
typedef void (^UBSignalCallbackArgCount2) (id listener, id arg1, id arg2);
typedef void (^UBSignalCallbackArgCount3) (id listener, id arg1, id arg2, id arg3);
typedef void (^UBSignalCallbackArgCount4) (id listener, id arg1, id arg2, id arg3, id arg4);
typedef void (^UBSignalCallbackArgCount5) (id listener, id arg1, id arg2, id arg3, id arg4, id arg5);

@class UBSignal;

/**
 A SignalObserver is returned whenever an observer is added to a UBSignal. Use it to cancel this specific observation.
 */
@interface UBSignalObserver ()

@property (nonatomic, weak, readonly) id observer;
@property (nonatomic, readonly) UBSignalCallback callback;

- (instancetype)initWithSignal:(UBBaseSignal *)signal observer:(id)observer callback:(UBSignalCallback)callback;

@end

NS_ASSUME_NONNULL_END
