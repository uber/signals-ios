//
//  UBEmptySignal.h
//  UberSignals
//
//  Copyright (c) 2016 Uber Technologies, Inc.
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


#import "UBBaseSignal.h"
#import "UBSignal+Preprocessor.h"

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 A special type of signal that doesn't have any parameters.
 */
@protocol EmptySignal <UBSignalArgumentCount0>

/**
 Adds an observer to the Signal.
 
 @param observer The observing object. The observer will be weakified and passed back to the callback as a convenience and safe-guard against retain cycles in the callback block. If the observer be deallocated, the observaiton will also be canceled.
 @param callback A block to call whenever the Signal fires.
 @return A UBSignalObserver that can be used to cancel the observation.
 */
- (UBSignalObserver *)addObserver:(id)observer callback:(void (^)(id self))callback;

/**
 Returns a block that fires the signal when invoked.
 */
- (void (^)(void))fire;

/**
 Returns a block that fires the signal for a specific observer when invoked.
 */
- (void (^)(UBSignalObserver *signalObserver))fireForSignalObserver;

@end

/**
 A special type of signal that doesn't have any parameters.
 */
@interface UBEmptySignal : UBBaseSignal <UBSignalArgumentCount0>

- (UBSignalObserver *)addObserver:(id)observer callback:(void (^)(id self))callback; \
- (void (^)())fire;
- (void (^)(UBSignalObserver *signalObserver))fireForSignalObserver;
- (instancetype)initWithProtocol:(Protocol *)protocol NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
