//
//  AdminView.swift
//  FinalProject
//
//  Created by Eric Chen on 1/12/21.
//

import SwiftUI

struct AdminView: View {
    @ObservedObject var screen: CurrentScreen
    @ObservedObject var user: userJWT
    @State var itemName = ""
    @State var itemPrice = ""
    @State var itemDesc = ""
    @State var itemCat = ""
    @State var itemPics = [String]()
    @State var showingAlert        = false
    @State var alertTitle          = ""
    @State var alertMessage        = ""
    @State var items = Items()
    
    func start() {
        GETItemsList(jwt: user.JWT, completion: { _ in })
    }
    
    func GETItemsList(jwt: String, completion: @escaping (String) -> () ) {
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
            }
            
        }.resume()
    }
    
    var body: some View {
        Text("Welcome, \(user.username)")
            .padding()
        if itemName.count > 0 && itemPrice.count > 0 {
            Text("\(itemName) - $\(itemPrice)")
        }
        else if itemName.count < 0 {
            Text("\(itemPrice)")
        }
        else if itemPrice.count < 0 {
            Text("\(itemName)")
        }
        VStack(spacing: UIScreen.main.bounds.height / 128) {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.black, lineWidth: 1)
                    .frame(width: UIScreen.main.bounds.width / 16 * 12, height: UIScreen.main.bounds.height / 24)
                TextField("Item Name: ", text: $itemName)
                    .frame(width: UIScreen.main.bounds.width / 16 * 11, height: UIScreen.main.bounds.height / 24)
                    .autocapitalization(.none)
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.black, lineWidth: 1)
                    .frame(width: UIScreen.main.bounds.width / 16 * 12, height: UIScreen.main.bounds.height / 24)
                TextField("Item Price: ", text: $itemPrice)
                    .frame(width: UIScreen.main.bounds.width / 16 * 11, height: UIScreen.main.bounds.height / 24)
                    .autocapitalization(.none)
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.black, lineWidth: 1)
                    .frame(width: UIScreen.main.bounds.width / 16 * 12, height: UIScreen.main.bounds.height / 24)
                TextField("Item Description: ", text: $itemDesc)
                    .frame(width: UIScreen.main.bounds.width / 16 * 11, height: UIScreen.main.bounds.height / 24)
                    .autocapitalization(.none)
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.black, lineWidth: 1)
                    .frame(width: UIScreen.main.bounds.width / 16 * 12, height: UIScreen.main.bounds.height / 24)
                TextField("Item Category: ", text: $itemCat)
                    .frame(width: UIScreen.main.bounds.width / 16 * 11, height: UIScreen.main.bounds.height / 24)
                    .autocapitalization(.none)
            }
            
            skyBlueButton("FINISH ADDING ITEM", width: UIScreen.main.bounds.width / 8 * 5, height: UIScreen.main.bounds.height / 24)
                .onTapGesture {
                    if (!itemName.isEmpty && !itemPrice.isEmpty) {
                        POSTItems(user.JWT, self.itemName, self.itemPrice, self.itemDesc, self.itemCat, self.itemPics) { (message) in
                            print("items added")
                            alertMessage = "Successfully added item"
                            showingAlert.toggle()
                            start()
                        }
                    }
                    else {
                        print("could not add item")
                        alertMessage = "Please fill in the blanks"
                        showingAlert.toggle()
                    }
                }
            Spacer()
            List {
                ForEach(items.items, id: \.self) { item in
                    HStack {
                        Text("\(item.itemname)")
                        Spacer()
                        whiteButton("Remove", width: UIScreen.main.bounds.width / 5, height: UIScreen.main.bounds.height / 36)
                            .onTapGesture {
                                print("\n \n \n deleting ... \n \n \n")
                                DELETEItem(user.JWT, item.id) { (message) in }
                                print("deleted!")
                                alertMessage = "Item deleted"
                                showingAlert.toggle()
                                start()
                            }

                    }
                }
            }
            Spacer()
            customButton("Log Out", width: UIScreen.main.bounds.width / 5, height: UIScreen.main.bounds.height / 36, color: Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                .onTapGesture {
                    screen.currentScreen = 0
                }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(alertMessage), message: nil, dismissButton: .default(Text("Dismiss")))
        }
        .onAppear(perform: start)
    }
}




struct AdminView_Previews: PreviewProvider {
    @ObservedObject static var screen = CurrentScreen()
    @ObservedObject static var user = userJWT()
    
    static var previews: some View {
        AdminView(screen: screen, user: user)
    }
}

