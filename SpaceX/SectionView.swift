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
            Rectangle()
                .foregroundColor(.gray)
                .frame(height: 40)
                .overlay(
                    Text(title)
                        .bold()
                        .padding(.leading, 16)
                    ,alignment: .leading)
            
            content()
                .padding(.horizontal, 16)
            
        }
    }
    
    init(title: String, @ViewBuilder contents:  @escaping () -> H) {
        self.title = title
        self.content = contents
    }
}
