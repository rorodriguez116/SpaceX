//
//  WebView.swift
//  SpaceX
//
//  Created by Rolando Rodriguez on 5/20/22.
//

import SwiftUI
import WebKit

struct WebView: View {
    struct _WebView: UIViewRepresentable {
        var content: WebContentModel
     
        func makeUIView(context: Context) -> WKWebView {
            return WKWebView()
        }
     
        func updateUIView(_ webView: WKWebView, context: Context) {
            let url: URL
            
            switch content {
            case .page(url: let _url):
                url = _url
            case .video(youtubeId: let id):
                guard let _url = URL(string: "https://www.youtube.com/embed/\(id)") else { return }
                url = _url
                webView.scrollView.isScrollEnabled = false
            }
            
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

    
    @Environment(\.presentationMode) var presentationMode
    
    let content: WebContentModel
    
    var body: some View {
        NavigationView {
            _WebView(content: content)
                .navigationBarTitle(Text("SpaceX"), displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    withAnimation {
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Done")
                        .bold()
                })
        }
        .colorScheme(.dark)
    }
}


struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView(content: .video(youtubeId: "v0w9p3U8860"))
    }
}
