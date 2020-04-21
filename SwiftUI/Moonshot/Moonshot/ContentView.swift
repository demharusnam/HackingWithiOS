//
//  ContentView.swift
//  Moonshot
//
//  Created by Mansur Ahmed on 2020-04-21.
//  Copyright © 2020 Mansur Ahmed. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var showCrewNames = false
    
    let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    
    var body: some View {
        NavigationView {
            List(missions) { mission in
                NavigationLink(destination: MissionView(mission: mission, astronauts: self.astronauts)) {
                    Image(mission.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 44, height: 44)
                    
                    VStack(alignment: .leading) {
                        Text(mission.displayName)
                            .font(.headline)
                        Text(self.showCrewNames ? self.crewNames(from: mission) : mission.formattedLaunchDate)
                    }
                }
            }
            .navigationBarTitle("Moonshot")
            .navigationBarItems(leading: Button("\(showCrewNames ? "Hide" : "Show") Crew Members") {
                self.showCrewNames.toggle()
            })
        }
    }
    
    private func crewNames(from mission: Mission) -> String {
        var names = ""
        
        for member in mission.crew {
            if member.name == mission.crew.last?.name {
                names += "\(member.name.capitalizeFirstLetter())"
            } else {
                names += "\(member.name.capitalizeFirstLetter()), "
            }
        }
        
        return names
    }
}

extension String {
    func capitalizeFirstLetter() -> String {
        prefix(1).capitalized + dropFirst()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
