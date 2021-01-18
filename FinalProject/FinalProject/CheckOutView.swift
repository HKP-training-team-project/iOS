
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
    @State var ids = [String]()
    @State var itemids = [String]()
    @State var itemnames = [String]()
    @State var prices = [Double]()
    @State var quantities = [Double]()
    @State var totals = [Double]()
    
    func start() {
        GETCart(user.JWT, user.userID, completion: { _ in })
        ids = self.getStringArray(dataValues["_id"] ?? [])
        itemids = self.getStringArray(dataValues["itemids"] ?? [])
        itemnames = self.getStringArray(dataValues["itemnames"] ?? [])
        prices = self.getDoubleArray(dataValues["price"] ?? [])
        quantities = self.getDoubleArray(dataValues["quantity"] ?? [])
        totals = self.getDoubleArray(dataValues["total"] ?? [])
    }
    
    func GETCart(_ token: String, _ id: String, completion: @escaping (ResponseLogin) -> () ) {
        let link = "https://hkp-training-teamprj.herokuapp.com/users/\(id)/cart-items"
        guard let url = URL(string: link) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
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
            print(dataValues)
        }.resume()
    }
    
    func getStringArray(_ array: [Any]) -> [String] {
        var list = [String]()
        for element in array {
            list.append("\(element)")
        }
        return list
    }
    
    func getDoubleArray(_ array: [Any]) -> [Double] {
        var list = [Double]()
        for element in array {
            list.append(Double("\(element)") ?? 0)
        }
        return list
    }

    
    var body: some View {
        VStack(spacing: UIScreen.main.bounds.height / 64) {
            HStack {
                Image(systemName: "chevron.left")
                    .onTapGesture {
                        screen.currentScreen = 2
                    }
                    .offset(x: UIScreen.main.bounds.width / 64 * 3)
                Spacer()
            }
            HStack {
                Text("Checkout")
                    .font(.system(size: UIScreen.main.bounds.height / 128 * 5))
                    .fontWeight(.bold)
                    .offset(x: UIScreen.main.bounds.width / 64 * 3)
                Spacer()
            }
            Form {
                ForEach(0..<getStringArray(dataValues["itemname"] ?? []).count) { index in
                    HStack {
                        Text(getStringArray(dataValues["itemname"] ?? [])[index])
                        Spacer()
                        Text("$\(getDoubleArray(dataValues["total"] ?? [])[index], specifier: "%.2f")")
                    }
                }
            }
        }
        Spacer()
        customButton("Check Out",width: UIScreen.main.bounds.width / 2, color: Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)))
            .onLongPressGesture {
                print("attempting to checkout...")
                GETCheckout(user.JWT, user.userID) { (message) in
                    screen.currentScreen = 5
                }
            }
            .offset(y: UIScreen.main.bounds.height / 64)
        Spacer()
        .onAppear(perform: start)
    }
}
