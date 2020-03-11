//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Rock Zhou on 2020-03-09.
//  Copyright © 2020 Rock Zhou. All rights reserved.
//

import SwiftUI

struct CheckoutView: View {
  @ObservedObject var order: Order
  @State private var confirmationMessage = ""
  @State private var alertTitle = ""
  @State private var showingConfirmation = false
  
  var body: some View {
    GeometryReader { geo in
      ScrollView {
        VStack {
          Image("cupcakes")
            .resizable()
            .scaledToFit()
            .frame(width: geo.size.width)

          Text("Your total is $\(self.order.cost, specifier: "%.2f")")
            .font(.title)

          Button("Place Order") {
            self.placeOrder()
          }
          .padding()
        }
      }
    }
    .navigationBarTitle("Checkout", displayMode: .inline)
    .alert(isPresented: $showingConfirmation) {
        Alert(
          title: Text(alertTitle),
          message: Text(confirmationMessage),
          dismissButton: .default(Text("OK"))
      )
    }
  }
  
  func placeOrder() {
    guard let encoded = try? JSONEncoder().encode(order) else {
      print("Failed to encode order")
      return
    }
    
    let url = URL(string: "https://reqres.in/api/cupcakes")!
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    request.httpBody = encoded
    
    URLSession.shared.dataTask(with: request) { data, response, error in
      // we reset data here because the new one is type Data, where the original is type Data?
      guard let data = data else {
        print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
        guard let error = error else {
          return
        }
        self.alertTitle = "Ooops!"
        self.confirmationMessage = "\(error.localizedDescription)"
        self.showingConfirmation = true
        return
      }
      
      if let decodedOrder = try? JSONDecoder().decode(Order.self, from: data) {
        self.alertTitle = "Thank You!"
        self.confirmationMessage = "Your order for \(decodedOrder.orderDetails.quantity)x \(decodedOrder.orderDetails.type.rawValue.lowercased()) cupcakes is on its way!"
        self.showingConfirmation = true
      }
    }.resume()
  }
}

struct CheckoutView_Previews: PreviewProvider {
  static var previews: some View {
    CheckoutView(order: Order())
  }
}
