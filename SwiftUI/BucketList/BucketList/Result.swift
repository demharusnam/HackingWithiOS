//
//  Result.swift
//  BucketList
//
//  Created by Mansur Ahmed on 2020-05-15.
//  Copyright © 2020 Mansur Ahmed. All rights reserved.
//

struct Result: Codable {
    let query: Query
}

struct Query: Codable {
    let pages: [Int: Page]
}

struct Page: Codable, Comparable {
    let pageid: Int
    let title: String
    let terms: [String: [String]]?
    
    var description: String {
        terms?["description"]?.first ?? "No further information"
    }
    
    static func < (lhs: Page, rhs: Page) -> Bool {
        lhs.title < rhs.title
    }
}
