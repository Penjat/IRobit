import Foundation

struct GoalSequence {
    let goals: [RobitGoal]
    var index: Int
    
    func nextGoal() -> RobitGoal {
        return goals[index]
    }
}
