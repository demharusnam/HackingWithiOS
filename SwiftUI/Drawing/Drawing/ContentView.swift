//
//  ContentView.swift
//  Drawing
//
//  Created by Mansur Ahmed on 2020-04-23.
//  Copyright © 2020 Mansur Ahmed. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var lineThickness: CGFloat = 10
    @State private var colorCycle = 0.0
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 60) {
                Arrow()
                    .strokeBorder(Color.blue, lineWidth: lineThickness)
                    .frame(width: 100, height: 200)
                
                VStack(spacing: 0) {
                    Text("Shape Thickness")
                    Slider(value: $lineThickness, in: 0...108)
                }
            }
            
            Spacer()
            
            VStack(spacing: 20) {
                ColorCyclingRectangle(amount: self.colorCycle)
                    .frame(width: 300, height: 200)

                VStack(spacing: 0) {
                    Text("Cycle Color")
                    Slider(value: $colorCycle)
                }
            }
        }
        .padding()
    }
}

struct Arrow: InsettableShape {
    var insetAmount: CGFloat = 0
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var arrow = self
        arrow.insetAmount += amount
        return arrow
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // create triangle
        path.addLines([CGPoint(x: rect.midX, y: rect.minY), CGPoint(x: rect.maxX, y: rect.midY), CGPoint(x: rect.minX, y: rect.midY), CGPoint(x: rect.midX, y: rect.minY), CGPoint(x: rect.maxX, y: rect.midY)])
        
        // append rectangle
        path.addLines([CGPoint(x: rect.midX * 1.25, y: rect.midY), CGPoint(x: rect.midX * 1.25, y: rect.maxY), CGPoint(x: rect.midX * 0.75, y: rect.maxY), CGPoint(x: rect.midX * 0.75, y: rect.midY)])
        
        return path
    }
}


struct ColorCyclingRectangle: View {
    var amount = 0.0
    var steps = 100
    
    var body: some View {
        ZStack {
            ForEach(0..<steps) { value in
                Rectangle()
                    .inset(by: CGFloat(value))
                    .strokeBorder(self.color(for: value, brightness: 1), lineWidth: 2)
            }
        }
    }
    
    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(self.steps) + self.amount
        
        if targetHue > 1 {
             targetHue -= 1
        }
        
        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
