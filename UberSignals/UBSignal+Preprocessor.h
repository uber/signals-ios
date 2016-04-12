//
//  UBSignal+Preprocessor.h
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

NS_ASSUME_NONNULL_BEGIN

#ifndef PP_NARG

#define PP_NARG(...) \
    PP_NARG_(__VA_ARGS__,PP_RSEQ_N())
#define PP_NARG_(...) \
    PP_ARG_N(__VA_ARGS__)
#define PP_ARG_N( \
    _1, _2, _3, _4, _5, _6, _7, _8, _9,_10, \
    _11,_12,_13,_14,_15,_16,_17,_18,_19,_20, \
    _21,_22,_23,_24,_25,_26,_27,_28,_29,_30, \
    _31,_32,_33,_34,_35,_36,_37,_38,_39,_40, \
    _41,_42,_43,_44,_45,_46,_47,_48,_49,_50, \
    _51,_52,_53,_54,_55,_56,_57,_58,_59,_60, \
    _61,_62,_63,  N, ...) N
#define PP_RSEQ_N() \
    63,62,61,60,                   \
    59,58,57,56,55,54,53,52,51,50, \
    49,48,47,46,45,44,43,42,41,40, \
    39,38,37,36,35,34,33,32,31,30, \
    29,28,27,26,25,24,23,22,21,20, \
    19,18,17,16,15,14,13,12,11,10, \
    9, 8, 7, 6, 5, 4, 3, 2, 1, 0

#endif

#define CreateSignalType_(signatureParameterCount, name, signature...) \
    CreateSignalType__(signatureParameterCount, name, signature)

#define CreateSignalType__(signatureParameterCount, name, signature...) \
    @protocol name ## Signal <UBSignalArgumentCount ## signatureParameterCount>\
    - (UBSignalObserver *)addObserver:(id)observer callback:(void (^)(id self, signature))callback; \
    - (void (^)(signature))fire; \
    - (void (^)(UBSignalObserver *signalObserver, signature))fireForSignalObserver; \
    @end

#define CreateSignalInterface_(signatureParameterCount, name, signature...) \
CreateSignalInterface__(signatureParameterCount, name, signature)

#define CreateSignalInterface__(signatureParameterCount, name, signature...) \
    @interface name : UBBaseSignal <UBSignalArgumentCount ## signatureParameterCount> {} \
    - (UBSignalObserver *)addObserver:(id)observer callback:(void (^)(id self, signature))callback; \
    - (void (^)(signature))fire;\
    - (void (^)(UBSignalObserver *signalObserver, signature))fireForSignalObserver; \
    - (instancetype)initWithProtocol:(Protocol *)protocol NS_UNAVAILABLE; \
    @end

#define NO_WARN_FOR_INCOMPLETE_IMPLEMENTATION_BEGIN \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wincomplete-implementation\"")

#define NO_WARN_FOR_INCOMPLETE_IMPLEMENTATION_END \
_Pragma("clang diagnostic pop") \

#define CreateSignalImplementation_(signatureParameterCount, name, signature...)\
CreateSignalImplementation__(signatureParameterCount, name, signature)

#define CreateSignalImplementation__(signatureParameterCount, name, signature...)\
NO_WARN_FOR_INCOMPLETE_IMPLEMENTATION_BEGIN \
@implementation name \
- (instancetype)init { \
    self = [super initWithProtocol:@protocol(UBSignalArgumentCount ## signatureParameterCount)]; \
    return self; \
} \
@end \
NO_WARN_FOR_INCOMPLETE_IMPLEMENTATION_END

@protocol UBSignalArgumentCount0 @end
@protocol UBSignalArgumentCount1 @end
@protocol UBSignalArgumentCount2 @end
@protocol UBSignalArgumentCount3 @end
@protocol UBSignalArgumentCount4 @end
@protocol UBSignalArgumentCount5 @end

NS_ASSUME_NONNULL_END
