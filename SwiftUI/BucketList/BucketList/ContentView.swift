//
//  ContentView.swift
//  BucketList
//
//  Created by Mansur Ahmed on 2020-05-13.
//  Copyright © 2020 Mansur Ahmed. All rights reserved.
//

import SwiftUI
import LocalAuthentication

struct ContentView: View {
    @State private var isUnlocked = false
    @State private var didFailAuthentication = false
    @State private var error: Error?
    
    var body: some View {
        ZStack {
            if isUnlocked {
                DestinationsView()
            } else {
                Button("Unlock Places") {
                    self.authenticate()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
        }
        .alert(isPresented: $didFailAuthentication) {
            Alert(title: Text("Error"), message: Text(error?.localizedDescription ?? "Unknown error. Please try again."), dismissButton: .default(Text("OK")))
        }
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate yourself to unlock your places."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (success, authenticationError) in
                DispatchQueue.main.async {
                    if success {
                        self.isUnlocked = true
                    } else {
                        self.error = authenticationError
                        self.didFailAuthentication = true
                    }
                }
            }
        } else {
            // no biometrics
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
