# Signals

[![Build Status](https://travis-ci.org/uber/signals-ios.svg?branch=master)](https://travis-ci.org/uber/signals-ios)
[![Cocoapods Compatible](https://img.shields.io/cocoapods/v/UberSignals.svg)](https://cocoapods.org/pods/UberSignals)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
![License](https://img.shields.io/cocoapods/l/Signals.svg?style=flat&color=gray)
![Platform](https://img.shields.io/cocoapods/p/UberSignals.svg?style=flat)

Signals is an eventing framework that enables you to implement the Observable pattern without using error prone and clumsy NSNotifications or delegates.


## Features

- [x] Type-safety
- [x] Attach-and-forget observation
- [x] Specify operation queue to observe events on
- [x] Comprehensive Unit Test Coverage

## Installation
#### Cocoapods

To integrate UberSignals into your project add the following to your `Podfile`:

```ruby
pod 'UberSignals', '~> 1.0'
```

#### Carthage

To integrate UberSignals into your project using Carthage add the following to your `Cartfile`:

```ruby
github "uber/signals-ios" ~> 1.0
```

## Introduction

NSNotifications are inherently error prone. If a listener doesn’t de-register itself from a notification when it’s deallocated, firing the notification will crash the application. If you refactor the data you send with a notification, the compiler won't warn you but your app might crash at runtime.

NSNotifications are also unnecessarily broad. Anyone can listen in on them which couples separate components in your application implicitly together.

With NSNotifications you register a selector to be invoked when a notification fires. This makes code less readable by separating where you register for notifications and where you handle notifications.

NSNotifications also require a lot of boilerplate code to register unique names to use as notification identifiers.

UberSignals solves all of the above problems and provides an inline, type-safe and attach-and-forget way to observe events being fired by objects. It is also a great replacement for delegates when there is no need to return data from the delegates.

# Usage

Make a class observable by declaring a Signals in its header and implementing it in its initializer:

```objective-c
// Defines a new Signal type. This type is named "NetworkResult", and has two parameters 
// of type NSData and NSError. Note that the postfix "Signal" is automatically added to 
// the type name. Also note that only objects are allowed in Signal signatures.
CreateSignalType(NetworkResult, NSData *result, NSError *error)

// In your header you define the signal
@property (nonatomic, readonly) UBSignal<NetworkResultSignal> *onNetworkResult;

// In the initializer the instance creates the signal
_onNetworkResult = (UBSignal<NetworkResultSignal> *)
      [[UBSignal alloc] initWithProtocol:@protocol(NetworkResultSignal)];

// Whenever the instance receives a network result (with NSData and NSError), it
// fires off the signal.
_onNetworkResult.fire(myData, myError);
```

Any class who has access to the NetworkResult instance, can now register itself as a listener and get notified whenever the network operation has loaded:

```objective-c
[networkRequest.onNetworkResult addObserver:self 
            callback:^(typeof(self) self, NSData *data, NSError *error) {
    // Do something with the result. The self passed into the block is weakified by Signals
    // to guard against retain cycles.
}];
```

To cancel a single observer, call cancel on the returned UBSignalObserver:

```objective-c
UBSignalObserver *observer = [networkRequest.onNetworkResult addObserver:self 
        callback:^(typeof(self) self, NSData *data, NSError *error) {
    ...
}];
...
[observer cancel];
```

You can also configure the observer to cancel itself after it has observed a signal firing once:

```objective-c
[networkRequest.onNetworkResult addObserver:self 
            callback:^(typeof(self) self, NSData *data, NSError *error) {
    ...
}].cancelsAfterNextFire = YES;
```

The callback is by default called on the same NSOperationQueue than the signal fires on. To change this, simply change the operationQueue parameter of the returned UBSignalObserver.

```objective-c
[networkRequest.onNetworkResult addObserver:self 
            callback:^(typeof(self) self, NSData *data, NSError *error) {
    ....
}].operationQueue = NSOperationQueue.mainQueue;
```

### Default Signals
UberEvents pre-defines the following Signal types:

```objective-c
IntegerSignal, fires a NSNumber
FloatSignal, fires a NSNumber
DoubleSignal, fires a NSNumber
BooleanSignal, fires a NSNumber
StringSignal, fires a NSString
ArraySignal, fires a NSArray
MutableArraySignal, fires a NSMutableArray
DictionarySignal, fires a NSDictionary
MutableDictionarySignal, fires a NSMutableDictionary
```
