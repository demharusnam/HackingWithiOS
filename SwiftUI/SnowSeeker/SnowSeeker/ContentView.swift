//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Mansur Ahmed on 2020-05-24.
//  Copyright © 2020 Mansur Ahmed. All rights reserved.
//

import SwiftUI

extension View {
    func phoneOnlyStackNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return AnyView(self.navigationViewStyle(StackNavigationViewStyle()))
        } else {
            return AnyView(self)
        }
    }
}

struct WelcomeView: View {
    var body: some View {
        VStack {
            Text("Welcome to SnowSeeker!")
                .font(.largeTitle)
            
            Text("Please select a resort from the left-hand menu; swipe from the left edge to show it.")
                .foregroundColor(.secondary)
        }
    }
}

enum FilterType {
    case country(String), size(Int), price(Int), none
}

enum SortType {
    case `default`, alphabetical, country
}


struct ContentView: View {
    @ObservedObject var favorites = Favorites()
    @State private var isShowingSheet = false
    @State private var isShowingActionSheet = false
    @State private var filterType = FilterType.none
    @State private var sortType = SortType.default
    
    var filteredResorts: [Resort] {
        switch filterType {
        case .country(let country):
            return Resort.allResorts.filter( { $0.country == country } )
        case .price(let price):
            return Resort.allResorts.filter( { $0.price == price } )
        case .size(let size):
            return Resort.allResorts.filter( { $0.size == size  } )
        case .none:
            return Resort.allResorts
        }
    }
    
    var sortedResorts: [Resort] {
        switch sortType {
        case .alphabetical:
            return filteredResorts.sorted(by: { $0.name < $1.name } )
        case .country:
            return filteredResorts.sorted(by: { $0.country < $1.country } )
        case .default:
            return filteredResorts
        }
    }
    
    var body: some View {
        NavigationView {
            List(sortedResorts) { resort in
                NavigationLink(destination: ResortView(resort: resort)) {
                    Image(resort.country)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 25)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.black, lineWidth: 1))
                    
                    VStack(alignment: .leading) {
                        Text(resort.name)
                            .font(.headline)
                        Text("\(resort.runs) runs")
                            .foregroundColor(.secondary)
                    }
                    .layoutPriority(1)
                    
                    if self.favorites.contains(resort) {
                        Spacer()
                        Image(systemName: "heart.fill")
                            .accessibility(label: Text("This is a favorite resort"))
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationBarItems(leading: Button(action: {
                    self.isShowingActionSheet = true
                }) {
                    Image(systemName: "arrow.up.arrow.down.square")
                }, trailing: Button(action: {
                    self.isShowingSheet = true
                }) {
                    Image(systemName: "eye")
            })
            .navigationBarTitle("Resorts")
            
            WelcomeView()
        }
        .actionSheet(isPresented: $isShowingActionSheet) {
                ActionSheet(title: Text("Sort"), message: Text("How would you like to sort your Resort.allResorts?"), buttons: [
                    .default(Text("Alphabetical")) { self.sortType = .alphabetical },
                    .default(Text("Country")) { self.sortType = .country },
                    .default(Text("Default")) { self.sortType = .default },
                    .cancel()
                ])
        }
        .sheet(isPresented: $isShowingSheet) {
            FilterView() { filter, value in
                switch filter {
                case "Country":
                    self.filterType = .country(value)
                case "Price":
                    self.filterType = .price(value.count)
                case "Size":
                    self.filterType = .price(["Small" : 1, "Average" : 2, "Large" : 3][value]!)
                default:
                    self.filterType = .none
                }
            }
        }
        .phoneOnlyStackNavigationView()
        .environmentObject(favorites)
    }

    
    private func filterDetail() {
        print("test")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
