//
//  Parser.swift
//  ProjectCleaner
//
//  Created by jayios on 2016. 6. 10..
//  Copyright © 2016년 gomios. All rights reserved.
//

import Foundation

func parseProj(path: String) -> [ItemProtocol] {
    var items = [ItemProtocol]()
    NSFileManager.defaultManager()
    guard let plist = NSDictionary(contentsOfFile: path) else {
        print("couldn't load \(path)")
        return [ItemProtocol]()
    }
    let objects = plist["objects"] as! NSDictionary
    let groups = objects.flatMap { (key, value) -> Group? in
        guard let dic = value as? NSDictionary else {
            return nil
        }
        switch dic {
        case Isa.GroupIsa:
            guard let name = dic["name"] as? String else {
                return nil
            }
            let children = dic["children"] as? [String] ?? [String]()
            let path = dic["path"] as? String ?? ""
            return Group(children: children, name: name, path: path)
        default:
            return nil
        }
    }
    print("<Groups>")
    for group in groups {
        print("\t\(C(group.name, c: RED)) has \(C(group.children.count, c: YEL)) children -> \(C(group.path.fullPath(), c: BLU))")
        items.append(group)
    }
    print("</Groups>")
    
    //MARK: Check for groups has no children
    let noChildren: [Group] = groups.filter { (group) -> Bool in
        return 0 == group.children.count
    }
    for noChild in noChildren {
        print("\(noChild.name) has no children")
    }
    print("<References>")
    let usingReferences = objects.flatMap { (key, value) -> FileReference? in
        guard let dic = value as? NSDictionary else {
            return nil
        }
        let path = dic["path"] as? String ?? ""
        guard let name = path.componentsSeparatedByString("/").last else {
            return nil
        }
        if 0 < name.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) {
            return FileReference(path: path, name: name)
        }
        return nil
    }
    let usingReferencesNames = usingReferences.flatMap { (ref) -> String? in
        return ref.name
    }
    let fileList = FileList()
    for file in fileList.files {
        let isUsing = usingReferencesNames.contains(file.componentsSeparatedByString("/").last!)
        if false == isUsing {
            print("\(file) is \(isUsing ? "using" : C("not using", c: RED))")
            if Process.arguments.last == "-d" {
                try? NSFileManager.defaultManager().removeItemAtPath(file)
            }
        }
    }
    print("</References>")
    
//    print(File(path: NSFileManager.defaultManager().currentDirectoryPath))
    
    return items
}