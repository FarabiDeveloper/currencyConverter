//
//  Convert.swift
//  Currency Converter
//
//  Created by Farabi on 26.06.2018.
//  Copyright © 2018 FarabiCorporation. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Convert: Decodable  {
    public var success: Bool
    public var timestamp: Int
    public var base: String
    public var date: String
    public var rates: [String : Double]
    
    init() {
        self.success = false
        self.timestamp = 0
        self.base = "EUR"
        self.date = "-1"
        self.rates = [String : Double]()
    }
}
