//
//  UBSignalObserver.m
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

#import "UBSignalObserver+Internal.h"
#import "UBSignalObserver.h"


@interface UBSignalObserver ()

@property (nonatomic, weak) UBBaseSignal *signal;

@end

@implementation UBSignalObserver

#pragma mark - Initializers

- (instancetype)initWithSignal:(UBBaseSignal *)signal observer:(id)observer callback:(UBSignalCallback)callback
{
    self = [super self];
    if (self) {
        _signal = signal;
        _observer = observer;
        _callback = callback;
    }
    return self;
}


#pragma mark - NSObject

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"<%@: %p, observer: %@", NSStringFromClass([self class]), self, self.observer];
}


#pragma mark - Public Interface

- (BOOL)firePreviousData
{
    return [self.signal firePastDataForSignalObserver:self];
}

- (void)cancel
{
    [self.signal removeSignalObserver:self];
}

@end
