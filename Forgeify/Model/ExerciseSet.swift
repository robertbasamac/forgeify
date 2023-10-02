//
//  Set.swift
//  Forgeify
//
//  Created by Robert Basamac on 28.09.2023.
//

import Foundation

struct ExerciseSet: Identifiable, Codable {
    var id: UUID
    var weight: Int
    var reps: Int
    var rest: Int
    
    init(id: UUID = .init(), weight: Int, reps: Int, rest: Int) {
        self.id = id
        self.weight = weight
        self.reps = reps
        self.rest = rest
    }
}

extension ExerciseSet: Hashable {
    static func == (lhs: ExerciseSet, rhs: ExerciseSet) -> Bool {
        lhs.weight == rhs.weight && lhs.reps == rhs.reps && lhs.rest == rhs.rest
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(weight)
        hasher.combine(reps)
        hasher.combine(rest)
    }
}

extension ExerciseSet {
    static var previewExercises: [ExerciseSet] {
        [
            ExerciseSet(weight: 10, reps: 12, rest: 60),
            ExerciseSet(weight: 15, reps: 10, rest: 60),
            ExerciseSet(weight: 20, reps: 8, rest: 60)
        ]
    }
    
    static var previewExercise: ExerciseSet {
        ExerciseSet(weight: 10, reps: 12, rest: 60)
    }
}
