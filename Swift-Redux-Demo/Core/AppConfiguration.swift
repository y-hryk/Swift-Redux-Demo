//
//  AppConfiguration.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/09/13.
//

import Foundation

class AppConfiguration {
    static let shared = AppConfiguration()
    
    private var config: [String: Any] = [:]
    var isLoaded = false
    
    // 設定ファイル名の定義
    private let configFileName = "Config"
    private let templateFileName = "Config-Template"
    
    private init() {
        loadConfiguration()
    }
    
    // MARK: - Configuration Loading
    private func loadConfiguration() {
        print("🔄 Loading configuration...")
        
        if loadFromConfigFile() {
            isLoaded = true
            print("✅ Config.plist loaded successfully")
            return
        }
        print("📋 Config-Template.plist found.")
        print("💡 Please copy it to Config.plist and update with your values.")
        print("⚠️ No configuration loaded. Please create Config.plist file.")
        print("📌 Don't forget to add Config.plist to target membership!")
    }
    
    private func loadFromConfigFile() -> Bool {
        // Bundle内のConfig.plistを探す
        guard let path = Bundle.main.path(forResource: configFileName, ofType: "plist") else {
            print("📄 Config.plist not found in bundle")
            return false
        }
        
        print("📄 Found Config.plist at: \(path)")
        
        guard let plistData = NSDictionary(contentsOfFile: path) as? [String: Any] else {
            print("❌ Failed to read Config.plist")
            return false
        }
        
        config = plistData
        return true
    }
    
    // MARK: - Value Getters
    private func getString(for key: String) -> String? {
        return config[key] as? String
    }
    
    private func getString(for key: String, defaultValue: String) -> String {
        return config[key] as? String ?? defaultValue
    }
    
    // MARK: - Configuration Properties
    var apiKey: String? {
        return getString(for: "API_KEY")
    }
}

enum AppConfigurationError: Error, LocalizedError {
    case invalidConfigurationFile
    case fileNotFound
    
    var errorDescription: String? {
        switch self {
        case .invalidConfigurationFile:
            return "Configuration file format is invalid"
        case .fileNotFound:
            return "Configuration file not found"
        }
    }
}
