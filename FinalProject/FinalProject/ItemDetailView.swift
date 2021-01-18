//
//  ItemDetailView.swift
//  FinalProject
//
//  Created by Eric Chen on 1/15/21.
//

import SwiftUI

struct ItemDetailView: View {
    @State var user: userJWT
    @State var item: Item
    @State var alertCart = false
    
    var body: some View {
        ScrollView{
            Text("\(item.itemname)")
                .font(.largeTitle)
                .padding()
            Text("image \(Image(systemName: "icloud.fill"))")
                .padding()
            Text("Description:")
                .font(.subheadline)
            VStack{
                Text("\(item.itemDescription ?? "")")
            }
            Spacer()
        }
        .navigationBarTitle("\(item.itemname)", displayMode: .inline)
        .navigationBarItems(trailing:
            customButton("Add to cart", width: UIScreen.main.bounds.width / 4)
                .onTapGesture {
                    print("Attempting to add to cart")
                    alertCart = true
                    POSTCart(user.JWT, id: item.id, itemname: item.itemname, price: item.price, quantity: 1, userId: user.userID) { (message) in
                        print(message)
                    }
                }
                .alert(isPresented: $alertCart) {
                    Alert(title: Text("Successfully added to cart"), message: nil, dismissButton: .default(Text("Dismiss")))
                }
        )
    }
}
