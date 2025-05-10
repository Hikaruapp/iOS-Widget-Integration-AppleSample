//  ContentView
//

import SwiftUI
import WidgetKit

/// ContentView: 本体アプリのメイン UI
/// ・ランプの ON/OFF トグルを表示し、状態を切り替え
/// ・シーンフェーズ変化を検知して状態を再読み込み
struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var lampState = LampState()

    var body: some View {
        VStack(spacing: 20) {
            Toggle("ランプ ON/OFF", isOn: $lampState.isOn)
                .padding()

            Circle()
                .fill(lampState.isOn ? Color.yellow : Color.gray)
                .frame(width: 100, height: 100)
                .padding()

            Text(lampState.isOn ? "ランプ ON" : "ランプ OFF")
                .font(.title)
                .padding()

            Button("強制リロード") {
                // ホーム画面およびロック画面のウィジェットを再読み込み
                WidgetCenter.shared.reloadAllTimelines()
                // Control Center 上のすべてのコントロールを再読み込み
                ControlCenter.shared.reloadAllControls()
                // ロック画面のControlWidgetを再読み込み
                ControlCenter.shared.reloadControls(ofKind: "com.hikaruapp.LampControlSample.LampControlWidgets")
            }
            .padding(.top, 10)
        }
        .padding()
        .onChange(of: scenePhase) {
            switch scenePhase {
            case .inactive:
                // Control Center displayed or interruption occurred
                print("App moved to inactive")
            case .active:
                // Returned to foreground or Control Center dismissed
                print("App moved to active")
                lampState.isOn = TimerStatusDefaults.isRunning("Timer")
            case .background:
                // Moved to background
                print("App moved to background")
            @unknown default:
                break
            }
        }
    }
}

/// アプリとウィジェットで共有するランプの ON/OFF 状態を管理
final class LampState: ObservableObject {
    @Published var isOn: Bool {
        didSet {
            // UserDefaults に保存
            TimerStatusDefaults.update("Timer", running: isOn)
        }
    }

    init() {
        // 起動時に保存値を読み込む
        self.isOn = TimerStatusDefaults.isRunning("Timer")
    }
}
