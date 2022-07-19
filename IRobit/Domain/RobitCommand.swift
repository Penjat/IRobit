import Foundation

enum RobitCommand {
    case stop
    case faceNorth
    case faceEast
    case faceSouth
    case faceWest
    case sequence(goals: [RobitGoal])
}
