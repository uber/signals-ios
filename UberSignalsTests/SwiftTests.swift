//
//  SwiftTests.swift
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

import XCTest

class SwiftTests: XCTestCase {

    func testEmptyObservation() {
        var observed = 0
        let observer = UBSignalEmitter()

        observer.onEmptySignalSwift.addObserver(self) { (listener) in
            observed += 1
        }

        observer.onEmptySignalSwift.fire()()

        XCTAssertEqual(observed, 1, "Should have fired callback")
    }

    func testPredefinedSignals() {
        var observed = 0

        let signal = UBDictionarySignal()
        signal.addObserver(self) { (listener) in
            observed += 1
        }
        signal.fire()(Dictionary())

        let signal2 = UBArraySignal()
        signal2.addObserver(self) { (listener, result) in
            XCTAssertEqual(result as NSArray, NSArray(objects: "result"), "Should have signaled correct result")
            observed += 1
        }
        signal2.fire()(["result"])

        let signal3 = UBFloatSignal()
        signal3.addObserver(self) { (listener, result) in
            XCTAssertEqual(result, 20.0, "Should have signaled correct result")
            observed += 1
        }
        signal3.fire()(20.0)

        let signal4 = UBDoubleSignal()
        signal4.addObserver(self) { (listener, result) in
            XCTAssertEqual(result, 20.0, "Should have signaled correct result")
            observed += 1
        }
        signal4.fire()(20.0)

        let signal5 = UBBooleanSignal()
        signal5.addObserver(self) { (listener, result) in
            XCTAssertEqual(result, true, "Should have signaled correct result")
            observed += 1
        }
        signal5.fire()(true)

        let signal6 = UBIntegerSignal()
        signal6.addObserver(self) { (listener, result) in
            XCTAssertEqual(result, 10, "Should have signaled correct result")
            observed += 1
        }
        signal6.fire()(10)

        let signal7 = UBMutableDictionarySignal()
        signal7.addObserver(self) { (listener, result) in
            XCTAssertEqual(result, NSMutableDictionary(), "Should have signaled correct result")
            observed += 1
        }
        signal7.fire()(NSMutableDictionary())

        XCTAssertEqual(observed, 7, "Should have fired callback")
    }

    func testObservation() {
        var observed = 0
        let observer = UBSignalEmitter()

        observer.onSwiftSignal.addObserver(self) { (listener, string) in
            XCTAssertEqual(string, "1", "Should have received correct value")
            observed += 1
        }

        observer.onSwiftDoubleSignal.addObserver(self) { (listener, string, number) in
            observed += 1
            XCTAssertEqual(string, "1", "Should have received correct value")
            XCTAssertEqual(number, 2, "Should have received correct value")
        }

        observer.onSwiftSignal.fire()("1")
        observer.onSwiftDoubleSignal.fire()("1", 2)
        XCTAssertEqual(observed, 2, "Should have fired callback")
    }
}
