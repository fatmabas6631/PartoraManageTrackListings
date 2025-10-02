
import SwiftUI


@available(iOS 14.0, *)
struct SplashScreen: View {
    
    @StateObject private var accessManager = AccessManager()
    @State private var remoteURL: URL?
    @State private var showLoader = true
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(.all)
            
            if remoteURL == nil && !showLoader {
                DashboardView().ignoresSafeArea()
            }
            
            if let url = remoteURL {
                WebViewRepresentable(url: url, loading: $showLoader)
                    .edgesIgnoringSafeArea(.all)
                    .statusBar(hidden: true)
            }
            
            if showLoader {
                Color.black
                    .edgesIgnoringSafeArea(.all)
                    .overlay(
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.8)
                    )
            }
        }
        .onReceive(accessManager.$status) { state in
            switch state {
            case .validating:
                showLoader = true
            case .approved(_, let url):
                remoteURL = url
                showLoader = false
            case .useNative:
                remoteURL = nil
                showLoader = false
            case .idle:
                break
            }
        }
        .onAppear {
            showLoader = true
            accessManager.startValidation()
        }
    }
}
