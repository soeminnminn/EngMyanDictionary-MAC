//
//  BindingExtension.swift
//  engmyan
//
//  Created by Soe Minn Minn on 10/4/18.
//  Copyright © 2018 S16. All rights reserved.
//

import Foundation
import SQLite

extension Binding {
    
    public var stringValue: String? {
        return self as? String
    }
    
    public var boolValue: Bool? {
        return Int("\(self)") == 1 || "\(self)".lowercased() == "true"
    }
    
    public var intValue: Int? {
        return self as? Int
    }
    
    public var int8Value: Int8? {
        return self as? Int8
    }
    
    public var int16Value: Int16? {
        return self as? Int16
    }
    
    public var int32Value: Int32? {
        return self as? Int32
    }
    
    public var int64Value: Int64? {
        return self as? Int64
    }
    
    public var floatValue: Float? {
        return self as? Float
    }
    
    public var doubleValue: Double? {
        return self as? Double
    }
    
    public var float32Value: Float32? {
        return self as? Float32
    }
    
    public var float64Value: Float64? {
        return self as? Float64
    }
    
    public var float80Value: Float80? {
        return self as? Float80
    }
    
}
