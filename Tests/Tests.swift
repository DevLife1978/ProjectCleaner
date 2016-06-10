//
//  Tests.swift
//  Tests
//
//  Created by jayios on 2016. 6. 10..
//  Copyright © 2016년 gomios. All rights reserved.
//

import XCTest

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let path = NSBundle(forClass: Tests.self).pathForResource("project", ofType: "pbxproj")
        

        let groups = parseProj(path!)
        XCTAssert(0 < groups.count)
        
        let groupNames: [String] = groups.flatMap { (item) -> String? in
            return item.name
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
