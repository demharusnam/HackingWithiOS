//
//  ContentView.swift
//  Flashzilla
//
//  Created by Mansur Ahmed on 2020-05-19.
//  Copyright © 2020 Mansur Ahmed. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    enum SheetType {
        case settings, edit
    }
    
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityEnabled) var accessibilityEnabled
    @State private var cards = [Card]()
    @State private var timeRemaining = 100
    @State private var isActive = true
    @State private var showingSheet = false
    @State private var sheetType = SheetType.edit
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let settings = Settings()
    
    var body: some View {
        ZStack {
            Image(decorative: "background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.vertical, 5)
                    .background(
                        Capsule()
                            .fill(Color.black)
                            .opacity(0.75)
                            .frame(width: 200)
                    )
                
                ZStack {
                    ForEach(cards) { card in
                        CardView(card: card) { correct in
                            withAnimation {
                                self.removeCard(at: self.indexFromCard(card), correct: correct)
                            }
                        }
                        .stacked(at: self.indexFromCard(card), in: self.cards.count)
                        .allowsHitTesting(self.indexFromCard(card) == self.cards.count - 1)
                        .accessibility(hidden: self.indexFromCard(card) < self.cards.count - 1)
                    }
                }
                .allowsHitTesting(timeRemaining > 0)
                
                if cards.isEmpty {
                    Button("Start Again", action: resetCards)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                }
            }
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        self.sheetType = .edit
                        self.showingSheet = true
                    }) {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .clipShape(Circle())
                            .accessibility(label: Text("Create new cards."))
                    }
                }
                
                Spacer()
            }
            .foregroundColor(.white)
            .font(.largeTitle)
            .padding()
            
            VStack {
                HStack {
                    Button(action: {
                        self.sheetType = .settings
                        self.showingSheet = true
                    }) {
                        Image(systemName: "gear")
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .clipShape(Circle())
                            .accessibility(label: Text("Settings"))
                    }
                    
                    Spacer()
                }
                
                Spacer()
            }
            .foregroundColor(.white)
            .font(.largeTitle)
            .padding()
            
            if differentiateWithoutColor || accessibilityEnabled {
                VStack {
                    Spacer()
                    
                    HStack {
                        Button(action: {
                            withAnimation {
                                self.removeCard(at: self.cards.count - 1, correct: false)
                            }
                        }) {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibility(label: Text("Wrong"))
                        .accessibility(hint: Text("Mark your answer as being incorrect."))
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation {
                                self.removeCard(at: self.cards.count - 1, correct: true)
                            }
                        }) {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibility(label: Text("Correct"))
                        .accessibility(hint: Text("Mark your answer as being correct."))
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
            
            if timeRemaining == 0 {
                Group {
                    Rectangle()
                    
                    Text("GAME OVER")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }
                .edgesIgnoringSafeArea(.all)
                .onTapGesture(perform: resetCards)
                .accessibility(addTraits: .isButton)
            }
        }
        .onReceive(timer) { (time) in
            guard self.isActive else { return }
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { (_) in
            self.isActive = false
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { (_) in
            if !self.cards.isEmpty {
                self.isActive = true
            }
        }
        .sheet(isPresented: $showingSheet, onDismiss: resetCards) {
            if self.sheetType == .edit {
                EditCards()
            } else {
                SettingsView().environmentObject(self.settings)
            }
        }
        .onAppear(perform: resetCards)
    }
    
    func removeCard(at index: Int, correct: Bool) {
        guard index >= 0 else { return }
        if settings.wrappedSendWrongCardToBack && !correct {
            let card = cards.remove(at: index)
            cards.insert(Card(prompt: card.prompt, answer: card.answer), at: 0)
            // at the time of coding this, cards.move(...) does not update moved element in cards array to the UI
            // thus, above method was resorted to
        } else {
            cards.remove(at: index)
            if cards.isEmpty {
                isActive = false
            }
        }
    }
    
    func resetCards() {
        timeRemaining = 100
        isActive = true
        loadData()
    }
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                self.cards = decoded
            }
        }
    }
    
    func indexFromCard(_ card: Card) -> Int {
        return self.cards.firstIndex(where: { $0.id == card.id } )!
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = CGFloat(total - position)
        return self.offset(CGSize(width: 0, height: offset * 10))
    }
}
