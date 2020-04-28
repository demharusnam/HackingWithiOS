//
//  String.swift
//  CupcakeCorner
//
//  Created by Mansur Ahmed on 2020-04-28.
//  Copyright © 2020 Mansur Ahmed. All rights reserved.
//


extension String {
    var isEmptyWhitespace: Bool {
        return self.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
