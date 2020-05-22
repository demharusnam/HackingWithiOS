//
//  Card.swift
//  Flashzilla
//
//  Created by Mansur Ahmed on 2020-05-20.
//  Copyright © 2020 Mansur Ahmed. All rights reserved.
//

import SwiftUI

struct Card: Codable, Identifiable {
    let id = UUID()
    let prompt: String
    let answer: String
    
    static var example: Card {
        return Card(prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
    }
    
    static var example2: Card {
        return Card(prompt: "Who played the Mansur", answer: "Ahmed")
    }
}
