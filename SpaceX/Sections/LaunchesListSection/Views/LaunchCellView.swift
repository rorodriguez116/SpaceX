//
//  LaunchCellView.swift
//  SpaceX
//
//  Created by Rolando Rodriguez on 5/20/22.
//

import Kingfisher
import SwiftUI

struct LaunchCellView: View {
    @State private var isPresentingConfirm: Bool = false
    @State private var webContent: WebContentModel?
    
    let model: LaunchCellViewModel
    
    func detailRow(label: String, value: String, bold: Bool = false) -> some View {
        HStack {
            if bold {
                Text(label)
                    .bold()
            } else {
                Text(label)
            }
            
            Spacer()
            
            Text(value)
                .font(.system(size: 16))
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(alignment: .center) {
                KFImage(model.missionImageUrl)
                    .resizable()
                    .frame(width: 45, height: 45, alignment: .center)
                
                VStack(spacing: 4.5) {
                    detailRow(label: "Mission:", value: model.missionName, bold: true)
                    detailRow(label: "Date / time:", value: model.dateTime)
                    detailRow(label: "Rocket:", value: model.rocketInfo)
                    detailRow(label: model.daysLabel, value: model.daysDiffString)
                }
                
                Image(systemName: model.status == .undetermined ? "questionmark" : model.status == .success ? "checkmark" : "xmark.circle")
                    .frame(width: 12, height: 12, alignment: .center)
                
                Circle()
                    .foregroundColor(model.status == .undetermined ? .clear : model.status == .success ? .green : .red)
                    .frame(width: 6, height: 6, alignment: .center)
            }
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.white.opacity(0.3))
        }
        .onTapGesture {
            isPresentingConfirm = true
        }
        .confirmationDialog("Mission \(model.missionName)", isPresented: $isPresentingConfirm) {
            if let id = model.youtubeId {
                Button("Watch Video", role: .none) {
                    webContent = .video(youtubeId: id)
                }
            }
            
            if let url = model.articleUrl {
                Button("Open Article", role: .none) {
                    webContent = .page(url: url)
                }
            }
            
            if let url = model.wikipediaUrl {
                Button("Wikipedia", role: .none) {
                    webContent = .page(url: url)
                }
            }
        }
        .sheet(item: $webContent) { content in
            WebView(content: content)
        }
    }
}

struct LaunchCellView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchCellView(model: LaunchCellViewModel(launch: Mock.launches.first!, date: "20/11/20", time: "21:30"))
    }
}
