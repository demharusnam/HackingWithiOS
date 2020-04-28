//
//  Order.swift
//  CupcakeCorner
//
//  Created by Mansur Ahmed on 2020-04-26.
//  Copyright © 2020 Mansur Ahmed. All rights reserved.
//

import SwiftUI

class Order: ObservableObject, Codable {
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    @Published var data = OrderData()
    
    struct OrderData: Codable {
        var type = 0
        var quantity = 3
        
        var specialRequestEnabled = false {
            didSet {
                if specialRequestEnabled == false {
                    extraFrosting = false
                    addSprinkles = false
                }
            }
        }
        
        var extraFrosting = false
        var addSprinkles = false

        var name = ""
        var streetAddress = ""
        var city = ""
        var zip = ""
    }
    
    var hasValidAddress: Bool {
        if data.name.isEmptyWhitespace || data.streetAddress.isEmptyWhitespace || data.city.isEmptyWhitespace || data.zip.isEmptyWhitespace {
            return false
        }
        return true
    }
    
    var cost: Double {
        var cost = Double(data.quantity) * 2
        
        cost += (Double(data.type) / 2)
        
        if data.extraFrosting {
            cost += Double(data.quantity)
        }
        
        if data.addSprinkles {
            cost += Double(data.quantity) / 2
        }
        
        return cost
    }
    
    enum CodingKeys: CodingKey {
        case data
        //case type, quantity, extraFrosting, addSprinkles, name, streetAddress, city, zip
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(data, forKey: .data)
        /*try container.encode(type, forKey: .type)
        try container.encode(quantity, forKey: .quantity)
        
        try container.encode(extraFrosting, forKey: .extraFrosting)
        try container.encode(addSprinkles, forKey: .addSprinkles)
        
        try container.encode(name, forKey: .name)
        try container.encode(streetAddress, forKey: .streetAddress)
        try container.encode(city, forKey: .city)
        try container.encode(zip, forKey: .zip)*/
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        data = try container.decode(OrderData.self, forKey: .data)
        
        /*type = try container.decode(Int.self, forKey: .type)
        quantity = try container.decode(Int.self, forKey: .quantity)
        
        extraFrosting = try container.decode(Bool.self, forKey: .extraFrosting)
        addSprinkles = try container.decode(Bool.self, forKey: .addSprinkles)
        
        name = try container.decode(String.self, forKey: .name)
        streetAddress = try container.decode(String.self, forKey: .streetAddress)
        city = try container.decode(String.self, forKey: .city)
        zip = try container.decode(String.self, forKey: .zip)*/
    }
    
    init() {}
}
