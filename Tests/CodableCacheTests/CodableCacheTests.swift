//
//  CodableCacheTests.swift
//  CodableCache
//
//  Created by Andrew Sowers on 9/10/17.
//  Copyright © 2017 CodableCache. All rights reserved.
//

import Foundation
import XCTest
import CodableCache

class CodableCacheTests: XCTestCase {
    
    struct TestData: Codable {
        let testing: [Int]
    }
    
    func ==(lhs: TestData, rhs: TestData) -> Bool {
        return lhs.testing == rhs.testing
    }
    
    var encoder = JSONEncoder()
    var decoder = JSONDecoder()
    
    var testData: TestData = TestData(testing: [1, 2, 3])
    
    var codableCache: CodableCache = CodableCache<TestData>(key: "com.something.interesting")
    
    override func setUp() {
        super.setUp()
        encoder = JSONEncoder()
        encoder.dataEncodingStrategy = .base64
        // Since JSON does not natively allow for infinite or NaN values, we can customize strategies for encoding these non-conforming values.
        encoder.nonConformingFloatEncodingStrategy = .convertToString(positiveInfinity: "INF", negativeInfinity: "-INF", nan: "NaN")

    
        decoder = JSONDecoder()
        decoder.dataDecodingStrategy = .base64
        // Look for and match these values when decoding `Double`s or `Float`s.
        decoder.nonConformingFloatDecodingStrategy = .convertFromString(positiveInfinity: "INF", negativeInfinity: "-INF", nan: "NaN")

        testData = TestData(testing: [1, 2, 3])
        
        codableCache = CodableCache<TestData>(key: "com.something.interesting", encoder: encoder, decoder: decoder)
        do {
            try codableCache.clear()
        } catch {}
    }
    
    func testCodable() {
        let payload: Data
        do {
            payload = try encoder.encode(testData)
        } catch {
            XCTFail()
            return
        }
        
        let unwrappedTestData: TestData
        do {
            unwrappedTestData = try decoder.decode(TestData.self, from: payload)
        } catch {
            XCTFail()
            return
        }
        
        XCTAssert(testData == unwrappedTestData)
    }
    
    func testCodableMemoryCache() {
        do {
            try codableCache.set(value: testData)
        } catch {
            XCTFail()
            return
        }
        
        guard let newTestDataValue = codableCache.get() else {
            XCTFail("Test data is nil when it should not be")
            return
        }

        XCTAssert(testData == newTestDataValue)
    }
    
    func testCodablePersistentCache() {
        do {
            try codableCache.set(value: testData)
        } catch {
            XCTFail()
            return
        }

        let newCache = CodableCache<TestData>(key: "com.something.interesting")

        guard let unwrappedTestData = newCache.get() else {
            XCTFail("Unwrapped test data is nil when it should not be")
            return
        }

        XCTAssert(testData == unwrappedTestData)
    }
    
    func testJSONPersistence() {
        let json =
        """
            {
                "testing": [
                    1,
                    2,
                    3
                ]
            }
        """

        guard let data = json.data(using: .utf8) else {
            XCTFail()
            return
        }

        let decodedTestData: TestData
        do {
            decodedTestData = try decoder.decode(TestData.self, from: data)
            XCTAssert(type(of: decodedTestData) == TestData.self)

            try codableCache.set(value: decodedTestData)
            let newCodableCache = CodableCache<TestData>(key: "com.something.interesting")

            let otherDecodedTestData = newCodableCache.get()
            XCTAssertNotNil(otherDecodedTestData, "Decoded test data is nil when it should not be")

        } catch {
            XCTFail()
            return
        }
    }
    
    func testAbsenseOfValue() {
        let someCache = CodableCache<TestData>(key: "com.bogus.key")
        
        let expectedNilCacheValue = someCache.get()
        XCTAssertNil(expectedNilCacheValue, "The cache value should have been nil for an uninitialized cache")
    }
    
    func testNestedValues() {

        struct Foo: Codable {

            struct Bar: Codable {
                let hello: String
            }

            let bar: Bar

        }

        let foo = Foo(bar: Foo.Bar(hello: "world"))

        let cache = CodableCache<Foo>(key: "FooBar")

        do {
            try cache.set(value: foo)

            guard let foo2 = CodableCache<Foo>(key: "FooBar").get() else {
                XCTFail("Were not able to extract value from the cache")
                return
            }

            XCTAssert(foo.bar.hello == foo2.bar.hello)
        } catch {
            XCTFail()
        }

    }
    
    
}
