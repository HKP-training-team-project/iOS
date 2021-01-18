//
//  ItemDetailView.swift
//  FinalProject
//
//  Created by Eric Chen on 1/15/21.
//

import SwiftUI

struct ItemDetailView: View {
    @ObservedObject var screen: CurrentScreen
    @State var user: userJWT
    @State var item: Item
    @State var alertCart = false
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Image(systemName: "chevron.left")
                    .onTapGesture {
                        screen.currentScreen = 2
                    }
                    .offset(x: UIScreen.main.bounds.width / 64 * 3)
                Spacer()
                customButton("Add to cart", width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.height / 30)
                    .onTapGesture {
                        alertCart = true
                        POSTCart(user.JWT, id: item.id, itemname: item.itemname, price: item.price, quantity: 1, userId: user.userID) { _ in }
                    }
                    .offset(x: UIScreen.main.bounds.width / 64 * -3)
                    .alert(isPresented: $alertCart) {
                        Alert(title: Text("Successfully added to cart"), message: nil, dismissButton: .default(Text("Dismiss")))
                    }
            }
            HStack {
                Text("\(item.itemname)")
                    .font(.largeTitle)
                    .padding()
                Spacer()
            }
            ZStack {
                VStack {
                    customButton("", width: UIScreen.main.bounds.width / 8 * 7, height: UIScreen.main.bounds.height / 14, color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                    Spacer()
                }
                VStack {
                    HStack {
                        Text("Description: ")
                            .font(.system(size: 14))
                            .offset(x: UIScreen.main.bounds.width / 64 * 6, y: UIScreen.main.bounds.height / 64)
                        Spacer()
                    }
                    HStack {
                        Text("\(item.itemDescription ?? "")")
                            .font(.system(size: 14))
                            .offset(x: UIScreen.main.bounds.width / 64 * 6, y: UIScreen.main.bounds.height / 64)
                        Spacer()
                    }
                    
                    Spacer()
                }
            }
            Spacer()
        }
    }
}
