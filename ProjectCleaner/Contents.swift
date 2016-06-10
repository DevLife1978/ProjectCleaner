//
//  Contents.swift
//  ProjectCleaner
//
//  Created by jayios on 2016. 6. 10..
//  Copyright © 2016년 gomios. All rights reserved.
//

import Foundation


let NRM =  "\u{001B}[0m"
let RED = "\u{001B}[31m"
let GRN = "\u{001B}[32m"
let YEL = "\u{001B}[33m"
let BLU = "\u{001B}[34m"
let MAG = "\u{001B}[35m"
let CYN = "\u{001B}[36m"
let WHT = "\u{001B}[37m"

extension String {
    func fullPath() -> String {
        return NSURL(fileURLWithPath: self).path ?? self
    }
}

func C<S where S: CustomStringConvertible>(contents: S, c: String = NRM) -> String {
    return "\(c)\(contents.description)\(NRM)"
}

func C(contents: String, c: String = NRM) -> String {
    return "\(c)\(contents)\(NRM)"
}

protocol IsaProtocol {
    var isa: String {get}
}

extension IsaProtocol {
    var isa: String {return ""}
}
struct Isa: IsaProtocol {
    let isa: String
    static let GroupIsa = Isa(isa: "PBXGroup")
    static let FileReferenceIsa = Isa(isa: "PBXFileReference")
}

protocol ItemProtocol {
    var isa: Isa {get}
    var name: String {get}
    var path: String {get}
}

extension ItemProtocol {
    
    var name: String {return ""}
    var path: String {return ""}
}

struct Item: ItemProtocol {
    let isa: Isa
    let name: String
    let path: String
}

protocol ChildrenProtocol {
    var children: [String] {get}
}
extension ChildrenProtocol {
    var children: [String] {return [String]()}
}
struct Group: ItemProtocol, ChildrenProtocol {
    let children: [String]
    let isa: Isa = Isa.GroupIsa
    let name: String
    let path: String
}


protocol FileListProtocol {
    var path: String {get}
    var files: [String] {get}
}

struct FileList: FileListProtocol {
    let path: String
    let files: [String]
    init(path aPath: String = NSFileManager.defaultManager().currentDirectoryPath) {
        path = aPath
        guard let enumerator = NSFileManager.defaultManager().enumeratorAtURL(NSURL(fileURLWithPath: path), includingPropertiesForKeys: [NSURLIsDirectoryKey], options: [], errorHandler: nil) else {
            self.files = [String]()
            return
        }
        let files: [String] = enumerator.enumerate().flatMap { (index, element) -> String? in
            guard let file = element as? NSURL else {
                return nil
            }
            guard let attr = try? NSFileManager.defaultManager().attributesOfItemAtPath(file.path!) else {
                return nil
            }
            if attr[NSFileType]?.isEqual(NSFileTypeDirectory) ?? false {
                return nil
            }
            if file.path?.containsString(".framework") ?? false {
                return nil
            }
            if file.path?.containsString("/Build/") ?? false {
                return nil
            }
            switch file.pathExtension ?? "" {
            case "m", "h":
                return file.path
            default:
                return nil
            }
        }
        self.files = files
    }
}

struct FileReference: ItemProtocol {
    let isa: Isa = Isa.FileReferenceIsa
    let path: String
    let name: String
}

func ~=<I: IsaProtocol>(matcher: I, item: NSDictionary) -> Bool {
    guard let isa = item["isa"] as? String else {
        return false
    }
    return matcher.isa == isa
}