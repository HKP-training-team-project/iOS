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
            print(response!)
            print(data!)
            guard let data = data else { return }
            if let decoded = try? JSONDecoder().decode(Items.self, from: data) {
                items = decoded
                for item in items.items {
                    print(item.itemname)
                }
                DispatchQueue.main.async {
                    // completion(decoded.items[0].id)
                }
            }
            
        }.resume()
    }

    
    
    var body: some View {
        NavigationView {
            Section {
                HStack{
                    Text("Hello, \(user.username)")
                        .font(.subheadline)
                        .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                        .padding(.horizontal)
                        Spacer()
                }
                VStack {
                    Form {
                        Text("Your ID is: \(user.userID)")
                        ForEach(items.items, id: \.self) { item in
                            NavigationLink(
                                destination: ItemDetailView(user: user, item:item ),
                                label: {
                                    HStack{
                                        Text(item.itemname)
                                        Spacer()
                                        Text("$\(item.price , specifier: "%.2f")")
                                    }
                                })
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

/*
struct ShopView_Previews: PreviewProvider {
    @ObservedObject var screen: CurrentScreen
    static var previews: some View {
        ShopView(user: UserData.example1, items: ItemServiceData.example, screen: screen )
    }
}
 */
