import Foundation

struct GoalSequence {
    let goals: [RobitGoal]
    var index: Int
    let repeating: Bool
    
    func nextGoal() -> RobitGoal {
        return goals[index]
    }
}
