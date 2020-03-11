//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Rock Zhou on 2020-03-09.
//  Copyright © 2020 Rock Zhou. All rights reserved.
//

import SwiftUI

struct AddressView: View {
  @ObservedObject var order: Order

  var body: some View {
    Form {
      Section {
        TextField("Name", text: $order.orderDetails.address.name)
        TextField("Street Address", text: $order.orderDetails.address.streetAddress)
        TextField("City", text: $order.orderDetails.address.city)
        TextField("Zip", text: $order.orderDetails.address.zip)
      }

      Section {
        NavigationLink(destination: CheckoutView(order: order)) {
          Text("Check out")
        }
      }
      .disabled(!order.hasValidAddress)
    }
    .navigationBarTitle("Delivery details", displayMode: .inline)
  }
}

struct AddressView_Previews: PreviewProvider {
  static var previews: some View {
    AddressView(order: Order())
  }
}
