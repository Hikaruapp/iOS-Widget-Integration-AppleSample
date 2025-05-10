//
//  LampControlWidgetsBundle.swift
//  LampControlWidgets
//

import WidgetKit
import SwiftUI

@main
struct LampControlWidgetsBundle: WidgetBundle {
    var body: some Widget {
        LampControlWidgets()
        LampControlWidgetsControl()
        LampControlWidgetsLiveActivity()
    }
}
