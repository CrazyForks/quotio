//
//  LanguageManager.swift
//  Quotio
//

import SwiftUI

enum AppLanguage: String, CaseIterable, Identifiable {
    case english = "en"
    case vietnamese = "vi"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .english: return "English"
        case .vietnamese: return "Tiếng Việt"
        }
    }
    
    var flag: String {
        switch self {
        case .english: return "🇺🇸"
        case .vietnamese: return "🇻🇳"
        }
    }
}

@MainActor
@Observable
final class LanguageManager {
    static let shared = LanguageManager()
    
    var currentLanguage: AppLanguage {
        didSet {
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: "appLanguage")
        }
    }
    
    private init() {
        let saved = UserDefaults.standard.string(forKey: "appLanguage") ?? "en"
        self.currentLanguage = AppLanguage(rawValue: saved) ?? .english
    }
    
    func localized(_ key: String) -> String {
        return LocalizedStrings.get(key, language: currentLanguage)
    }
}

struct LocalizedStrings {
    private static let strings: [String: [AppLanguage: String]] = [
        // Navigation
        "nav.dashboard": [.english: "Dashboard", .vietnamese: "Bảng điều khiển"],
        "nav.quota": [.english: "Quota", .vietnamese: "Hạn mức"],
        "nav.providers": [.english: "Providers", .vietnamese: "Nhà cung cấp"],
        "nav.apiKeys": [.english: "API Keys", .vietnamese: "Khóa API"],
        "nav.logs": [.english: "Logs", .vietnamese: "Nhật ký"],
        "nav.settings": [.english: "Settings", .vietnamese: "Cài đặt"],
        
        // Status
        "status.running": [.english: "Running", .vietnamese: "Đang chạy"],
        "status.stopped": [.english: "Stopped", .vietnamese: "Đã dừng"],
        "status.ready": [.english: "Ready", .vietnamese: "Sẵn sàng"],
        "status.cooling": [.english: "Cooling", .vietnamese: "Đang nghỉ"],
        "status.error": [.english: "Error", .vietnamese: "Lỗi"],
        "status.available": [.english: "Available", .vietnamese: "Khả dụng"],
        "status.forbidden": [.english: "Forbidden", .vietnamese: "Bị chặn"],
        
        // Dashboard
        "dashboard.accounts": [.english: "Accounts", .vietnamese: "Tài khoản"],
        "dashboard.ready": [.english: "ready", .vietnamese: "sẵn sàng"],
        "dashboard.requests": [.english: "Requests", .vietnamese: "Yêu cầu"],
        "dashboard.total": [.english: "total", .vietnamese: "tổng"],
        "dashboard.tokens": [.english: "Tokens", .vietnamese: "Token"],
        "dashboard.processed": [.english: "processed", .vietnamese: "đã xử lý"],
        "dashboard.successRate": [.english: "Success Rate", .vietnamese: "Tỷ lệ thành công"],
        "dashboard.failed": [.english: "failed", .vietnamese: "thất bại"],
        "dashboard.providers": [.english: "Providers", .vietnamese: "Nhà cung cấp"],
        "dashboard.apiEndpoint": [.english: "API Endpoint", .vietnamese: "Điểm cuối API"],
        "dashboard.cliNotInstalled": [.english: "CLIProxyAPI Not Installed", .vietnamese: "CLIProxyAPI chưa cài đặt"],
        "dashboard.clickToInstall": [.english: "Click the button below to automatically download and install", .vietnamese: "Nhấn nút bên dưới để tự động tải và cài đặt"],
        "dashboard.installCLI": [.english: "Install CLIProxyAPI", .vietnamese: "Cài đặt CLIProxyAPI"],
        "dashboard.startToBegin": [.english: "Start the proxy server to begin", .vietnamese: "Khởi động máy chủ proxy để bắt đầu"],
        
        // Quota
        "quota.overallStatus": [.english: "Overall Status", .vietnamese: "Trạng thái chung"],
        "quota.providers": [.english: "providers", .vietnamese: "nhà cung cấp"],
        "quota.accounts": [.english: "accounts", .vietnamese: "tài khoản"],
        "quota.account": [.english: "account", .vietnamese: "tài khoản"],
        "quota.accountsReady": [.english: "accounts ready", .vietnamese: "tài khoản sẵn sàng"],
        "quota.used": [.english: "used", .vietnamese: "đã dùng"],
        "quota.reset": [.english: "reset", .vietnamese: "đặt lại"],
        
        // Providers
        "providers.addProvider": [.english: "Add Provider", .vietnamese: "Thêm nhà cung cấp"],
        "providers.connectedAccounts": [.english: "Connected Accounts", .vietnamese: "Tài khoản đã kết nối"],
        "providers.noAccountsYet": [.english: "No accounts connected yet", .vietnamese: "Chưa có tài khoản nào được kết nối"],
        "providers.startProxyFirst": [.english: "Start the proxy first to manage providers", .vietnamese: "Khởi động proxy trước để quản lý nhà cung cấp"],
        "providers.connect": [.english: "Connect", .vietnamese: "Kết nối"],
        "providers.authenticate": [.english: "Authenticate", .vietnamese: "Xác thực"],
        "providers.cancel": [.english: "Cancel", .vietnamese: "Hủy"],
        "providers.waitingAuth": [.english: "Waiting for authentication...", .vietnamese: "Đang chờ xác thực..."],
        "providers.connectedSuccess": [.english: "Connected successfully!", .vietnamese: "Kết nối thành công!"],
        "providers.authFailed": [.english: "Authentication failed", .vietnamese: "Xác thực thất bại"],
        "providers.projectIdOptional": [.english: "Project ID (optional)", .vietnamese: "ID dự án (tùy chọn)"],
        "providers.disabled": [.english: "Disabled", .vietnamese: "Đã tắt"],
        
        // Settings
        "settings.proxyServer": [.english: "Proxy Server", .vietnamese: "Máy chủ proxy"],
        "settings.port": [.english: "Port", .vietnamese: "Cổng"],
        "settings.endpoint": [.english: "Endpoint", .vietnamese: "Điểm cuối"],
        "settings.status": [.english: "Status", .vietnamese: "Trạng thái"],
        "settings.autoStartProxy": [.english: "Auto-start proxy on launch", .vietnamese: "Tự khởi động proxy khi mở app"],
        "settings.restartProxy": [.english: "Restart proxy after changing port", .vietnamese: "Khởi động lại proxy sau khi đổi cổng"],
        "settings.routingStrategy": [.english: "Routing Strategy", .vietnamese: "Chiến lược định tuyến"],
        "settings.roundRobin": [.english: "Round Robin", .vietnamese: "Xoay vòng"],
        "settings.fillFirst": [.english: "Fill First", .vietnamese: "Dùng hết trước"],
        "settings.roundRobinDesc": [.english: "Distributes requests evenly across all accounts", .vietnamese: "Phân phối yêu cầu đều cho tất cả tài khoản"],
        "settings.fillFirstDesc": [.english: "Uses one account until quota exhausted, then moves to next", .vietnamese: "Dùng một tài khoản đến khi hết hạn mức, rồi chuyển sang tài khoản tiếp"],
        "settings.quotaExceededBehavior": [.english: "Quota Exceeded Behavior", .vietnamese: "Hành vi khi vượt hạn mức"],
        "settings.autoSwitchAccount": [.english: "Auto-switch to another account", .vietnamese: "Tự động chuyển sang tài khoản khác"],
        "settings.autoSwitchPreview": [.english: "Auto-switch to preview model", .vietnamese: "Tự động chuyển sang mô hình xem trước"],
        "settings.quotaExceededHelp": [.english: "When quota is exceeded, automatically try alternative accounts or models", .vietnamese: "Khi vượt hạn mức, tự động thử tài khoản hoặc mô hình khác"],
        "settings.retryConfiguration": [.english: "Retry Configuration", .vietnamese: "Cấu hình thử lại"],
        "settings.maxRetries": [.english: "Max retries", .vietnamese: "Số lần thử lại tối đa"],
        "settings.retryHelp": [.english: "Number of times to retry failed requests (403, 408, 500, 502, 503, 504)", .vietnamese: "Số lần thử lại yêu cầu thất bại (403, 408, 500, 502, 503, 504)"],
        "settings.paths": [.english: "Paths", .vietnamese: "Đường dẫn"],
        "settings.binary": [.english: "Binary", .vietnamese: "Tệp chạy"],
        "settings.config": [.english: "Config", .vietnamese: "Cấu hình"],
        "settings.authDir": [.english: "Auth Dir", .vietnamese: "Thư mục xác thực"],
        "settings.language": [.english: "Language", .vietnamese: "Ngôn ngữ"],
        "settings.general": [.english: "General", .vietnamese: "Chung"],
        "settings.about": [.english: "About", .vietnamese: "Giới thiệu"],
        "settings.startup": [.english: "Startup", .vietnamese: "Khởi động"],
        "settings.appearance": [.english: "Appearance", .vietnamese: "Giao diện"],
        "settings.launchAtLogin": [.english: "Launch at login", .vietnamese: "Khởi động cùng hệ thống"],
        "settings.showInDock": [.english: "Show in Dock", .vietnamese: "Hiển thị trên Dock"],
        "settings.restartForEffect": [.english: "Restart app for full effect", .vietnamese: "Khởi động lại ứng dụng để có hiệu lực đầy đủ"],
        "settings.apiKeys": [.english: "API Keys", .vietnamese: "Khóa API"],
        "settings.apiKeysHelp": [.english: "API keys for clients to authenticate with the proxy", .vietnamese: "Khóa API để các client xác thực với proxy"],
        "settings.addAPIKey": [.english: "Add API Key", .vietnamese: "Thêm khóa API"],
        "settings.apiKeyPlaceholder": [.english: "Enter API key...", .vietnamese: "Nhập khóa API..."],
        
        // API Keys Screen
        "apiKeys.list": [.english: "API Keys", .vietnamese: "Danh sách khóa API"],
        "apiKeys.description": [.english: "API keys for clients to authenticate with the proxy service", .vietnamese: "Khóa API để các client xác thực với dịch vụ proxy"],
        "apiKeys.add": [.english: "Add Key", .vietnamese: "Thêm khóa"],
        "apiKeys.addHelp": [.english: "Add a new API key", .vietnamese: "Thêm khóa API mới"],
        "apiKeys.generate": [.english: "Generate", .vietnamese: "Tạo ngẫu nhiên"],
        "apiKeys.generateHelp": [.english: "Generate a random API key", .vietnamese: "Tạo khóa API ngẫu nhiên"],
        "apiKeys.generateFirst": [.english: "Generate Your First Key", .vietnamese: "Tạo khóa đầu tiên"],
        "apiKeys.placeholder": [.english: "Enter API key...", .vietnamese: "Nhập khóa API..."],
        "apiKeys.edit": [.english: "Edit", .vietnamese: "Sửa"],
        "apiKeys.empty": [.english: "No API Keys", .vietnamese: "Chưa có khóa API"],
        "apiKeys.emptyDescription": [.english: "Add API keys to authenticate clients with the proxy", .vietnamese: "Thêm khóa API để xác thực client với proxy"],
        
        // Logs
        "logs.clearLogs": [.english: "Clear Logs", .vietnamese: "Xóa nhật ký"],
        "logs.noLogs": [.english: "No Logs", .vietnamese: "Không có nhật ký"],
        "logs.startProxy": [.english: "Start the proxy to view logs", .vietnamese: "Khởi động proxy để xem nhật ký"],
        "logs.logsWillAppear": [.english: "Logs will appear here as requests are processed", .vietnamese: "Nhật ký sẽ xuất hiện khi có yêu cầu được xử lý"],
        "logs.searchLogs": [.english: "Search logs...", .vietnamese: "Tìm kiếm nhật ký..."],
        "logs.all": [.english: "All", .vietnamese: "Tất cả"],
        "logs.info": [.english: "Info", .vietnamese: "Thông tin"],
        "logs.warn": [.english: "Warn", .vietnamese: "Cảnh báo"],
        "logs.error": [.english: "Error", .vietnamese: "Lỗi"],
        "logs.autoScroll": [.english: "Auto-scroll", .vietnamese: "Tự cuộn"],
        
        // Actions
        "action.start": [.english: "Start", .vietnamese: "Bắt đầu"],
        "action.stop": [.english: "Stop", .vietnamese: "Dừng"],
        "action.startProxy": [.english: "Start Proxy", .vietnamese: "Khởi động Proxy"],
        "action.stopProxy": [.english: "Stop Proxy", .vietnamese: "Dừng Proxy"],
        "action.copy": [.english: "Copy", .vietnamese: "Sao chép"],
        "action.delete": [.english: "Delete", .vietnamese: "Xóa"],
        "action.refresh": [.english: "Refresh", .vietnamese: "Làm mới"],
        
        // Empty states
        "empty.proxyNotRunning": [.english: "Proxy Not Running", .vietnamese: "Proxy chưa chạy"],
        "empty.startProxyToView": [.english: "Start the proxy to view quota information", .vietnamese: "Khởi động proxy để xem thông tin hạn mức"],
        "empty.noAccounts": [.english: "No Accounts", .vietnamese: "Chưa có tài khoản"],
        "empty.addProviderAccounts": [.english: "Add provider accounts to view quota", .vietnamese: "Thêm tài khoản nhà cung cấp để xem hạn mức"],
        
        // Subscription
        "subscription.upgrade": [.english: "Upgrade", .vietnamese: "Nâng cấp"],
        "subscription.freeTier": [.english: "Free Tier", .vietnamese: "Gói miễn phí"],
        "subscription.proPlan": [.english: "Pro Plan", .vietnamese: "Gói Pro"],
        "subscription.project": [.english: "Project", .vietnamese: "Dự án"],
        
        // OAuth
        "oauth.connect": [.english: "Connect", .vietnamese: "Kết nối"],
        "oauth.authenticateWith": [.english: "Authenticate with your", .vietnamese: "Xác thực với tài khoản"],
        "oauth.projectId": [.english: "Project ID (optional)", .vietnamese: "ID dự án (tùy chọn)"],
        "oauth.projectIdPlaceholder": [.english: "Enter project ID...", .vietnamese: "Nhập ID dự án..."],
        "oauth.authenticate": [.english: "Authenticate", .vietnamese: "Xác thực"],
        "oauth.retry": [.english: "Try Again", .vietnamese: "Thử lại"],
        "oauth.openingBrowser": [.english: "Opening browser...", .vietnamese: "Đang mở trình duyệt..."],
        "oauth.waitingForAuth": [.english: "Waiting for authentication", .vietnamese: "Đang chờ xác thực"],
        "oauth.completeBrowser": [.english: "Complete the login in your browser", .vietnamese: "Hoàn tất đăng nhập trong trình duyệt"],
        "oauth.success": [.english: "Connected successfully!", .vietnamese: "Kết nối thành công!"],
        "oauth.closingSheet": [.english: "Closing...", .vietnamese: "Đang đóng..."],
        "oauth.failed": [.english: "Authentication failed", .vietnamese: "Xác thực thất bại"],
        "oauth.timeout": [.english: "Authentication timeout", .vietnamese: "Hết thời gian xác thực"],
        
        "import.vertexKey": [.english: "Import Service Account Key", .vietnamese: "Nhập khóa tài khoản dịch vụ"],
        "import.vertexDesc": [.english: "Select the JSON key file for your Vertex AI service account", .vietnamese: "Chọn tệp khóa JSON cho tài khoản dịch vụ Vertex AI"],
        "import.selectFile": [.english: "Select JSON File", .vietnamese: "Chọn tệp JSON"],
        "import.success": [.english: "Key imported successfully", .vietnamese: "Đã nhập khóa thành công"],
        "import.failed": [.english: "Import failed", .vietnamese: "Nhập thất bại"],
        
        // Menu Bar
        "menubar.running": [.english: "Proxy Running", .vietnamese: "Proxy đang chạy"],
        "menubar.stopped": [.english: "Proxy Stopped", .vietnamese: "Proxy đã dừng"],
        "menubar.accounts": [.english: "Accounts", .vietnamese: "Tài khoản"],
        "menubar.requests": [.english: "Requests", .vietnamese: "Yêu cầu"],
        "menubar.success": [.english: "Success", .vietnamese: "Thành công"],
        "menubar.providers": [.english: "Providers", .vietnamese: "Nhà cung cấp"],
        "menubar.noProviders": [.english: "No providers connected", .vietnamese: "Chưa kết nối nhà cung cấp"],
        "menubar.andMore": [.english: "+{count} more...", .vietnamese: "+{count} nữa..."],
        "menubar.openApp": [.english: "Open Quotio", .vietnamese: "Mở Quotio"],
        "menubar.quit": [.english: "Quit Quotio", .vietnamese: "Thoát Quotio"],
        "menubar.quota": [.english: "Quota Usage", .vietnamese: "Sử dụng hạn mức"],
    ]
    
    static func get(_ key: String, language: AppLanguage) -> String {
        return strings[key]?[language] ?? strings[key]?[.english] ?? key
    }
}

extension String {
    @MainActor
    func localized() -> String {
        return LanguageManager.shared.localized(self)
    }
}
