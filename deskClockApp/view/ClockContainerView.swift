//
//  ClockContainerView.swift
//  deskClockApp
//
//  Created by protrek on 2/25/26.
//

import SwiftUI

struct ClockContainerView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ClockViewController {
        return ClockViewController()
    }
    
    func updateUIViewController(_ uiViewController: ClockViewController, context: Context) {
        // 업데이트 로직이 필요할 때 사용
    }
}

