//
//  CustomButtons.swift
//  FinalProject
//
//  Created by Eric Chen on 1/11/21.
//

import SwiftUI

// premade skyblue button
func skyBlueButton(_ message: String, width: CGFloat = 55, height: CGFloat = 30) -> some View {
    Text(message)
        .font(.system(size: 14))
        .frame(width: width, height: height)
        .foregroundColor(Color.black)
        .background(Color(#colorLiteral(red: 0.3703883588, green: 0.7203393579, blue: 0.9554411769, alpha: 1)))
        .clipShape(RoundedRectangle(cornerRadius: 16.0, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
        .shadow(color: Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)) ,radius: 10, x: 6, y: 4)
}

// premade white button
func whiteButton(_ message: String, width: CGFloat = 55, height: CGFloat = 30) -> some View {
    Text(message)
        .font(.system(size: 14))
        .frame(width: width, height: height)
        .foregroundColor(Color.black)
        .background(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
        .clipShape(RoundedRectangle(cornerRadius: 16.0, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
        .shadow(color: Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)), radius: 10, x: 6, y: 4)
}

// custom button
func customButton(_ message: String, width: CGFloat = 55, height: CGFloat = 30, color: Color = Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))) -> some View {
    Text(message)
        .font(.system(size: 14))
        .frame(width: width, height: height)
        .foregroundColor(Color.black)
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: 16.0, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
        .shadow(color: Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)), radius: 10, x: 6, y: 4)
}

// response for signing up
struct ResponseSignup: Codable {
    var message: String
}

struct ResponseDelete: Codable {
    var message: String
}

// response for logging in
struct ResponseLogin: Codable{
    var message: String
    var token: String
    var user: userDetails
}

// helper struct for ResponseLogin
struct userDetails: Codable{
    var id: String
    var username: String
    var isAdmin: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case username, isAdmin
    }
}

// response for getting the token for a user's account
class userJWT: Codable, ObservableObject{
    var JWT      = ""
    var username = ""
    var isAdmin  = false
    var userID   = ""
}

// login function
func login(email: String, password: String, completion: @escaping (ResponseLogin) -> () ) {
    let jsonBody = "email=\(email)&password=\(password)"
    let link = "https://hkp-training-teamprj.herokuapp.com/users/login"
    guard let url = URL(string: link) else { return }
    var request = URLRequest(url: url)
    let header = ["Content-type" : "application/x-www-form-urlencoded"]
    request.allHTTPHeaderFields = header
    request.httpMethod = "POST"
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-type")
    let requestBody = NSMutableData(data: jsonBody.data(using: String.Encoding.utf8)!)
    request.httpBody = requestBody as Data
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else { return }
        if let decoded = try? JSONDecoder().decode(ResponseLogin.self, from: data) {
            DispatchQueue.main.async {
                completion(decoded)
            }
        }
    }.resume()
}

// signup func
func signup(username: String, email: String, password: String, confirmPassword: String , completion: @escaping (String) -> () ) {
    let jsonBody = "username=\(username)&email=\(email)&password=\(password)&confirmPassword=\(password)"
    let link = "https://hkp-training-teamprj.herokuapp.com/users/signup"
    guard let url = URL(string: link) else { return }
    var request = URLRequest(url: url)
    let header = ["Content-type" : "application/x-www-form-urlencoded"]
    request.allHTTPHeaderFields = header
    request.httpMethod = "POST"
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-type")
    let requestBody = NSMutableData(data: jsonBody.data(using: String.Encoding.utf8)!)
    request.httpBody = requestBody as Data
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else { return }
        if let decoded = try? JSONDecoder().decode(ResponseSignup.self, from: data) {
            DispatchQueue.main.async {
                completion(decoded.message)
            }
        }
    }.resume()
}

func login1(email: String, password: String, completion: @escaping (ResponseLogin) -> () ) {
    let jsonBody: [String: String] = [
        "email": email,
        "password": password
    ]
    let link = "https://hkp-training-teamprj.herokuapp.com/users/login"
    guard let url = URL(string: link) else { return }
    var request = URLRequest(url: url)
     
    let finalBody = try! JSONSerialization.data(withJSONObject: jsonBody)

    request.httpMethod = "POST"
    request.httpBody = finalBody
    
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else { return }
        if let decoded = try? JSONDecoder().decode(ResponseLogin.self, from: data) {
            DispatchQueue.main.async {
                completion(decoded)
            }
        }
    }.resume()
}

// POST Items func *USE JWT FROM LOGIN1 FUNC AND REQUIRES ADMIN ACCOUNT
func POSTItems(_ token: String, _ itemname: String, _ price: String, _ description: String, _ category: String, _ pictures: [String], completion: @escaping (String) -> ()) {
    let link = "https://hkp-training-teamprj.herokuapp.com/items"
    guard let url = URL(string: link) else { return }
    var request = URLRequest(url: url)
    let boundary = "myboundary"
    let lineBreak = "\r\n"
    let header = [
        "Content-Type": "multipart/form-data; boundary=\(boundary)",
        "Authorization": "\(token)"
    ]
    request.allHTTPHeaderFields = header
    request.httpMethod = "POST"
    var jsonBody = Data()
    jsonBody.appendString("--\(boundary + lineBreak)")
    jsonBody.appendString("Content-Disposition: form-data; name=\"itemname\"\r\n\r\n")
    jsonBody.appendString("\(itemname)\r\n")
    jsonBody.appendString("--\(boundary + lineBreak)")
    jsonBody.appendString("Content-Disposition: form-data; name=\"price\"\r\n\r\n")
    jsonBody.appendString("\(price)\r\n")
    jsonBody.appendString("--\(boundary + lineBreak)")
    jsonBody.appendString("Content-Disposition: form-data; name=\"description\"\r\n\r\n")
    jsonBody.appendString("\(description)\r\n")
    jsonBody.appendString("--\(boundary + lineBreak)")
    jsonBody.appendString("Content-Disposition: form-data; name=\"category\"\r\n\r\n")
    jsonBody.appendString("\(category)\r\n")
    for picture in pictures {
        jsonBody.appendString("--\(boundary + lineBreak)")
        jsonBody.appendString("Content-Disposition: form-data; pictures=\(picture + lineBreak)")
        jsonBody.appendString(lineBreak)
        jsonBody.appendString(picture)
    }
    jsonBody.appendString("--\(boundary)--\(lineBreak)")
    let str = String(decoding: jsonBody, as: UTF8.self)
    request.httpBody = jsonBody
    request.setValue(String(jsonBody.count), forHTTPHeaderField: "Content-Length")
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else { return }
        let str2 = String(decoding: data, as: UTF8.self)
        if let decoded = try? JSONDecoder().decode(ResponseSignup.self, from: data) {
            DispatchQueue.main.async {
                completion(decoded.message)
            }
        }
    }.resume()
}

func DELETEItem(_ token: String, _ id: String, completion: @escaping (String) -> () ) {
    let link = "https://hkp-training-teamprj.herokuapp.com/items/\(id)"
    guard let url = URL(string: link) else { return }
    var request = URLRequest(url: url)
    request.httpMethod = "DELETE"
    request.setValue("\(token)", forHTTPHeaderField: "Authorization")
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else { return }
        if let decoded = try? JSONDecoder().decode(ResponseDelete.self, from: data) {
            DispatchQueue.main.async {
                completion(decoded.message)
            }
        }
    }.resume()
}


extension Data {
    mutating func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}

func POSTCart(_ token: String, id: String, itemname: String, price: Double, quantity: Int, userId: String, completion: @escaping (String) -> () ) {
    let jsonBody = "_id=\(id)&itemname=\(itemname)&price=\(price)&quantity=\(quantity)"
    let link = "https://hkp-training-teamprj.herokuapp.com/users/\(userId)/cart-items"
    guard let url = URL(string: link) else { return }
    var request = URLRequest(url: url)
    let header = [
        "Content-type" : "application/x-www-form-urlencoded",
        "Authorization": "\(token)"
    ]
    request.allHTTPHeaderFields = header
    request.httpMethod = "POST"
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-type")
    let requestBody = NSMutableData(data: jsonBody.data(using: String.Encoding.utf8)!)
    request.httpBody = requestBody as Data
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else { return }
        if let decoded = try? JSONDecoder().decode(ResponseSignup.self, from: data) {
            DispatchQueue.main.async {
                completion(decoded.message)
            }
        }
    }.resume()
}

func GETCheckout(_ token: String, _ id: String, completion: @escaping (ResponseSignup) -> () ) {
    let link = "https://hkp-training-teamprj.herokuapp.com/users/\(id)/cart-items/checkout"
    guard let url = URL(string: link) else { return }
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = [
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "\(token)"
    ]
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else { return }
        if let decoded = try? JSONDecoder().decode(ResponseSignup.self, from: data) {
            DispatchQueue.main.async {
                completion(decoded)
            }
        }
    }.resume()
}

func DELETECart(_ token: String, _ id: String, _ itemId: String, completion: @escaping (String) -> () ) {
    let link = "https://hkp-training-teamprj.herokuapp.com/users/\(id)/cart-items/\(itemId)"
    guard let url = URL(string: link) else { return }
    var request = URLRequest(url: url)
    request.httpMethod = "DELETE"
    request.allHTTPHeaderFields = [
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "\(token)}"
    ]
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else { return }
        if let decoded = try? JSONDecoder().decode(ResponseDelete.self, from: data) {
            DispatchQueue.main.async {
                completion(decoded.message)
            }
        }
    }.resume()
}
