# Signals

Signals is an eventing framework that enables you to implement the Observable pattern without using NSNotifications.

- Notifications are inherently error prone. If a listener doesn’t de-register itself from a notification when it’s deallocated, firing the notification will crash the application.
- You register a selector to be invoked when a notification fires. This makes code less readable by separating where you register for a notification and where your code that gets executed due to a notification firing actually lives.
- Notification data is not type-safe making it error-prone and hard to refactor.
- Notifications has a lot of boilerplate code to register unique notification names.

Signals solves all of the above problems and provides an inline, type-safe and fire-and-forget way to observe events being fired by objects.

# Usage

Make a class observable by declaring a Signals in its header and implementing it in its initializer:

```
// Defines a new Signal type. This type is named "NetworkResult", and has two parameters 
// of type NSData and NSError. Note that the postfix "Signal" is automatically added to the type name.
// Also note that only objects are allowed in Signal signatures.
CreateSignalType(NetworkResult, NSData *result, NSError *error)

// In your header you define the signal
@property (nonatomic, readonly) UBSignal<NetworkResultSignal> *onNetworkResult;

// In the initializer the instance creates the signal
_onNetworkResult = (UBSignal<NetworkResultSignal> *)[[UBSignal alloc] initWithProtocol:@protocol(NetworkResultSignal)];

// Whenever the instance receives a network result (with NSData and NSError), it
// fires off the signal.
_onNetworkResult.fire(myData, myError);
```

Any class who has access to the NetworkResult instance, can now register itself as a listener and get notified whenever the network operation has loaded:

```
[networkRequest.onNetworkResult addObserver:self callback:^(typeof(self) self, NSData *data, NSError *error) {
    // Do something with the result. The self passed into the block is weakified by Signals
    // to guard against retain cycles.
}];
```

To cancel a single observer, call cancel on the returned UBSignalObserver:

```
UBSignalObserver *observer = [networkRequest.onNetworkResult addObserver:self callback:^(typeof(self) self, NSData *data, NSError *error) {
    ....
}];
...
[observer cancel];
```

You can also configure the observer to canel itself after it has observed a signal firing once:

```
[networkRequest.onNetworkResult addObserver:self callback:^(typeof(self) self, NSData *data, NSError *error) {
    ....
}].cancelsAfterNextFire = YES;
```

The callback is by default called on the same NSOperationQueue than the signal fires on. To change this, simply change the operationQueue parameter of the returned UBSignalObserver.

```
[networkRequest.onNetworkResult addObserver:self callback:^(typeof(self) self, NSData *data, NSError *error) {
    ....
}].operationQueue = NSOperationQueue.mainQueue;
```

### Default Signals
UberEvents pre-defines the following Signal types:

```
IntegerSignal, fires a NSNumber
FloatSignal, fires a NSNumber
DoubleSignal, fires a NSNumber
BooleanSignal, fires a NSNumber
StringSignal, fires a NSString
ArraySignal, fies a NSArray
MutableArraySignal, fires a NSMutableArray
DictionarySignal, fires a NSDictionary
MutableDictionarySignal, fires a NSMutableDictionary
```
