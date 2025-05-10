//
//  LampControlWidgetsControl.swift
//  LampControlWidgets
//

import AppIntents
import SwiftUI
import WidgetKit

struct LampControlWidgetsControl: ControlWidget {
    static let kind: String = "com.hikaruapp.LampControlSample.LampControlWidgets"

    var body: some ControlWidgetConfiguration {
        AppIntentControlConfiguration(
            kind: Self.kind,
            provider: Provider()
        ) { value in
            ControlWidgetToggle(
                "Start Timer",
                isOn: value.isRunning,
                action: StartTimerIntent(value.name, value: !value.isRunning)
            ) { isRunning in
                Label(isRunning ? "On" : "Off", systemImage: "timer")
            }
        }
        .displayName("Timer")
        .description("An example control that runs a timer.")
    }
}

extension LampControlWidgetsControl {
    struct Value {
        var isRunning: Bool
        var name: String
    }

    struct Provider: AppIntentControlValueProvider {
        func previewValue(configuration: TimerConfiguration) -> Value {
            LampControlWidgetsControl.Value(isRunning: false, name: configuration.timerName)
        }

        func currentValue(configuration: TimerConfiguration) async throws -> Value {
            let running = TimerStatusDefaults.isRunning(configuration.timerName)
            return LampControlWidgetsControl.Value(isRunning: running, name: configuration.timerName)
        }
    }
}

struct TimerConfiguration: ControlConfigurationIntent {
    static let title: LocalizedStringResource = "Timer Name Configuration"

    @Parameter(title: "Timer Name", default: "Timer")
    var timerName: String
}

struct StartTimerIntent: SetValueIntent {
    static let title: LocalizedStringResource = "Start a timer"

    @Parameter(title: "Timer Name")
    var name: String

    @Parameter(title: "Timer is running")
    var value: Bool

    init() {}

    init(_ name: String, value: Bool) {
        self.name = name
        self.value = value
    }

    func perform() async throws -> some IntentResult {
        TimerStatusDefaults.update(name, running: value)
        return .result()
    }
}

