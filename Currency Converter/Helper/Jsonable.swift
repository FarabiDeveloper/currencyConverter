//
//  Jsonable.swift
//  Currency Converter
//
//  Created by Farabi on 27.06.2018.
//  Copyright © 2018 FarabiCorporation. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol Jsonable {
    init?(json: JSON)
    func json() -> JSON
}
