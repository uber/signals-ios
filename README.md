# Signals

[![Build Status](https://travis-ci.org/uber/signals-ios.svg?branch=master)](https://travis-ci.org/uber/signals-ios)
[![Coverage Status](https://coveralls.io/repos/uber/signals-ios/badge.svg?branch=master&service=github)](https://coveralls.io/github/uber/signals-ios?branch=master)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/UberSignals.svg)](https://cocoapods.org/pods/UberSignals)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
![License](https://img.shields.io/cocoapods/l/Signals.svg?style=flat&color=gray)
![Platform](https://img.shields.io/cocoapods/p/UberSignals.svg?style=flat)

Signals is an eventing library that enables you to implement the Observable pattern without using error prone and clumsy NSNotifications or delegates.


## Features

- [x] Type-safety
- [x] Attach-and-forget observation
- [X] Configurable observation behaviour
- [x] Separate callback queues
- [x] Comprehensive Unit Test Coverage

## Installation
#### CocoaPods

To integrate Signals into your project add the following to your `Podfile`:

```ruby
pod 'UberSignals', '~> 2.0'
```

#### Carthage

To integrate Signals into your project using Carthage add the following to your `Cartfile`:

```ruby
github "uber/signals-ios" ~> 2.0
```

## Introduction

NSNotifications are inherently error prone. If a listener doesn’t de-register itself from a notification when it’s deallocated, firing the notification will crash the application. If you refactor the data you send with a notification, the compiler won't warn you but your app might crash at runtime.

NSNotifications are also unnecessarily broad. Anyone can listen in on them which couples separate components in your application implicitly together.

With NSNotifications you register a selector to be invoked when a notification fires. This makes code less readable by separating where you register for notifications and where you handle notifications.

NSNotifications also require a lot of boilerplate code to register unique names to use as notification identifiers.

Signals solves all of the above problems and provides an inline, type-safe and attach-and-forget way to observe events being fired by objects. It is also a great replacement for delegates when there is no need to return data from the delegates.

# Usage

Make a class observable by declaring a Signals in its header and implementing it in its initializer:

```objective-c

// Defines a new Signal type. This type is named "NetworkResult", and has two parameters 
// of type NSData and NSError. Note that the postfix "Signal" is automatically added to 
// the type name. Also note that only objects are allowed in Signal signatures.
CreateSignalType(NetworkResult, NSData *result, NSError *error)

@interface UBNetworkRequest

// We define two signals for our NetworkRequest class.
// - onNetworkResult will fire when a network result has been retreived.
// - onNetworkProgress will fire whenever download progresses.

// This uses the new signal type - NetworkResultSignal - that we've defined.
@property (nonatomic, readonly) UBSignal<NetworkResultSignal> *onNetworkResult;

// This makes use of a pre-defined signal type, FloatSignal.
@property (nonatomic, readonly) UBSignal<FloatSignal> *onNetworkProgress;

@end

@implementation UBNetworkRequest

- (instancetype)init {
  self = [super init];
  if (self) {
    // In the initializer the instance creates our signal
    _onNetworkResult = (UBSignal<NetworkResultSignal> *)
         [[UBSignal alloc] initWithProtocol:@protocol(NetworkResultSignal)];
    _onProgress = (UBSignal<FloatSignal> *)
         [[UBSignal alloc] initWithProtocol:@protocol(FloatSignal)];
   }
   return self;
}

- (void)receivedNetworkResult(NSData *data, NSError *error) 
{
  // Signal all listeners we're done loading
  _onNetworkProgress.fire(@(1.0))
  
  // Signal all listeners that we have data or an error
  _onNetworkResult.fire(myData, myError);
}

...

@end
```

Any class who has access to the NetworkResult instance, can now register itself as a listener and get notified whenever the network operation has loaded:

```objective-c
[networkRequest.onNetworkResult addObserver:self 
            callback:^(typeof(self) self, NSData *data, NSError *error) {
    // Do something with the result. The self passed into the block is 
    // weakified by Signals to guard against retain cycles.
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

### Advanced usage

You can configure the observer to cancel itself after it has observed a signal firing once:

```objective-c
[networkRequest.onNetworkResult addObserver:self 
            callback:^(typeof(self) self, NSData *data, NSError *error) {
    ...
}].cancelsAfterNextFire = YES;
```

The callback is by default called on the same NSOperationQueue than the signal fires on. To have it fire on a different queue, simply change the operationQueue parameter of the returned UBSignalObserver.

```objective-c
[networkRequest.onNetworkResult addObserver:self 
            callback:^(typeof(self) self, NSData *data, NSError *error) {
    ....
}].operationQueue = NSOperationQueue.mainQueue;
```

Signals remember with what data they were last fired with and you can force an observer to fire

```objective-c
[networkRequest.onNetworkResult addObserver:self 
            callback:^(typeof(self) self, NSData *data, NSError *error) {
    ....
}];
```

### Swift support

The protocol-based approach described above is the easiest way to define new Signal types. However, these are unfortunately not accessible from Swift code. In order for Swift to understand the type of your signals correctly, you have to create concrete sub-classes for each signal type. Signals provides two macros to do this: `CreateSignalInterface` to create the interface for your sub-class and `CreateSignalImplementation` to create the implementation. You then use the concrete sub-classes when you declare the signals for your class:

```objective-c

// Defines a new Signal interface, a sub-class of UBSignal with the given
// name and parameters
CreateSignalInterface(UBNetworkResultSignal, NSData *result, NSError *error)

@interface UBNetworkRequest

// We declare the signal with the concrete type
@property (nonatomic, readonly) UBNetworkResultSignal *onNetworkResult;

@end


// In your .m-file you also create the implementation for the sub-class

CreateSignalImplementation(UBNetworkResultSignal, NSData *result, NSError *error)

@implementation UBNetworkRequest

- (instancetype)init {
  self = [super init];
  if (self) {
    // You initialize it without a protocol
    _onNetworkResult = [[UBNetworkResultSignal alloc] init];
   }
   return self;
}

- (void)receivedNetworkResult(NSData *data, NSError *error) 
{
  // And use it as you normally would
  _onNetworkResult.fire(myData, myError);
}
```



## Max observers

Signals have a default maximum observer count of 100 and signals will NSAssert that you don't add more observers to them. This is to make you aware of situations where you are unknowingly oversubscribing to a signal (e.g. beause of memory leaks or re-registering an observer). 

If you have a legitimate case of increasing this limit, you can set the `maxObservers` property of a signal.

```objective-c
_onNetworkResult = (UBSignal<NetworkResultSignal> *)
      [[UBSignal alloc] initWithProtocol:@protocol(NetworkResultSignal)];
      
_onNetworkResult.maxObservers = 500;
```


## Signal naming

Each signal type created with the CreateSignalType macro creates a new protocol so that the compiler can enforce type safety. This means that the name you choose for your signal types need to be unique to your project. 

Frequently, a signal will fire no parameters or one parameter of the basic ObjC types. Signals therefore predefines a set of signal types that you can use:

```objective-c
EmptySignal, fires no parameters
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

## Contributions

We'd love for you to contribute to our open source projects. Before we can accept your contributions, we kindly ask you to sign our [Uber Contributor License Agreement](https://docs.google.com/a/uber.com/forms/d/1pAwS_-dA1KhPlfxzYLBqK6rsSWwRwH95OCCZrcsY5rk/viewform).

- If you **find a bug**, open an issue or submit a fix via a pull request.
- If you **have a feature request**, open an issue or submit an implementation via a pull request
- If you **want to contribute**, submit a pull request.

## License

Signals is released under a MIT license. See the LICENSE file for more information.
