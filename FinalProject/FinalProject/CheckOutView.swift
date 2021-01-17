
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
    @State var dataValues = [String: [Any]]()
    
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
            var json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            dataValues["_id"] = []
            dataValues["itemId"] = []
            dataValues["itemname"] = []
            dataValues["price"] = []
            dataValues["quantity"] = []
            dataValues["total"] = []
            print(json["items"] ?? "")
            
            var count = 0
            while "\(String(describing: json["items"]!))".contains("total") {
                switch count%6 {
                case 0:
                    dataValues["_id"]!.append("\(String(describing: json["items"]!))"[("\(String(describing: json["items"]!))".index("\(String(describing: json["items"]!))".firstIndex(of: "=") ?? "\(String(describing: json["items"]!))".startIndex, offsetBy: 2))..<("\(String(describing: json["items"]!))".firstIndex(of: ";") ?? "\(String(describing: json["items"]!))".endIndex)])
                case 1:
                    dataValues["itemId"]!.append("\(String(describing: json["items"]!))"[("\(String(describing: json["items"]!))".index("\(String(describing: json["items"]!))".firstIndex(of: "=") ?? "\(String(describing: json["items"]!))".startIndex, offsetBy: 2))..<("\(String(describing: json["items"]!))".firstIndex(of: ";") ?? "\(String(describing: json["items"]!))".endIndex)])
                case 2:
                    dataValues["itemname"]!.append("\(String(describing: json["items"]!))"[("\(String(describing: json["items"]!))".index("\(String(describing: json["items"]!))".firstIndex(of: "=") ?? "\(String(describing: json["items"]!))".startIndex, offsetBy: 2))..<("\(String(describing: json["items"]!))".firstIndex(of: ";") ?? "\(String(describing: json["items"]!))".endIndex)])
                case 3:
                    dataValues["price"]!.append(Double("\(String(describing: json["items"]!))"[("\(String(describing: json["items"]!))".index("\(String(describing: json["items"]!))".firstIndex(of: "=") ?? "\(String(describing: json["items"]!))".startIndex, offsetBy: 2))..<("\(String(describing: json["items"]!))".firstIndex(of: ";") ?? "\(String(describing: json["items"]!))".endIndex)]) ?? 0)
                case 4:
                    dataValues["quantity"]!.append(Double("\(String(describing: json["items"]!))"[("\(String(describing: json["items"]!))".index("\(String(describing: json["items"]!))".firstIndex(of: "=") ?? "\(String(describing: json["items"]!))".startIndex, offsetBy: 2))..<("\(String(describing: json["items"]!))".firstIndex(of: ";") ?? "\(String(describing: json["items"]!))".endIndex)]) ?? 0)
                default:
                    dataValues["total"]!.append(Double("\(String(describing: json["items"]!))"[("\(String(describing: json["items"]!))".index("\(String(describing: json["items"]!))".firstIndex(of: "=") ?? "\(String(describing: json["items"]!))".startIndex, offsetBy: 2))..<("\(String(describing: json["items"]!))".firstIndex(of: ";") ?? "\(String(describing: json["items"]!))".endIndex)]) ?? 0)
                }
                json["items"] = "\(String(describing: json["items"]!))"[("\(String(describing: json["items"]!))".index(after: "\(String(describing: json["items"]!))".firstIndex(of: ";") ?? "\(String(describing: json["items"]!))".startIndex))..<"\(String(describing: json["items"]!))".endIndex]
                count += 1
            }
            // print(json["items"] ?? "")
            print(dataValues)
        }.resume()
    }
    
    func getArray(_ array: [Any]) -> [String] {
        var list = [String]()
        for element in array {
            list.append("\(element)")
        }
        return list
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
            ForEach(getArray(dataValues["itemname"] ?? []), id: \.self) { item in
                HStack{
                    
                    Text("\(item)")
                }
            }
            Spacer()
        }
        customButton("Check Out",width: UIScreen.main.bounds.width / 2, color: Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)))
            .onLongPressGesture {
                print("attempting to checkout...")
                GETCheckout(user.JWT, user.userID) { (message) in
                    screen.currentScreen = 5
                }
            }
        ForEach(cartitems.cart, id: \.self) { item in
            Text("\(item.itemname)")
        }
        Spacer()
        .onAppear(perform: start)
    }
}
