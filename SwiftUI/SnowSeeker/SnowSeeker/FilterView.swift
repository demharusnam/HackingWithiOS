//
//  FilterView.swift
//  SnowSeeker
//
//  Created by Mansur Ahmed on 2020-05-25.
//  Copyright © 2020 Mansur Ahmed. All rights reserved.
//

import SwiftUI

struct FilterView: View {
    @Environment(\.presentationMode) var presentationMode
    var filterKeys =  ["Country", "Price", "Size"]
    var filterValues = [Resort.allCountries, ["$", "$$", "$$$"], ["Small", "Average", "Large"]]
    
    var setFilter: ((_ filterKey: String, _ filterValue: String) -> Void)? = nil

    var body: some View {
        NavigationView {
            List {
                ForEach(0..<3, id: \.self) { index in
                    Section(header: Text(self.filterKeys[index])) {
                        ForEach(self.filterValues[index], id: \.self) { value in
                            HStack {
                                Text(value)
                                Spacer()
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                self.setFilter?(self.filterKeys[index], value)
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarItems(leading: Button("Remove Filter") {
                self.setFilter?("None", "None")
                self.presentationMode.wrappedValue.dismiss()
                }, trailing: Button("Done") {
                self.presentationMode.wrappedValue.dismiss()
            })
                .navigationBarTitle("Filters", displayMode: .inline)
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView()
    }
}
