//
//  TimerStatusDefaults.swift
//  LampControlSample
//

import Foundation

enum TimerStatusDefaults {
    static let suiteName = "group.com.hikaruapp.test"
    static let key = "isRunning"

    static func update(_ timerName: String, running: Bool) {
        guard let defaults = UserDefaults(suiteName: suiteName) else { return }
        var state = defaults.dictionary(forKey: key) as? [String: Bool] ?? [:]
        state[timerName] = running
        defaults.setValue(state, forKey: key)
    }

    static func isRunning(_ timerName: String) -> Bool {
        guard let defaults = UserDefaults(suiteName: suiteName),
              let state = defaults.dictionary(forKey: key) as? [String: Bool] else {
            return false
        }
        return state[timerName] ?? false
    }
}
