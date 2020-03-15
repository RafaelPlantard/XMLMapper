//
//  XMLRepresentable.swift
//  XMLMapper
//
//  Created by Giorgos Charitakis on 14/09/2017.
//
//

import Foundation

protocol XMLRepresentable {
    var xmlString: String { get }
}

extension Dictionary: XMLRepresentable { }

extension Array: XMLRepresentable {
    var xmlString: String {
        guard let dictionaryArray = self as? [[String: Any]] else {
            return ""
        }
        return dictionaryArray.map({ $0.xmlString }).joined()
    }
}

extension NSDictionary: XMLRepresentable {
    var xmlString: String {
        #if os(Linux)
        return linuxDictionary.xmlString
        #else
        return (self as Dictionary).xmlString
        #endif
    }

    #if os(Linux)
    var linuxDictionary: Dictionary<String, Any> {
        var dictionary = Dictionary<String, Any>()

        allKeys.forEach { key in
            if let key = key as? String, let value = value(forKey: key) {
                dictionary[key] = value
            }
        }

        return dictionary
    }
    #endif
}

extension NSArray: XMLRepresentable {
    var xmlString: String {
        return (self as Array).xmlString
    }
}
