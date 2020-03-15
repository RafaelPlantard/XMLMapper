//
//  NSMutableDictionary+XMLParser.swift
//  XMLMapper
//
//  Created by Giorgos Charitakis on 19/10/2017.
//

import Foundation

extension NSMutableDictionary {
    var attributes: [String: String]? {
        #if os(Linux)
        return linuxDictionary.attributes
        #else
        return (self as Dictionary).attributes
        #endif
    }
    
    var childNodes: [String: Any]? {
        #if os(Linux)
        return linuxDictionary.childNodes
        #else
        return (self as Dictionary).childNodes
        #endif
    }
    
    var comments: [String]? {
        #if os(Linux)
        return linuxDictionary.comments
        #else
        return (self as Dictionary).comments
        #endif
    }
    
    var innerText: String? {
        #if os(Linux)
        return linuxDictionary.innerText
        #else
        return (self as Dictionary).innerText
        #endif
    }
}
