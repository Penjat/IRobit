import Foundation

enum RobitGoal: Equatable {
    case idle
    case face(angle: Double)
    case wait(relativeTime: Double, specificTime: Double?)
    case driveFor(relativeTime: Double, specificTime: Double?)
}
