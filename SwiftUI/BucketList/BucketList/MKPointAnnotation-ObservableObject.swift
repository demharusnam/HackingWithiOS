//
//  MKPointAnnotation-ObservableObject.swift
//  BucketList
//
//  Created by Mansur Ahmed on 2020-05-15.
//  Copyright © 2020 Mansur Ahmed. All rights reserved.
//

import MapKit

extension MKPointAnnotation: ObservableObject {
    public var wrappedTitle: String {
        get {
            self.title ?? "Unknown title"
        }
        
        set {
            title = newValue
        }
    }
    
    public var wrappedSubtitle: String {
        get {
            self.subtitle ?? "Unknown subtitle"
        }
        
        set {
            subtitle = newValue
        }
    }
}
