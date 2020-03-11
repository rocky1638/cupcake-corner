//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Rock Zhou on 2020-03-09.
//  Copyright © 2020 Rock Zhou. All rights reserved.
//

import SwiftUI

struct ContentView: View {
  @ObservedObject var order = Order()
  
  
  var body: some View {
    NavigationView {
      Form {
        Section {
          Picker("Select your cake type", selection: $order.orderDetails.type) {
            // USE SELF FOR ID, ONLY WAY IT WORKS (DON'T USE RAWVALUE)
            ForEach(Flavour.allCases, id: \.self) { flavour in
              Text(flavour.rawValue)
            }
          }

          Stepper(value: $order.orderDetails.quantity, in: 3...20) {
            Text("Number of cakes: \(order.orderDetails.quantity)")
          }
        }
        
        Section {
          Toggle(isOn: $order.orderDetails.specialRequestEnabled.animation()) {
            Text("Any special requests?")
          }
          
          if order.orderDetails.specialRequestEnabled {
            Toggle(isOn: $order.orderDetails.extraFrosting) {
              Text("Add extra frosting")
            }

            Toggle(isOn: $order.orderDetails.addSprinkles) {
              Text("Add extra sprinkles")
            }
          }
        }
        
        Section {
          NavigationLink(destination: AddressView(order: order)) {
            Text("Delivery details")
          }
        }
      }
      .navigationBarTitle("Cupcake Corner")
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
