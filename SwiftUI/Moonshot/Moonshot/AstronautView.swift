//
//  AstronautView.swift
//  Moonshot
//
//  Created by Mansur Ahmed on 2020-04-21.
//  Copyright © 2020 Mansur Ahmed. All rights reserved.
//

import SwiftUI

struct AstronautView: View {
    let astronaut: Astronaut
    var missionsFlown: [Mission] {
        var missions: [Mission] = Bundle.main.decode("missions.json")
        
        missions.removeAll(where: { !$0.crew.contains(where: { $0.name == astronaut.id })})
        
        return missions
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    Image(self.astronaut.id)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width)
                    
                    HStack {
                        Text("Missions Flown:")
                            .fontWeight(.bold)
                        ForEach(self.missionsFlown, id: \.id) {
                            Text(self.missionsFlown.last?.displayName == $0.displayName ? "\($0.displayName)" : "\($0.displayName),")
                        }
                    }
                    
                    Text(self.astronaut.description)
                        .padding()
                }
            }
        }
        .navigationBarTitle(Text(astronaut.name), displayMode: .inline)
    }
}

struct AstronautView_Previews: PreviewProvider {
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    
    static var previews: some View {
        AstronautView(astronaut: astronauts[7])
    }
}
