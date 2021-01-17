//
//  Data.swift
//  FinalProject
//
//  Created by Jonathan Pang on 1/11/21.
//

import SwiftUI

// struct for user data
struct UserData: Codable {
    var username        = ""
    var email           = ""
    var password        = ""
    var confirmPassword = ""
    
    var cart = [CartServiceData]()
    
    static let example = [UserData](repeating: UserData(username: "Bob ", email: "bob@Bob.com", password: "123", confirmPassword: "123"), count: 5)
    static let example1 = example[0]
}

// struct for POST item service data
struct ItemServiceData: Codable, Hashable {
    var itemName           = ""
    var price              = ""
    var description        = ""
    var category           = ""
    var pictures: [String] = []
    
    static let example = [ItemServiceData](repeating: ItemServiceData(itemName: "item", price: "$1", description: "description", category: "category", pictures: ["Test","Pictures"]), count: 5)
    static let example1 = example[0]
}


// struct for cart service data 
struct CartServiceData: Codable {
    var id       = UUID()
    var itemName = ""
    var price    = ""
    var quantity = ""
    
    static let example = [CartServiceData](repeating: CartServiceData(id: UUID(), itemName: "Item", price: "1", quantity: "2"), count: 10)
}

struct CartItems: Codable {
    let cart: [cartItem]
    
    init() {
        cart = [cartItem]()
    }
}

struct Items: Codable {
    let items: [Item]
    
    init() {
        items = [Item]()
    }
}

struct cartItem: Codable, Hashable {
    var id, itemID, itemname: String
    var price: Double
    var quantity: Int
    var total: Double

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case itemID = "itemId"
        case itemname, price, quantity, total
    }
    
    init() {
        self.id = ""
        self.itemname = ""
        self.price = 0
        self.quantity = 0
        self.total = price * Double(quantity)
        self.itemID = ""
    }
}

struct Item: Codable, Hashable {
    let category: String
    let pictures: [String]
    let id, itemname: String
    let price: Double
    let itemDescription: String?
    let createdAt: String
    let v: Int

    enum CodingKeys: String, CodingKey {
        case category, pictures
        case id = "_id"
        case itemname, price
        case itemDescription = "description"
        case createdAt
        case v = "__v"
    }
    
    init() {
        self.id = ""
        self.itemname = ""
        self.itemDescription = ""
        self.category = ""
        self.pictures = [String]()
        self.price = 0
        self.createdAt = ""
        self.v = 0
    }
}
