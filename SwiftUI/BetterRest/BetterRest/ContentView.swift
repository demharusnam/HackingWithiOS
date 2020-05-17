//
//  ContentView.swift
//  BetterRest
//
//  Created by Mansur Ahmed on 2020-04-09.
//  Copyright © 2020 Mansur Ahmed. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var sleepAmount: Double = 8.0
    @State private var wakeUp: Date = defaultWakeTime
    @State private var coffeeAmount: Int = 0
    
    private static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("When do you want to wake up?")) {
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                }
                
                Section(header: Text("Desired amount of sleep")) {
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                    // added as per Chapter 15: Accessibility challenge
                    .accessibility(value: Text("\(sleepAmount) hours of sleep"))
                }
                
                Section(header: Text("Daily coffee intake")) {
                    Picker(selection: $coffeeAmount, label: Text(coffeeAmount + 1 == 1 ? "1 cup" : "\(coffeeAmount + 1) cups")) {
                        ForEach(1 ..< 21) { cups in
                            Text("\(cups)")
                        }
                    }
                }
                
                Section(header: Text("Your ideal bedtime is...")) {
                    Text(calculateBedtime())
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
            }
            .navigationBarTitle("BetterRest")
        }
    }
    
    func calculateBedtime() -> String {
        let model = SleepCalculator()
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount + 1))
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            let bedtime = formatter.string(from: sleepTime)
            
            return bedtime
        } catch {
            return "Error. There was a problem calculating your bedtime. Please try again."
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
