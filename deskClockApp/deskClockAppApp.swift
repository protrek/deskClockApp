//
//  deskClockAppApp.swift
//  deskClockApp
//
//  Created by protrek on 2/25/26.
//

import SwiftUI

// 앱의 메인 엔트리 포인트(예: deskClockApp.swift)에서 ContentView 대신 사용
@main
struct deskClockApp: App {
    var body: some Scene {
        WindowGroup {
            ClockContainerView()
                .edgesIgnoringSafeArea(.all)
        }
    }
}

