//
//  IRobitTests.swift
//  IRobitTests
//
//  Created by Spencer Symington on 2022-07-17.
//

import XCTest
@testable import IRobit

class IRobitTests: XCTestCase {
    func testCreateRobitBrain() {
        let brain = RobitBrain()
        XCTAssertNotNil(brain, "Could not create RobitBrain")
    }
    
    
}
