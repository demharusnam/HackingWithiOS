//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Mansur Ahmed on 2020-04-25.
//  Copyright © 2020 Mansur Ahmed. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var order = Order()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Select your cake type", selection: $order.data.type) {
                        ForEach(0..<Order.types.count) {
                            Text(Order.types[$0])
                        }
                    }
                    
                    Stepper(value: $order.data.quantity, in: 3...20) {
                        Text("Number of cakes: \(order.data.quantity)")
                    }
                }
                
                Section {
                    Toggle(isOn: $order.data.specialRequestEnabled.animation()) {
                        Text("Any special requests?")
                    }
                    
                    if order.data.specialRequestEnabled {
                        Toggle(isOn: $order.data.extraFrosting) {
                            Text("Add extra frosting")
                        }
                        
                        Toggle(isOn: $order.data.addSprinkles) {
                            Text("Add extra sprinkles")
                        }
                    }
                }
                
                Section {
                    NavigationLink(destination: AddressView(order: order)) {
                        Text("Delivery details")
                    }
                }
            }
            .navigationBarTitle("Cupcake Corner")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
