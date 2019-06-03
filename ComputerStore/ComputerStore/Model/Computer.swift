//
//  Computer.swift
//  ComputerStore
//
//  Created by Ali Rahal on 5/31/19.
//  Copyright © 2019 Ali Rahal. All rights reserved.
//

import Foundation

class Computer: NSObject, Codable {
    var _id: String?
    var name: String?
    var price: Float?
    var brand: String?
    var modelNumber: String?
    var imageURL: String?
    var cpu: String?
    var rams: Int?
}
