
// CheckOutView.swift
// FinalProject
//
// Created by Eric Chen on 1/12/21.
//

import SwiftUI
struct CheckOutView: View {
  @ObservedObject var screen: CurrentScreen
  @ObservedObject var user: userJWT
  @State var cartitems = CartItems()
  func start() {
    GETCart(user.JWT, user.userID, completion: { _ in })
  }
  func GETCart(_ token: String, _ id: String, completion: @escaping (ResponseLogin) -> () ) {
    let link = "https://hkp-training-teamprj.herokuapp.com/users/\(id)/cart-items"
    guard let url = URL(string: link) else { return }
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = [
      // "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": "\(token)"
    ]
    URLSession.shared.dataTask(with: request) { data, response, error in
      print("\n \n \n \n \n \n \n \n \n \n ")
      print(response!)
      guard let data = data else { return }
      print("attempting to decode")
      print("\(link)")
      print(data)
      if let decoded = try? JSONDecoder().decode(CartItems.self, from: data) {
        print("\n \n \n \n \n \n Inside decoded \n \n \n \n \n \n ")
        //print(decoded.message)
        cartitems = decoded
        for item in cartitems.cart {
          print(item.itemname)
        }
        DispatchQueue.main.async {
          // completion(decoded)
        }
      }
    }.resume()
  }
  var body: some View {
    VStack {
      HStack {
        Image(systemName: "chevron.left")
          .padding()
          .onTapGesture {
            screen.currentScreen = 2
          }
        Spacer()
      }
      Text("\(user.userID)")
        ForEach(cartitems.cart, id: \.self) { item in
          HStack{
            Text("\(item.itemname)")
            Spacer()
            Text("\(item.quantity)")
          }
      }
      Spacer()
    }
    Text("Hi")
    ForEach(cartitems.cart, id: \.self) { item in
      Text("\(item.itemname ?? "")")
    }
    Spacer()
      .onAppear(perform: start)
  }
}
/*
struct CheckOutView_Previews: PreviewProvider {
  static var previews: some View {
    CheckOutView(cart: CartServiceData.example)
  }
}
*/
