//
//  UBSignal.m
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

#import "UBSignal.h"

#import <objc/runtime.h>

#import "UBSignalObserver+Internal.h"

CreateSignalImplementation(UBIntegerSignal, NSNumber *number);
CreateSignalImplementation(UBFloatSignal, NSNumber *number);
CreateSignalImplementation(UBDoubleSignal, NSNumber *number);
CreateSignalImplementation(UBBooleanSignal, NSNumber *number);
CreateSignalImplementation(UBStringSignal, NSString *string);
CreateSignalImplementation(UBArraySignal, NSArray *array);
CreateSignalImplementation(UBMutableArraySignal, NSMutableArray *mutableArray);
CreateSignalImplementation(UBDictionarySignal, NSDictionary *dictionary);
CreateSignalImplementation(UBMutableDictionarySignal, NSMutableDictionary *mutableDictionary);

@implementation UBSignal : UBBaseSignal

+ (UBSignal<EmptySignal> *)emptySignal
{
    return (UBSignal<EmptySignal> *)[[UBSignal alloc] initWithProtocol:@protocol(EmptySignal)];
}

- (instancetype)initWithProtocol:(Protocol *)protocol {
    self = [super initWithProtocol:protocol];
    return self;
}

@end


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"

@implementation UBEmptySignal

- (instancetype)init {
    self = [super initWithProtocol:@protocol(UBSignalArgumentCount0)];
    return self;
}
#pragma clang diagnostic pop

@end
