//
//  ErrorCell.swift
//  SpaceX
//
//  Created by Rolando Rodriguez on 5/21/22.
//

import Foundation
import SwiftUI

struct ErrorCell: View {
    let message: String
    let onButtonTap: () -> ()
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "exclamationmark.triangle")
                .font(.title)
                .foregroundColor(.accentColor)
            
            Text("Error")
                .bold()
            Text(message)
            
            Button {
                onButtonTap()
            } label: {
                Text("Try Again")
            }
        }
    }
}

struct ErrorCell_Previews: PreviewProvider {
    static var previews: some View {
        ErrorCell(message: "Simulated failure for debugging") {
            
        }
    }
}
