//
//  BlackSelectCapsuleButton.swift
//  Sprayd
//
//  Created by loxxy on 03.04.2026.
//

import SwiftUI

struct BlackSelectCapsuleButton: View {
    // MARK: - Const
    private enum Const {
        // UI Constraint properties
        static let height: CGFloat = 30
        
        // Fonts
        static let textFont: Font = .InstrumentMedium13
    }
    
    let title: String
    let iconName: String?
    let action: (() -> Void)
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Metrics.oneAndHalfModule) {
                Text(title)
                    .font(Const.textFont)
                    .foregroundStyle(Color.white)
                
                if let iconName {
                    Image(iconName)
                        .renderingMode(.template)
                        .foregroundStyle(Color.white)
                }
            }
            .padding(.horizontal, Metrics.oneAndHalfModule)
            .frame(height: Const.height)
            .background(Color.black)
            .clipShape(Capsule())
        }
    }
}

//#Preview {
//    BlackSelectCapsuleButton(title: "Title", iconName: "rightArrowIcon")
//}
