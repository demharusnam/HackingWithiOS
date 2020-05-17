//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Mansur Ahmed on 2020-04-06.
//  Copyright © 2020 Mansur Ahmed. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore: Bool = false
    @State private var scoreTitle: String = ""
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var score: Int = 0
    // state variables added as per project 6
    @State private var animate = false
    @State private var incorrect = false
    @State private var angle = 0.0
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                
                Spacer()
                
                VStack {
                    Text("Tap the flag of")
                    Text(countries[correctAnswer])
                        .font(.largeTitle)
                        .fontWeight(.black)
                }.foregroundColor(.white)
                
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        // added as per project 6
                        if (number == self.correctAnswer) {
                            self.angle = 360
                        } else {
                            self.incorrect = true
                        }
                        self.animate = true
                        
                        self.flagTapped(number)
                    }) {
                        // implementing FlagImage() view as per project 3
                        FlagImage(country: self.countries[number])
                        /*
                        Image(self.countries[number])
                            .renderingMode(.original)
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
                            .shadow(color: .black, radius: 2)
                         */
                    }
                    // modifiers added as per project 6
                    .rotation3DEffect(.degrees(number == self.correctAnswer ? self.angle : 0), axis: (x: 0, y: 1, z: 0))
                    .opacity(number != self.correctAnswer && self.animate ? 0.25 : 1)
                    .scaleEffect(self.incorrect && number == self.correctAnswer ? 1.33 : 1)
                    .animation(self.animate ? .default : nil)
                }
                
                Spacer()
                
                VStack {
                    Text("Your current score is")
                    Text("\(score)")
                        .font(.largeTitle)
                        .fontWeight(.black)
                }.foregroundColor(.white)
                
                
                Spacer()
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text("Your score is \(score)"), dismissButton: .default(Text("Continue")) {
                    // added state variables reset as per project 6
                    self.angle = 0
                    self.animate = false
                    self.incorrect = false
                
                    self.askQuestion()
            })
        }
    }
    
    func flagTapped(_ number: Int) {
        if (number == correctAnswer) {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Incorrect! That's the flag of \(countries[number])"
            if (score > 0) {
                score -= 1
            }
        }
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

// creating FlagImage() view as per project 3
struct FlagImage: View {
    var country: String
    
    // added as per Chapter 15: Accessibility
    let labels = [
            "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
            "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
            "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
            "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
            "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
            "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
            "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
            "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
            "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
            "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
            "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    
    var body: some View {
        Image(country)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
            .accessibility(label: Text(self.labels[country, default: "Unknown flag"]))
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
