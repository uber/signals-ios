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
        observer.onSwiftDoubleSignal.fire()("1", NSNumber(integer: 2))
        XCTAssertEqual(observed, 2, "Should have fired callback")
    }
}
