import XCTest
@testable import IRobit

class IRobitTests: XCTestCase {
    func testCreateRobitBrain() {
        let brain = RobitBrain()
        XCTAssertNotNil(brain, "Could not create RobitBrain")
        XCTAssertEqual(brain.goal, .idle)
    }
    
    func testCMDFaceDirectionRobitFaceDirection() {
        /// Given:
        let brain = RobitBrain()
        
        /// When:
        brain.commandInput.send(.faceNorth)
        
        /// Then:
        XCTAssertEqual(brain.goal, .face(angle: 0.0))
    }
    
    func testGoalFaceNorthMotorOutput() {
        /// Given:
        let brain = RobitBrain()
        brain.goal = .face(angle: 0.0)
        
        /// When:
        brain.sensorInput.send(SensorInput(pitch: 0.0, yaw: 0.0, roll: -1.5))
        
        /// Then:
        XCTAssertEqual(brain.movementOutput, RobitMovementOutput.RIGHT)
    }
    
    func testGoalFaceSouthMotorOutput() {
        /// Given:
        let brain = RobitBrain()
        brain.goal = .face(angle: -3.1)
        
        /// When:
        brain.sensorInput.send(SensorInput(pitch: 0.0, yaw: 0.0, roll: 0.0))
        
        /// Then:
        XCTAssertEqual(brain.movementOutput, RobitMovementOutput.LEFT)
    }
    
    func testStopsOnReachGoal() {
        /// Given:
        let brain = RobitBrain()
        brain.goal = .face(angle: 0.0)
        
        /// When:
        brain.sensorInput.send(SensorInput(pitch: 0.0, yaw: 0.0, roll: 0.0))
        
        ///Then:
        XCTAssertEqual(brain.movementOutput, RobitMovementOutput(motor1Speed: 0.0, motor2Speed: 0.0))
        XCTAssertEqual(brain.goal, .idle)
    }
}
