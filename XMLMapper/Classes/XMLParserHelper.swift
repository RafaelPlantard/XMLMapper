//
//  XMLParserHelper.swift
//  XMLMapper
//
//  Created by Giorgos Charitakis on 19/10/2017.
//

import Foundation

class XMLParserHelper {
    class func xmlString(forNode node: Any, withNodeName nodeName: String) -> String? {
        if let nodeArray = node as? [Any] {
            let nodes = nodeArray.compactMap({ xmlString(forNode: $0, withNodeName: nodeName) })
            return nodes.joined(separator: "\n")
        } else if let nodeDictionary = node as? [String: Any] {
            var attributeString = ""
            if let attributes = nodeDictionary.attributes {
                #if os(Linux)
                attributeString = attributes.map({ args in
                    var string = ""

                    args.key.xmlEncodedString.withCString { keyXmlEncodedString in
                        args.value.xmlEncodedString.withCString { valueXmlEncodedString in
                            string = String(format: " %@=\"%@\"", keyXmlEncodedString, valueXmlEncodedString)
                        }
                    }

                    return string
                }).joined()
                #else
                attributeString = attributes.map({ String(format: " %@=\"%@\"", $0.key.xmlEncodedString, $0.value.xmlEncodedString) }).joined()
                #endif
            }
            let innerXML = nodeDictionary.innerXML
            if !innerXML.isEmpty {
                #if os(Linux)
                var string = ""

                nodeName.withCString { nodeName in
                    attributeString.withCString { attributeString in
                        innerXML.withCString { innerXML in
                            string = String(format: "<%1$@%2$@>%3$@</%1$@>", nodeName, attributeString, innerXML)
                        }
                    }
                }

                return string
                #else
                return String(format: "<%1$@%2$@>%3$@</%1$@>", nodeName, attributeString, innerXML)
                #endif
            } else {
                #if os(Linux)
                var string = ""

                nodeName.withCString { nodeName in
                    attributeString.withCString { attributeString in
                        string = String(format: "<%@%@/>", nodeName, attributeString)
                    }
                }

                return string
                #else
                return String(format: "<%@%@/>", nodeName, attributeString)
                #endif
            }
        } else if let nodeString = node as? String {
            #if os(Linux)
            var string = ""

            nodeName.withCString { nodeName in
                nodeString.xmlEncodedString.withCString { xmlEncodedString in
                    string = String(format: "<%1$@>%2$@</%1$@>", nodeName, xmlEncodedString)
                }
            }

            return string
            #else
            return String(format: "<%1$@>%2$@</%1$@>", nodeName, nodeString.xmlEncodedString)
            #endif
        }
        return nil
    }
    
    class func name(forNode node: [String: Any]?, inDictionary dict: [String: Any]?) -> String? {
        if let nodeName = node?.nodeName {
            return nodeName
        } else if let node = node {
            return dict?.keys.filter({ (key: String) -> Bool in
                let object = dict?[key]
                if let objectDictionary = object as? [String: Any], objectDictionary == node {
                    return true
                } else if let objectArray = object as? [[String: Any]] {
                    return objectArray.contains(where: { $0 == node })
                }
                return false
            }).first
        }
        return nil
    }
}
