//
//  SettingsScreen.swift
//  Quotio
//

import SwiftUI
import ServiceManagement

struct SettingsScreen: View {
    @Environment(QuotaViewModel.self) private var viewModel
    
    @AppStorage("autoStartProxy") private var autoStartProxy = false
    @AppStorage("routingStrategy") private var routingStrategy = "round-robin"
    @AppStorage("requestRetry") private var requestRetry = 3
    @AppStorage("switchProjectOnQuotaExceeded") private var switchProject = true
    @AppStorage("switchPreviewModelOnQuotaExceeded") private var switchPreviewModel = true
    
    @State private var portText: String = ""
    
    var body: some View {
        Form {
            // Proxy Server
            Section {
                HStack {
                    Text("Port")
                    Spacer()
                    TextField("Port", text: $portText)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 100)
                        .onChange(of: portText) { _, newValue in
                            if let port = UInt16(newValue), port > 0 {
                                viewModel.proxyManager.port = port
                            }
                        }
                }
                
                LabeledContent("Status") {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(viewModel.proxyManager.proxyStatus.running ? .green : .gray)
                            .frame(width: 8, height: 8)
                        Text(viewModel.proxyManager.proxyStatus.running ? "Running" : "Stopped")
                    }
                }
                
                LabeledContent("Endpoint") {
                    HStack {
                        Text(viewModel.proxyManager.proxyStatus.endpoint)
                            .font(.system(.body, design: .monospaced))
                            .textSelection(.enabled)
                        
                        Button {
                            viewModel.proxyManager.copyEndpointToClipboard()
                        } label: {
                            Image(systemName: "doc.on.doc")
                        }
                        .buttonStyle(.borderless)
                    }
                }
                
                Toggle("Auto-start proxy on launch", isOn: $autoStartProxy)
            } header: {
                Label("Proxy Server", systemImage: "server.rack")
            } footer: {
                Text("Restart proxy after changing port")
            }
            
            // Routing Strategy
            Section {
                Picker("Strategy", selection: $routingStrategy) {
                    Text("Round Robin").tag("round-robin")
                    Text("Fill First").tag("fill-first")
                }
                .pickerStyle(.segmented)
            } header: {
                Label("Routing Strategy", systemImage: "arrow.triangle.branch")
            } footer: {
                Text(routingStrategy == "round-robin"
                     ? "Distributes requests evenly across all accounts"
                     : "Uses one account until quota exhausted, then moves to next")
            }
            
            // Quota Exceeded Behavior
            Section {
                Toggle("Auto-switch to another account", isOn: $switchProject)
                Toggle("Auto-switch to preview model", isOn: $switchPreviewModel)
            } header: {
                Label("Quota Exceeded Behavior", systemImage: "exclamationmark.triangle")
            } footer: {
                Text("When quota is exceeded, automatically try alternative accounts or models")
            }
            
            // Retry Configuration
            Section {
                Stepper("Max retries: \(requestRetry)", value: $requestRetry, in: 0...10)
            } header: {
                Label("Retry Configuration", systemImage: "arrow.clockwise")
            } footer: {
                Text("Number of times to retry failed requests (403, 408, 500, 502, 503, 504)")
            }
            
            // Paths
            Section {
                LabeledContent("Binary") {
                    PathLabel(path: viewModel.proxyManager.binaryPath)
                }
                
                LabeledContent("Config") {
                    PathLabel(path: viewModel.proxyManager.configPath)
                }
                
                LabeledContent("Auth Dir") {
                    PathLabel(path: viewModel.proxyManager.authDir)
                }
            } header: {
                Label("Paths", systemImage: "folder")
            }
        }
        .formStyle(.grouped)
        .navigationTitle("Settings")
        .onAppear {
            portText = String(viewModel.proxyManager.port)
        }
    }
}

// MARK: - Path Label

struct PathLabel: View {
    let path: String
    
    var body: some View {
        HStack {
            Text(path)
                .font(.system(.caption, design: .monospaced))
                .lineLimit(1)
                .truncationMode(.middle)
                .textSelection(.enabled)
            
            Button {
                NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: (path as NSString).deletingLastPathComponent)
            } label: {
                Image(systemName: "folder")
            }
            .buttonStyle(.borderless)
        }
    }
}

// MARK: - App Settings View

struct AppSettingsView: View {
    var body: some View {
        TabView {
            GeneralSettingsTab()
                .tabItem {
                    Label("General", systemImage: "gearshape")
                }
            
            AboutTab()
                .tabItem {
                    Label("About", systemImage: "info.circle")
                }
        }
        .frame(width: 450, height: 300)
    }
}

struct GeneralSettingsTab: View {
    @State private var launchAtLogin = SMAppService.mainApp.status == .enabled
    @AppStorage("showInDock") private var showInDock = true
    @AppStorage("autoStartProxy") private var autoStartProxy = false
    
    var body: some View {
        Form {
            Section {
                Toggle("Launch at login", isOn: $launchAtLogin)
                    .onChange(of: launchAtLogin) { _, newValue in
                        do {
                            if newValue {
                                try SMAppService.mainApp.register()
                            } else {
                                try SMAppService.mainApp.unregister()
                            }
                        } catch {
                            launchAtLogin = !newValue
                        }
                    }
                
                Toggle("Auto-start proxy on launch", isOn: $autoStartProxy)
            } header: {
                Label("Startup", systemImage: "power")
            }
            
            Section {
                Toggle("Show in Dock", isOn: $showInDock)
            } header: {
                Label("Appearance", systemImage: "macwindow")
            }
        }
        .formStyle(.grouped)
        .padding()
    }
}

struct AboutTab: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "gauge.with.dots.needle.67percent")
                .font(.system(size: 48))
                .foregroundStyle(.blue)
            
            Text("Quotio")
                .font(.title)
                .fontWeight(.bold)
            
            Text("CLIProxyAPI GUI Wrapper")
                .foregroundStyle(.secondary)
            
            Text("Version 1.0")
                .font(.caption)
                .foregroundStyle(.tertiary)
            
            Link("GitHub: CLIProxyAPI", destination: URL(string: "https://github.com/router-for-me/CLIProxyAPI")!)
                .buttonStyle(.bordered)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
