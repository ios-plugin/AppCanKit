//
//  PluginArgument.swift
//  AppCanKitSwift
//

import Foundation
import AppCanKit

/// 当前WK桥传入的单个插件参数，不依赖JavaScriptCore的JSValue。
///
/// 普通类型解析复用AppCanKit；匿名回调直接使用ACJSFunctionRef。
/// 只面向当前WK插件链路，不提供本地JavaScriptCore的参数或同步回调封装。
public struct PluginArgument {
    /// 原始参数。缺参、ACNil和NSNull统一保存为nil，容器内的空值保持原样。
    public let rawValue: Any?

    /// 接收引擎传给插件的原生参数，不创建额外的JSContext。
    public init(_ value: Any?) {
        // 与ObjC解包的空值处理保持一致，同时接收直接传入的NSNull。
        if value is ACNil || value is NSNull {
            rawValue = nil
        } else {
            rawValue = value
        }
    }

    /// 解析字符串或数值；其他类型返回nil。
    public var stringValue: String? {
        return ac_stringArg(rawValue)
    }

    /// 解析数值或非空数值字符串，沿用ObjC的NSDecimalNumber转换规则。
    public var numberValue: NSNumber? {
        return ac_numberArg(rawValue)
    }

    /// 兼容旧Swift封装中的true/false字符串，其余值按ObjC数值规则转换。
    public var boolValue: Bool? {
        if let string = rawValue as? String {
            switch string {
            case "true": return true
            case "false": return false
            default: break
            }
        }
        return numberValue?.boolValue
    }

    /// 解析原生数组或JSON数组文本，不过滤数组中的元素。
    public var arrayValue: [Any]? {
        return ac_arrayArg(rawValue)
    }

    /// 解析原生字典或JSON对象文本，保留ObjC允许的非字符串字典键。
    public var dictionaryValue: [AnyHashable: Any]? {
        return ac_dictionaryArg(rawValue)
    }

    /// 返回引擎创建的匿名回调引用；普通字符串不能作为函数使用。
    ///
    /// 需要延迟或重复回调时由插件持有该对象；执行与释放交给ObjC实现，
    /// 不创建第二套callback ID容器，也不提供同步返回JSValue的接口。
    public var functionValue: ACJSFunctionRef? {
        return ac_JSFunctionArg(rawValue)
    }
}
