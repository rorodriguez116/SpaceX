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
    
    private func detailRow(label: String, value: String, bold: Bool = false) -> some View {
        HStack {
            Text(label)
            
            Spacer()
            
            if bold {
                Text(value)
                    .fontWeight(.bold)
            } else {
                Text(value)
                    .multilineTextAlignment(.trailing)
                      .font(.system(size: 16))
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .top, spacing: 30) {
                HStack(alignment: .top) {
                    KFImage(model.missionImageUrl)
                        .resizable()
                        .frame(width: 45, height: 45, alignment: .center)
                    
                    VStack(alignment: .leading, spacing: 4.5) {
                        detailRow(label: "Mission:", value: model.missionName, bold: true)
                        detailRow(label: "Date/time:", value: model.dateTime)
                        detailRow(label: "Rocket:", value: model.rocketInfo)
                        detailRow(label: model.daysLabel, value: model.daysDiffString)
                    }
                }
                
                Group {
                    if model.status == .undetermined {
                        Rectangle()
                            .foregroundColor(Color(.systemBackground))
                    } else {
                        Image(systemName: model.status == .success ? "checkmark" : "xmark")
                    }
                }
                .frame(width: 16, height: 16, alignment: .center)
                .padding(.top, 4)
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
        LaunchCellView(model: LaunchCellViewModel(launch: Launch.previewLaunch, date: "20/11/20", time: "21:30"))
    }
}
