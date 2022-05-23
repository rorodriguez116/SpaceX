//
//  MultiYearSelectorView.swift
//  SpaceX
//
//  Created by Rolando Rodriguez on 5/20/22.
//

import SwiftUI

struct MultiYearSelectorView: View {
    var years: [Int]
    
    @Binding var selectedYears: [Int]
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        return formatter
    }()
    
    var body: some View {
        VStack {
            Button {
                withAnimation {
                    selectedYears.removeAll()
                }
            } label : {
                if selectedYears.isEmpty {
                    Label("All", systemImage: "checkmark")
                } else {
                    Text("All")
                }
            }
            .accessibilityIdentifier("allYearsButton")
            
            ForEach(years, id: \.self) { year in
                Button {
                    withAnimation {
                        if selectedYears.contains(year) {
                            selectedYears.removeAll { $0 == year }
                        } else {
                            self.selectedYears.append(year)
                        }
                    }
                } label: {
                    HStack {
                        if selectedYears.contains(year) {
                            Label(numberFormatter.string(from: NSNumber(value: year)) ?? "", systemImage: "checkmark")
                        } else {
                            Text(numberFormatter.string(from: NSNumber(value: year)) ?? "")
                        }
                    }
                }
                .id(year)
            }
        }
    }
}

struct MultiYearSelectorView_Previews: PreviewProvider {
    struct MultiYearSelectorView_Wrapper: View {
        @State private var selectedYears = [Int]()
        
        var body: some View {
            MultiYearSelectorView(years: Array(2001..<2020), selectedYears: $selectedYears)
        }
    }
    
    static var previews: some View {
        MultiYearSelectorView_Wrapper()
    }
}
