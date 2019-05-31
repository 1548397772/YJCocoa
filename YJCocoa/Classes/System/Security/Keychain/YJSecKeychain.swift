//
//  YJSecKeychain.swift
//  Pods
//
//  Created by 阳君 on 2019/5/31.
//

import UIKit

func YJSecKeychainItemSelect(item: YJSecKeychainItem) {
    var result: CFTypeRef? = nil
    let status = SecItemCopyMatching(item.selectDict as CFDictionary, &result)
    var dict = result as! Dictionary<String, Any>
}

public protocol YJSecKItemAttribute {
    /// 存储类型，支持搜索
    var kClass: CFString { get set }
    /// 访问组,支持搜索 kSecAttrAccessGroup
    var accessGroup: String { get set }
    /// 可访问性 kSecAttrAccessible
    var accessible: String { get set }
    /// 标签 kSecAttrAccessible
    var label: String? { get set }
}

/// kSecClassGenericPassword携带属性
public protocol YJSecKItemGenericPasswordAttribute {
    /// 账号，支持搜索 kSecAttrAccount
    var account: String! { get set }
    /// 创建日期 kSecAttrCreationDate
    var createDate: Date! { get }
    /// 最后一次修改日期 kSecAttrModificationDate
    var modifyDate: Date! { get }
    /// 描述 kSecAttrDescription
    var desc: String? { get set }
    /// 注释 kSecAttrComment
    var comment: String? { get set }
    /// 创造者 kSecAttrCreator
    var creator: Int { get set }
    /// 类型 kSecAttrType
    var type: Int { get set }
    /// 是否隐藏 kSecAttrIsInvisible
    var isInvisible: Bool { get set }
    /// 是否具有密码 kSecAttrIsNegative
    var isNegative: Bool { get set }
    /// 所具有服务 kSecAttrService
    var service: String? { get set }
    /// 用户自定义内容 kSecAttrGeneric
    var generic: Data? { get set }
}

open class YJSecKeychainItem: NSObject {
    
    /// 查询字典
    fileprivate var selectDict = Dictionary<CFString, String>()
    /// 缓存字典
    fileprivate var weakDict = Dictionary<CFString, Any>()
    /// 持久化字典
    fileprivate var strongDict = Dictionary<CFString, Any>()
    
    public var kClass: CFString = "" as CFString
    
    public init(kClass: CFString) {
        self.kClass = kClass
    }
    
    /// 存储kSecClassGenericPassword(一般密码)数据
    class func buildGenericPassword() -> YJSecKeychainItem {
        return YJSecKeychainItem(kClass: kSecClassGenericPassword)
    }
    
}

extension YJSecKeychainItem: YJSecKItemAttribute {

    public var accessGroup: String {
        get {
            return self.strongDict[kSecAttrAccessGroup] as! String
        }
        set {
            self.strongDict[kSecAttrAccessGroup] = newValue
            self.selectDict[kSecAttrAccessGroup] = newValue
        }
    }
    
    public var accessible: String {
        get {
            return self.strongDict[kSecAttrAccessible] as! String
        }
        set {
            self.strongDict[kSecAttrAccessible] = newValue
            self.weakDict[kSecAttrAccessible] = newValue
        }
    }
    
    public var label: String? {
        get {
            return self.strongDict[kSecAttrLabel] as? String
        }
        set {
            self.strongDict[kSecAttrLabel] = newValue
            self.weakDict[kSecAttrLabel] = newValue
        }
    }
    
}

// 存储kSecClassGenericPassword(一般密码)数据
extension YJSecKeychainItem: YJSecKItemGenericPasswordAttribute {
    
    public var account: String! {
        get {
            return self.strongDict[kSecAttrAccount] as? String
        }
        set {
            self.strongDict[kSecAttrAccount] = newValue
            self.selectDict[kSecAttrAccount] = newValue
        }
    }
    
    public var createDate: Date! {
        return self.strongDict[kSecAttrCreationDate] as? Date
    }
    
    public var modifyDate: Date! {
        return self.strongDict[kSecAttrModificationDate] as? Date
    }
    
    public var desc: String? {
        get {
            return self.strongDict[kSecAttrDescription] as? String
        }
        set {
            self.strongDict[kSecAttrDescription] = newValue
            self.weakDict[kSecAttrDescription] = newValue
        }
    }
    
    public var comment: String? {
        get {
            return self.strongDict[kSecAttrDescription] as? String
        }
        set {
            self.strongDict[kSecAttrDescription] = newValue
            self.weakDict[kSecAttrDescription] = newValue
        }
    }
    
    public var creator: Int {
        get {
            return self.strongDict[kSecAttrCreator] as? Int ?? 0
        }
        set {
            self.strongDict[kSecAttrCreator] = newValue
            self.weakDict[kSecAttrCreator] = newValue
        }
    }
    
    public var type: Int {
        get {
            return self.strongDict[kSecAttrType] as? Int ?? 0
        }
        set {
            self.strongDict[kSecAttrType] = newValue
            self.weakDict[kSecAttrType] = newValue
        }
    }
    
    public var isInvisible: Bool {
        get {
            return self.strongDict[kSecAttrIsInvisible] as? Bool ?? false
        }
        set {
            self.strongDict[kSecAttrIsInvisible] = newValue
            self.weakDict[kSecAttrIsInvisible] = newValue
        }
    }
    
    public var isNegative: Bool {
        get {
            return self.strongDict[kSecAttrIsNegative] as? Bool ?? false
        }
        set {
            self.strongDict[kSecAttrIsNegative] = newValue
            self.weakDict[kSecAttrIsNegative] = newValue
        }
    }
    
    public var service: String? {
        get {
            return self.strongDict[kSecAttrService] as? String
        }
        set {
            self.strongDict[kSecAttrService] = newValue
            self.weakDict[kSecAttrService] = newValue
        }
    }
    
    public var generic: Data? {
        get {
            return self.strongDict[kSecAttrGeneric] as? Data
        }
        set {
            self.strongDict[kSecAttrGeneric] = newValue
            self.weakDict[kSecAttrGeneric] = newValue
        }
    }
    
}
