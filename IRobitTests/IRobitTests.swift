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
    
    func testCMDFaceDirectionRobitFaceDirection() {
        /// Given:
        let brain = RobitBrain()
        
        /// When:
        brain.commandInput.send(.faceNorth)
        
        /// Then:
        brain.goal = .face(angle: 0.0)
    }
}
