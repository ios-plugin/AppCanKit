//
//  PluginArgumentTests.swift
//  AppCanKitSwiftTests
//

import XCTest
import AppCanKit
import AppCanKitSwift

/// 覆盖当前WK桥传入的原生参数；真实网页回调另外通过设备集成验收。
final class PluginArgumentTests: XCTestCase {
    func testMissingAndNullValues() {
        let values: [Any?] = [nil, ACNil.null(), NSNull()]
        for value in values {
            let argument = PluginArgument(value)
            XCTAssertNil(argument.rawValue)
            XCTAssertNil(argument.stringValue)
            XCTAssertNil(argument.numberValue)
            XCTAssertNil(argument.boolValue)
            XCTAssertNil(argument.arrayValue)
            XCTAssertNil(argument.dictionaryValue)
            XCTAssertNil(argument.functionValue)
        }
    }

    func testStringAndNumberConversionsFollowObjectiveC() {
        XCTAssertEqual(PluginArgument("text").stringValue, ac_stringArg("text"))
        XCTAssertEqual(PluginArgument(123).stringValue, ac_stringArg(123))
        XCTAssertEqual(PluginArgument("12.5").numberValue, ac_numberArg("12.5"))
        XCTAssertEqual(PluginArgument(123).numberValue, ac_numberArg(123))
        XCTAssertNil(PluginArgument("").numberValue)
        XCTAssertNil(PluginArgument([1, 2]).numberValue)
        XCTAssertNil(PluginArgument(["key": "value"]).stringValue)
    }

    func testBooleanConversions() {
        XCTAssertEqual(PluginArgument(true).boolValue, true)
        XCTAssertEqual(PluginArgument(false).boolValue, false)
        XCTAssertEqual(PluginArgument("true").boolValue, true)
        XCTAssertEqual(PluginArgument("false").boolValue, false)
        XCTAssertEqual(PluginArgument("0").boolValue, false)
        XCTAssertEqual(PluginArgument(1).boolValue, true)
        XCTAssertNil(PluginArgument([]).boolValue)
    }

    func testNativeAndJSONContainers() {
        let array: [Any] = [1, "two", NSNull()]
        XCTAssertEqual(PluginArgument(array).arrayValue?.count, 3)
        XCTAssertTrue(PluginArgument(array).arrayValue?[2] is NSNull)
        XCTAssertEqual(PluginArgument("[1,2]").arrayValue as? [Int], [1, 2])
        XCTAssertEqual(PluginArgument("{\"nested\":{\"count\":2}}")
            .dictionaryValue?["nested"] as? [String: Int], ["count": 2])

        // ObjC接口允许非字符串字典键，Swift薄封装也不擅自丢弃。
        let dictionary: [AnyHashable: Any] = [1: "one", "two": 2]
        XCTAssertEqual(PluginArgument(dictionary).dictionaryValue?[1] as? String, "one")
        XCTAssertNil(PluginArgument("not JSON").arrayValue)
        XCTAssertNil(PluginArgument("[]").dictionaryValue)
        XCTAssertNil(PluginArgument("{}").arrayValue)
    }

    func testFunctionReferencePreservesIdentity() {
        let reference = ACJSFunctionRef()
        let argument = PluginArgument(reference)
        XCTAssertTrue(argument.functionValue === reference)
        XCTAssertTrue(argument.rawValue as AnyObject? === reference)
        XCTAssertNil(PluginArgument("callback ID").functionValue)
        XCTAssertNil(PluginArgument([:]).functionValue)
    }
}
