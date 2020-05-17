//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Mansur Ahmed on 2020-04-26.
//  Copyright © 2020 Mansur Ahmed. All rights reserved.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var order: Order

    @State private var showingConfirmation = false
    @State private var orderSuccess = false
    @State var confirmationMessage = ""
    
    private var confirmationTitle: String {
        get {
            orderSuccess ? "Thank you!" : "Error!"
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack {
                    // modified Image to decorative as per Chapter 15: Accessibility challenge
                    Image(decorative: "cupcakes")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width)
                    
                    Text("Your total is $\(self.order.cost, specifier:  "%.2f")")
                        .font(.title)
                    
                    Button("Place Order") {
                        self.placeOrder()
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitle("Check out", displayMode: .inline)
        .alert(isPresented: $showingConfirmation) {
            Alert(title: Text(confirmationTitle), message: orderSuccess ? Text(confirmationMessage) : Text("Unable to complete order."), dismissButton: .default(Text("OK"), action: {
                if self.orderSuccess {
                    self.orderSuccess = false
                }
            }))
        }
    }
    
    func placeOrder() {
        guard let encoded = try? JSONEncoder().encode(order.data) else {
            print("Failed to encode order")
            self.showingConfirmation = true
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                self.showingConfirmation = true
                return
            }
            
            if let decodedOrder = try? JSONDecoder().decode(Order.OrderData.self, from: data) {
                self.confirmationMessage = "Your order for \(decodedOrder.quantity)x\(Order.types[decodedOrder.type].lowercased()) cupcake is on its way!"
                self.orderSuccess = true
            } else {
                print("Invalid response from server")
            }
            
            self.showingConfirmation = true
        }
        .resume()
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}
