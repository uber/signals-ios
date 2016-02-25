//
//  UBBaseSignal.m
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

#import "UBBaseSignal.h"
#import "UBSignal+Preprocessor.h"
#import "UBSignalObserver+Internal.h"

#import <objc/runtime.h>


typedef void (^UBSignalFire) (id arg1, id arg2, id arg3, id arg4, id arg5);
#define WrapNil(name) (name == nil ? [NSNull null] : name)


@interface UBBaseSignal ()

@property (nonatomic, readonly) id fire;
@property (nonatomic, readonly) id fireForSignalObserver;
@property (nonatomic, strong) NSMutableArray *signalObservers;
@property (nonatomic, strong) NSArray *lastData;

@end


@implementation UBBaseSignal

#pragma mark - Initializers

- (instancetype)initWithProtocol:(Protocol *)protocol
{
    self = [super init];
    if (self) {
        _signalObservers = [NSMutableArray array];
        _maxObservers = 100;

        __weak typeof(self) weakSelf = self;
        if (protocol_conformsToProtocol(protocol, @protocol(UBSignalArgumentCount0))) {
            _fire = (UBSignalFire) ^void() {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf _fireData:nil forSignalObservers:strongSelf.signalObservers];
            };
            _fireForSignalObserver = (UBSignalFire) ^void(UBSignalObserver *signalObserver) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf _fireData:nil forSignalObservers:@[signalObserver]];
            };
        } else if (protocol_conformsToProtocol(protocol, @protocol(UBSignalArgumentCount1))) {
            _fire = ^void(id arg1) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf _fireNewData:@[WrapNil(arg1)] forSignalObservers:strongSelf.signalObservers];
            };
            _fireForSignalObserver = ^void(UBSignalObserver *signalObserver, id arg1) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf _fireNewData:@[WrapNil(arg1)] forSignalObservers:@[signalObserver]];
            };
        } else if (protocol_conformsToProtocol(protocol, @protocol(UBSignalArgumentCount2))) {
            _fire = ^void(id arg1, id arg2) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf _fireNewData:@[WrapNil(arg1), WrapNil(arg2)] forSignalObservers:strongSelf.signalObservers];
            };
            _fireForSignalObserver = ^void(UBSignalObserver *signalObserver, id arg1, id arg2) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf _fireNewData:@[WrapNil(arg1), WrapNil(arg2)] forSignalObservers:@[signalObserver]];
            };
        } else if (protocol_conformsToProtocol(protocol, @protocol(UBSignalArgumentCount3))) {
            _fire = ^void(id arg1, id arg2, id arg3) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf _fireNewData:@[WrapNil(arg1), WrapNil(arg2), WrapNil(arg3)] forSignalObservers:strongSelf.signalObservers];
            };
            _fireForSignalObserver = ^void(UBSignalObserver *signalObserver, id arg1, id arg2, id arg3) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf _fireNewData:@[WrapNil(arg1), WrapNil(arg2), WrapNil(arg3)] forSignalObservers:@[signalObserver]];
            };
        } else if (protocol_conformsToProtocol(protocol, @protocol(UBSignalArgumentCount4))) {
            _fire = ^void(id arg1, id arg2, id arg3, id arg4) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf _fireNewData:@[WrapNil(arg1), WrapNil(arg2), WrapNil(arg3), WrapNil(arg4)] forSignalObservers:strongSelf.signalObservers];
            };
            _fireForSignalObserver = ^void(UBSignalObserver *signalObserver, id arg1, id arg2, id arg3, id arg4) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf _fireNewData:@[WrapNil(arg1), WrapNil(arg2), WrapNil(arg3), WrapNil(arg4)] forSignalObservers:@[signalObserver]];
            };
        } else if (protocol_conformsToProtocol(protocol, @protocol(UBSignalArgumentCount5))) {
            _fire = ^void(id arg1, id arg2, id arg3, id arg4, id arg5) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf _fireNewData:@[WrapNil(arg1), WrapNil(arg2), WrapNil(arg3), WrapNil(arg4), WrapNil(arg5)] forSignalObservers:strongSelf.signalObservers];
            };
            _fireForSignalObserver = ^void(UBSignalObserver *signalObserver, id arg1, id arg2, id arg3, id arg4, id arg5) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf _fireNewData:@[WrapNil(arg1), WrapNil(arg2), WrapNil(arg3), WrapNil(arg4), WrapNil(arg5)] forSignalObservers:@[signalObserver]];
            };
        } else {
            NSAssert(false, @"Protocol doesn't provide parameter count");
        }
    }
    return self;
}


#pragma mark - NSObject

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"<%@: %p, signalObservers: %@", NSStringFromClass([self class]), self, [self.signalObservers debugDescription]];
}


#pragma mark - Properties

- (void)setMaxObservers:(NSUInteger)maxObservers
{
    _maxObservers = maxObservers;
    NSAssert(_signalObservers.count <= _maxObservers, @"Maximum observer count exceeded for this signal");
}


#pragma mark - Public interface

- (UBSignalObserver *)addObserver:(id)observer callback:(UBSignalCallback)callback
{
    if (observer == nil) {
        NSAssert(NO, @"Observer cannot be nil");
        return nil;
    }

    if (callback == nil) {
        NSAssert(NO, @"Callback cannot be nil");
        return nil;
    }

    [self _purgeDeallocedListeners];
    UBSignalObserver *signalObserver = [[UBSignalObserver alloc] initWithSignal:self observer:observer callback:callback];
    @synchronized(_signalObservers) {
        [_signalObservers addObject:signalObserver];
        NSAssert(_signalObservers.count <= _maxObservers, @"Maximum observer count exceeded for this signal");
    }

    if (self.observerAdded) {
        self.observerAdded(signalObserver);
    }

    return signalObserver;
}

- (void)removeObserver:(NSObject *)observer
{
    [self _purgeDeallocedListeners];
    NSMutableArray *removedSignalObservers = [NSMutableArray array];
    @synchronized(_signalObservers) {
        for (UBSignalObserver *signalObserver in [_signalObservers copy]) {
            if (signalObserver.observer == observer) {
                [_signalObservers removeObject:signalObserver];
                [removedSignalObservers addObject:signalObserver];
            }
        }
    }

    if (removedSignalObservers.count &&
        self.observerRemoved) {
        for (UBSignalObserver *removedSignalObserver in removedSignalObservers) {
            self.observerRemoved(removedSignalObserver);
        }
    }
}

- (void)removeAllObservers
{
    @synchronized(_signalObservers) {
        [_signalObservers removeAllObjects];
    }
}


#pragma mark - Internal Interface

- (void)removeSignalObserver:(UBSignalObserver *)signalObserver
{
    @synchronized(_signalObservers) {
        [_signalObservers removeObject:signalObserver];
    }

    if (self.observerRemoved) {
        self.observerRemoved(signalObserver);
    }
}

- (BOOL)firePastDataForSignalObserver:(UBSignalObserver *)signalObserver
{
    NSArray *data;
    @synchronized(_signalObservers) {
        data = [_lastData copy];
    }

    if (data) {
        [self _fireData:data forSignalObservers:@[signalObserver]];
        return YES;
    }

    return NO;
}


#pragma mark - Private Interface

- (void)_purgeDeallocedListeners
{
    @synchronized(_signalObservers) {
        NSMutableArray *deallocedListeners;
        for (UBSignalObserver *signalObserver in [_signalObservers copy]) {
            if (signalObserver.observer == nil) {
                [_signalObservers removeObject:signalObserver];

                if (!deallocedListeners) {
                    deallocedListeners = [NSMutableArray array];
                }
                [deallocedListeners addObject:signalObserver];
            }
        }
        for (UBSignalObserver *removedObserver in deallocedListeners) {
            if (self.observerRemoved) {
                self.observerRemoved(removedObserver);
            }
        }
    }
}

- (void)_fireNewData:(NSArray *)arguments forSignalObservers:(NSArray *)signalObsevers
{
    @synchronized(_signalObservers) {
        _lastData = arguments;
    }
    [self _fireData:arguments forSignalObservers:signalObsevers];
}

- (void)_fireData:(NSArray *)arguments forSignalObservers:(NSArray *)signalObservers
{
    NSAssert(arguments.count < 6, @"A maximum of 5 arguments are supported when firing a Signal");

    [self _purgeDeallocedListeners];

    id arg1, arg2, arg3, arg4, arg5;
    switch (arguments.count) {
        case 5:
            arg5 = arguments[4] != [NSNull null] ? arguments[4] : nil;
        case 4:
            arg4 = arguments[3] != [NSNull null] ? arguments[3] : nil;
        case 3:
            arg3 = arguments[2] != [NSNull null] ? arguments[2] : nil;
        case 2:
            arg2 = arguments[1] != [NSNull null] ? arguments[1] : nil;
        case 1:
            arg1 = arguments[0] != [NSNull null] ? arguments[0] : nil;
    }

    NSArray *signalObserversCopy;
    @synchronized(_signalObservers) {
        signalObserversCopy = [signalObservers copy];
    }
    for (UBSignalObserver *signalObserver in signalObserversCopy) {
        __strong id observer = signalObserver.observer;

        void (^fire)() = ^void() {
            UBSignalCallback callback = signalObserver.callback;

            if (signalObserver.cancelsAfterNextFire == YES) {
                [signalObserver cancel];
            }

            switch (arguments.count) {
                case 0:
                    callback(observer); break;
                case 1:
                    ((UBSignalCallbackArgCount1)callback)(observer, arg1); break;
                case 2:
                    ((UBSignalCallbackArgCount2)callback)(observer, arg1, arg2); break;
                case 3:
                    ((UBSignalCallbackArgCount3)callback)(observer, arg1, arg2, arg3); break;
                case 4:
                    ((UBSignalCallbackArgCount4)callback)(observer, arg1, arg2, arg3, arg4); break;
                case 5:
                    ((UBSignalCallbackArgCount5)callback)(observer, arg1, arg2, arg3, arg4, arg5); break;
            }
        };

        if (signalObserver.operationQueue == nil || NSOperationQueue.currentQueue == signalObserver.operationQueue) {
            fire();
        } else {
            [signalObserver.operationQueue addOperationWithBlock:^{
                fire();
            }];
        }
    }
}

@end
