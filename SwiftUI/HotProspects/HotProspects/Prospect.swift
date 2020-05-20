//
//  Prospect.swift
//  HotProspects
//
//  Created by Mansur Ahmed on 2020-05-19.
//  Copyright © 2020 Mansur Ahmed. All rights reserved.
//

import SwiftUI

class Prospect: Identifiable, Codable, Comparable {
    let id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    fileprivate(set) var isContacted = false
    
    static func < (lhs: Prospect, rhs: Prospect) -> Bool {
        return lhs.name < rhs.name
    }
    
    static func == (lhs: Prospect, rhs: Prospect) -> Bool {
        return lhs.name == lhs.name
    }
}

class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect]
    
    static let saveKey = "SavedData"
    
    init() {
        let filename = getDocumentsDirectory().appendingPathComponent(Prospects.saveKey)
        
        do {
            let data = try Data(contentsOf: filename)
            people =  try JSONDecoder().decode([Prospect].self, from: data)
            return
        } catch {
            print("Error. Unable to load data.")
        }
        
        /*
        if let data = UserDefaults.standard.data(forKey: Self.saveKey) {
            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
                self.people = decoded
                return
            }
        }
        */
        
        self.people = []
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
    
    private func save() {
        do {
            let filename = getDocumentsDirectory().appendingPathComponent(Prospects.saveKey)
            let data = try JSONEncoder().encode(people)
            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Error. Unable to save data.")
        }
        
        /*
        if let encoded = try? JSONEncoder().encode(people) {
            UserDefaults.standard.set(encoded, forKey: Self.saveKey)
        }
        */
    }
    
    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }
}

fileprivate func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    return paths[0]
}
