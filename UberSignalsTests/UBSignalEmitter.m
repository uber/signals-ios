//
//  UBSignalEmitter.m
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

#import "UBSignalEmitter.h"

CreateSignalImplementation(UBSwiftSignal, NSString *stringData)
CreateSignalImplementation(UBSwiftDoubleSignal, NSString *stringData, NSNumber *numberDate)

@implementation UBSignalEmitter

-(instancetype)init
{
    self = [super init];
    if (self) {
        _onEmptySignal = (UBSignal<EmptySignal> *)[[UBSignal alloc] initWithProtocol:@protocol(EmptySignal)];
        _onIntegerSignal = (UBSignal<IntegerSignal> *)[[UBSignal alloc] initWithProtocol:@protocol(IntegerSignal)];
        _onStringSignal = (UBSignal<TupleSignal> *)[[UBSignal alloc] initWithProtocol:@protocol(TupleSignal)];
        _onTripleSignal = (UBSignal<TripleSignal> *)[[UBSignal alloc] initWithProtocol:@protocol(TripleSignal)];
        _onQuardrupleSignal = (UBSignal<QuadrupleSignal> *)[[UBSignal alloc] initWithProtocol:@protocol(QuadrupleSignal)];
        _onComplexSignal = (UBSignal<ComplexSignal> *)[[UBSignal alloc] initWithProtocol:@protocol(ComplexSignal)];
        _onSwiftSignal = [[UBSwiftSignal alloc] init];
        _onSwiftDoubleSignal = [[UBSwiftDoubleSignal alloc] init];
    }
    return self;
}

@end
