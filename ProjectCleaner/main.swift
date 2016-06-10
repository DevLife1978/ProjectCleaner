//
//  main.swift
//  ProjectCleaner
//
//  Created by jayios on 2016. 6. 10..
//  Copyright © 2016년 gomios. All rights reserved.
//

import Foundation

let path = NSFileManager.defaultManager().currentDirectoryPath

do {
    let contents = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(path)
    for file in contents {
        if file.hasSuffix("xcodeproj") {
            parseProj("\(path)/\(file)/project.pbxproj")
        }
    }
} catch let err as NSError {
    print(err)
}