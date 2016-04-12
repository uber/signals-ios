//
//  UBSignal.h
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
#import "UBSignalObserver.h"

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Creates a new Signal type.
 
 @param name The name of the signal type. "Signal" will be appended to the name and used as the name for the protocol that defines the signal type.
 @param va_args The types and names of the parameters fired by the signal. NOTE! Signal parameters all have to be objects, no primitive types allowed. If you provide primitive types the compiler won't warn you, but your firing the signal will crash the application.
 */
#define CreateSignalType(name, signature...)\
    CreateSignalType_(PP_NARG(signature),name,signature)

/**
 Creates the interface for a typed Signal subclass. This alternative way of creating typed signals is compatible with Swift. This should be coupled with a call to CreateSignalImplementation in your .m-file.

 @param className The class name of the new signal.
 @param va_args The types and names of the parameters fired by the signal. NOTE! Signal parameters all have to be objects, no primitive types allowed. If you provide primitive types the compiler won't warn you, but your firing the signal will crash the application.
 */
#define CreateSignalInterface(className, signature...)\
CreateSignalInterface_(PP_NARG(signature),className,signature)

/**
 Creates the implementation for a typed Signal subclass. This alternative way of creating typed signals is compatible with Swift. This should be coupled with a call to CreateSignalInterface in your header-file.

 @param className The class name of the new signal.
 @param va_args The types and names of the parameters fired by the signal. NOTE! Signal parameters all have to be objects, no primitive types allowed. If you provide primitive types the compiler won't warn you, but your firing the signal will crash the application.
 */
#define CreateSignalImplementation(className, signature...)\
CreateSignalImplementation_(PP_NARG(signature),className,signature)


/** An Signal type that fires an Integer as a NSNumber */
CreateSignalType(Integer, NSNumber *number);

/** An Signal type that fires a Float as a NSNumber */
CreateSignalType(Float, NSNumber *number);

/** An Signal type that fires an Double as a NSNumber */
CreateSignalType(Double, NSNumber *number);

/** An Signal type that fires an Boolean as a NSNumber */
CreateSignalType(Boolean, NSNumber *number);

/** An Signal type that fires an NSString */
CreateSignalType(String, NSString *string);

/** An Signal type that fires an NSArray */
CreateSignalType(Array, NSArray *array);

/** An Signal type that fires a NSMutableArray */
CreateSignalType(MutableArray, NSMutableArray *mutableArray);

/** An Signal type that fires a NSDictionary */
CreateSignalType(Dictionary, NSDictionary *dictionary);

/** An Signal type that fires a NSMutableDictionary */
CreateSignalType(MutableDictionary, NSMutableDictionary *mutableDictionary);

/** An Signal type that fires an Integer as a NSNumber */
CreateSignalInterface(UBIntegerSignal, NSNumber *number);

/** An Signal type that fires a Float as a NSNumber */
CreateSignalInterface(UBFloatSignal, NSNumber *number);

/** An Signal type that fires an Double as a NSNumber */
CreateSignalInterface(UBDoubleSignal, NSNumber *number);

/** An Signal type that fires an Boolean as a NSNumber */
CreateSignalInterface(UBBooleanSignal, NSNumber *number);

/** An Signal type that fires an NSString */
CreateSignalInterface(UBStringSignal, NSString *string);

/** An Signal type that fires an NSArray */
CreateSignalInterface(UBArraySignal, NSArray *array);

/** An Signal type that fires a NSMutableArray */
CreateSignalInterface(UBMutableArraySignal, NSMutableArray *mutableArray);

/** An Signal type that fires a NSDictionary */
CreateSignalInterface(UBDictionarySignal, NSDictionary *dictionary);

/** An Signal type that fires a NSMutableDictionary */
CreateSignalInterface(UBMutableDictionarySignal, NSMutableDictionary *mutableDictionary);


/**
 A Signal represents a type of event that Observable objects implement and fire and Observers listen to.
 
 Each class that wants to implement the Observable pattern first register the types of events they fire using the CreateSignalType macro. This registers the type of data that is being fired by one of the Signals of the class to ensure type-safety. 
 
 Observable classes then define properties with the naming convention on<EventName> (e.g. onNetworkData, onError, etc.) and use the appropriate type of signal type (e.g UBSignal<NetworkDataSignal>) to delcare its signals.
 
 Observers register themselves to any Signals on instances they are interested in using the addObserver:callback: method of the Signal. Self is usually passed into the observer-parameter. The signal will weakify the observer pass it back to the the callback along with any parameters defined by the type of the Signal whenever the Signal fires. This way users don't have to weakify any references to self themselves and can rest assured that they're not creating retain cycles.
 
 Observable classes fire the signal by retreiving the fire-block of the signal through the fire-property of the signal and calling it with the type of data registered with the Signal.
 
 Signals will also detect deallocations of its observers, so it's not necessary to remove observers from Signals due to lifecycle changes.
 */
@protocol UBSignaling <NSObject>

@property (nonatomic, assign) NSUInteger maxObservers;

/**
 Notifies when an observer was added to a Signal.
 */
@property (nonatomic, strong) UBSignalObserverChange observerAdded;

/**
 Notifies when an observer was removed from a Signal.
 */
@property (nonatomic, strong) UBSignalObserverChange observerRemoved;

/**
 Removes an observer from the Signal. If the observer has registered multiple callbacks with the Signal, all of them are removed.
 
 @param observer The observer to remove from the Signal.
 */
- (void)removeObserver:(NSObject *)observer;

/**
 Removes all observers from a Signal.
*/
- (void)removeAllObservers;

@end

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


@interface UBSignal : UBBaseSignal <UBSignaling>

/**
 Helper factory method, constructs a Signal instance with the EmptySignal protocol.
 */
+ (UBSignal<EmptySignal> *)emptySignal;

/**
 Initializes a Signal with a given protocol. An empty signal should call this initializer with the EmptySignal protocol.
 */
- (instancetype)initWithProtocol:(Protocol *)protocol NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

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
