//
//  SectionView.swift
//  SpaceX
//
//  Created by Rolando Rodriguez on 5/19/22.
//

import SwiftUI

struct SectionView<H: View>: View {
    let title: String
    let content: () -> H
    
    var body: some View {
        VStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(Color(.tertiarySystemBackground))
                .frame(height: 30)
                .overlay(
                    Text(title)
                        .font(.system(size: 16))
                        .bold()
                        .padding(.leading, 12)
                    ,alignment: .leading)
            
            content()
            
        }
        .padding(.horizontal, 12)
    }
    
    init(title: String, @ViewBuilder contents:  @escaping () -> H) {
        self.title = title
        self.content = contents
    }
}
