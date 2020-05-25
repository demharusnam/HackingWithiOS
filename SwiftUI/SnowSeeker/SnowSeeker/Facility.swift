//
//  Facility.swift
//  SnowSeeker
//
//  Created by Mansur Ahmed on 2020-05-24.
//  Copyright © 2020 Mansur Ahmed. All rights reserved.
//

import SwiftUI

struct Facility: Identifiable {
    let id = UUID()
    var name: String
    
    var icon: some View {
        let icons = [
            "Accommodation": "house",
            "Beginners": "1.circle",
            "Cross-country": "map",
            "Eco-friendly": "leaf.arrow.circlepath",
            "Family": "person.3"
        ]
        
        if let iconName = icons[name] {
            let image = Image(systemName: iconName)
                            .accessibility(label: Text(name))
                            .foregroundColor(.secondary)
            return image
        } else {
            fatalError("Unknown name type: \(name)")
        }
    }
    
    var alert: Alert {
        let messages = [
            "Accommodation": "This resort has popular on-site accommodations.",
            "Beginners": "This resort has lots of ski schools.",
            "Eco-friendly": "This resort has won an award for environmental friendliness.",
            "Family": "This resort is popular with families."
        ]
        
        if let message = messages[name] {
            return Alert(title: Text(name), message: Text(message))
        } else {
            fatalError("Unknown name type: \(name)")
        }
    }
}
