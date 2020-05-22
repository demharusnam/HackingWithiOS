//
//  Settings.swift
//  Flashzilla
//
//  Created by Mansur Ahmed on 2020-05-20.
//  Copyright © 2020 Mansur Ahmed. All rights reserved.
//

import SwiftUI

class UserSettings: Codable {
    var sendWrongCardToBack = false
}

class Settings: ObservableObject {
    @Published private var user: UserSettings
    
    var wrappedSendWrongCardToBack: Bool {
        get {
            user.sendWrongCardToBack
        }
        
        set {
            user.sendWrongCardToBack = newValue
            save()
        }
    }
    
    static let saveKey = "Settings"
    
    init() {
        if let data = UserDefaults.standard.data(forKey: Self.saveKey) {
            if let decoded = try? JSONDecoder().decode(UserSettings.self, from: data) {
                self.user = decoded
                return
            }
        }
        
        self.user = UserSettings()
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: Self.saveKey)
        }
    }
}
