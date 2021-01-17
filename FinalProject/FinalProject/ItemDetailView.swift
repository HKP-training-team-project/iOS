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
        .navigationBarItems(leading:
            whiteButton("Add to cart")
                .onTapGesture {
                    print("Attempting to add to cart")
                    
                    POSTCart(user.JWT, id: item.id, itemname: item.itemname, price: item.price, quantity: 2, userId: user.userID) { (message) in
                        print(message)
                    }
                }
        )
    }
}


/*
struct ItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ItemDetailView(item: )
    }
}
 */
