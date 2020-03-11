//
//  Order.swift
//  CupcakeCorner
//
//  Created by Rock Zhou on 2020-03-09.
//  Copyright © 2020 Rock Zhou. All rights reserved.
//

import Foundation

enum Flavour: String, CaseIterable, Codable {
  case Vanilla = "Vanilla"
  case Strawberry = "Strawberry"
  case Chocolate = "Chocolate"
  case Rainbow = "Rainbow"
}

class Order: Codable, ObservableObject {
  enum CodingKeys: CodingKey {
    case orderDetails
  }
  
  struct OrderDetails: Codable {
    struct Address: Codable {
      var name = ""
      var streetAddress = ""
      var city = ""
      var zip = ""
    }
    
    var type: Flavour = Flavour.Vanilla
    var quantity: Int = 3
    var extraFrosting: Bool = false
    var addSprinkles: Bool = false
    var address: Address = Address()
    var specialRequestEnabled: Bool = false {
      didSet {
        if specialRequestEnabled == false {
          extraFrosting = false
          addSprinkles = false
        }
      }
    }
  }
  
  @Published var orderDetails = OrderDetails()
  
  /* Methods */
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(orderDetails, forKey: .orderDetails)
  }
  
  // default constructor
  init() {}
  
  // alternate constructor that takes a decoder (init from decoding)
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    orderDetails = try container.decode(OrderDetails.self, forKey: .orderDetails)
  }
  
  /* Computed Properties */
  
  var hasValidAddress: Bool {
    if orderDetails.address.name.isEmpty
      || orderDetails.address.streetAddress.isEmpty
      || orderDetails.address.city.isEmpty
      || orderDetails.address.zip.isEmpty
    {
      return false
    }

    return true
  }
  
  var cost: Double {
    // $2 per cake
    var cost = Double(orderDetails.quantity) * 2

    // rainbow cakes cost more
    if orderDetails.type == Flavour.Rainbow {
      cost += 1
    }

    // $1/cake for extra frosting
    if orderDetails.extraFrosting {
      cost += Double(orderDetails.quantity)
    }

    // $0.50/cake for sprinkles
    if orderDetails.addSprinkles {
      cost += Double(orderDetails.quantity) / 2
    }

    return cost
  }
}
