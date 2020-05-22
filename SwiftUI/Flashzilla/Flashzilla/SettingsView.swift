//
//  SettingsView.swift
//  Flashzilla
//
//  Created by Mansur Ahmed on 2020-05-20.
//  Copyright © 2020 Mansur Ahmed. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: Settings
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                Toggle(isOn: $settings.wrappedSendWrongCardToBack) {
                    Text("Send wrong answer card to back of stack")
                }
            }
            .navigationBarTitle("Settings")
            .navigationBarItems(trailing: Button("Done", action: dismiss))
            .listStyle(GroupedListStyle())
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
