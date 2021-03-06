//
//  ContentView.swift
//  WordScramble
//
//  Created by Mansur Ahmed on 2020-04-09.
//  Copyright © 2020 Mansur Ahmed. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = Array.init(repeating: "Test", count: 30)//[String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    @State private var score: Int = 0
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter your word", text: $newWord, onCommit: addNewWord)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocapitalization(.none)
                // modified as per Chapter 18: Layout and Geometry challenges
                GeometryReader { listView in
                    List(self.usedWords.indices, id: \.self) { index in
                        GeometryReader { geo in
                            HStack {
                                Image(systemName: "\(self.usedWords[index].count).circle")
                                    .foregroundColor(Color(red: 0, green: Double(geo.frame(in: .global).minY / listView.size.height), blue: 0))
                                Text(self.usedWords[index])
                            }
                            .frame(width: geo.size.width, alignment: .leading)
                            .slideIn(index: index, maxElementsInView: listView.size.height / (geo.size.height + 15), rectInGlobal: geo.frame(in: .global), parentSize: listView.size)
                            // added as per Chapter 15: Accessibility challenge
                            .accessibilityElement(children: .ignore)
                            .accessibility(label: Text("\(self.usedWords[index]), \(self.usedWords[index].count) letters"))
                        }
                    }
                }
                
                Text("Score: \(score)")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
            }
            .navigationBarTitle(rootWord)
            .onAppear(perform: startGame)
            .alert(isPresented: $showingError) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
            .navigationBarItems(leading: Button(action: startGame) {
                Text("Reset")
            })
        }
    }
    
    private func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else {
            return
        }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word already used", message: "Be more original.")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word not possible", message: "That isn't a real word, is a copy of the root word, and/or is less than three letters.")
            return
        }
        
        usedWords.insert(answer, at: 0)
        newWord = ""
        score += answer.count
    }
    
    private func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                //usedWords.removeAll()
                score = 0
                return
            }
        }
        fatalError("Could not load start.txt from bundle.")
    }
    
    private func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    private func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        
        return true
    }
    
    private func isReal(word: String) -> Bool {
        if word.count < 3 || word == rootWord {
            return false
        }
        
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    private func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View {
    func slideIn(index: Int, maxElementsInView: CGFloat, rectInGlobal item: CGRect, parentSize: CGSize) -> some View {
        let maxElements = Int(floor(Double(maxElementsInView)))
        let dx = (item.minY - parentSize.height) / 3
        let slideIn = Int(dx < 0 ? 0 : dx)
        let offset = index <= maxElements ? CGSize.zero : CGSize(width: slideIn, height: 0)
        return self.offset(offset)
    }
}
