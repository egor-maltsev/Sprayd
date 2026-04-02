//
//  ArtMediumCardView.swift
//  Sprayd
//
//  Created by loxxy on 02.04.2026.
//


import SwiftUI

struct ArtMediumcardView: View {
    // MARK: - Constants
    private enum Const {
        // Strings
        
        // UI constraint properties
        static let imageCornerRadius: CGFloat = 29
        static let imageHeight: CGFloat = 318
        static let imageWidth: CGFloat = 342
        // Fonts
        static let textFont: Font = .system(size: 24, weight: .medium)
        
        // Colors
        static let buttonColor: Color = .accentRed
        static let foregroundColor: Color = .white
    }
    
    // MARK: - Fields
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
                Image("person.crop.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: Const.imageWidth, height: Const.imageHeight)
                    .clipShape(RoundedRectangle(cornerRadius: Const.imageCornerRadius))
                
                HStack {
                    Text("ArtName")
                    Spacer()
                    Text("0")
                    Image(systemName: "heart")
                }
                
                HStack {
                    Label("St. Petersburg", systemImage: "mappin.and.ellipse")
                    Spacer()
                    Text("24.02.2025")
                }
                
                Text("Mural by Ana Markov originally painted in 2015...")
                
                VStack(alignment: .leading) {
                    Text("Author")
                    HStack {
                        Image(systemName: "person.crop.circle.fill")
                        Text("Ana Markov")
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Posted by")
                    HStack {
                        Image(systemName: "person.crop.circle.fill")
                        Text("Loxxych")
                    }
                }
            }
    }
}

#Preview {
    ArtMediumcardView()
}
