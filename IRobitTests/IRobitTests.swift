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
        var lastOutput: RobitMovementOutput?
        
        let _ = brain.$movementOutput.sink { output in
            lastOutput = output
        }
        
        /// When:
        brain.commandInput.send(.faceNorth)
        
        /// Then:
//        XCTAssertEqual(lastOutput, RobitMovementOutput(motor1Speed: 1, motor2Speed: <#T##Double#>))
        
    }
}
