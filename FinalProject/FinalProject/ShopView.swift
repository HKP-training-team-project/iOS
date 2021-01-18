//
//  ShopView.swift
//  FinalProject
//
//  Created by Eric Chen on 1/12/21.
//

import SwiftUI

struct ShopView: View {
    @ObservedObject var screen: CurrentScreen
    @ObservedObject var user: userJWT
    @State var items = Items()
    @ObservedObject var pass: passItem
    
    func start() {
        GETItems(jwt: user.JWT, completion: { _ in })
    }
    
    func GETItems(jwt: String, completion: @escaping (String) -> () ) {
        let link = "https://hkp-training-teamprj.herokuapp.com/items"
        guard let url = URL(string: link) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("\(jwt)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            if let decoded = try? JSONDecoder().decode(Items.self, from: data) {
                items = decoded
                DispatchQueue.main.async {
                    // completion(decoded.items[0].id)
                }
            }
        }.resume()
    }
    
    var body: some View {
        NavigationView {
            Section {
                HStack {
                    Text("Hello, \(user.username)")
                        .font(.subheadline)
                        .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                        .padding(.horizontal)
                        Spacer()
                }
                VStack {
                    Form {
                        ForEach(items.items, id: \.self) { item in
                            HStack {
                                Text(item.itemname)
                                Spacer()
                                Text("$\(item.price, specifier: "%.2f")")
                                Image(systemName: "chevron.right")
                                    .onTapGesture {
                                        pass.item = item
                                        screen.currentScreen = 6
                                    }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Shop")
            .navigationBarItems(leading: Button(action: {
                screen.currentScreen = 0
            }, label: {
                Text("Log Out")
                    .accentColor(Color.black)
            }), trailing: Button(action: {
                screen.currentScreen = 3
            }, label: {
                Image(systemName: "cart.fill")
                    .accentColor(Color.black)
            }))
        }
        .onAppear(perform: start)
    }
}
