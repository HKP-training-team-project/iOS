//
//  LoginView.swift
//  FinalProject
//
//  Created by Jonathan Pang on 1/11/21.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var screen: CurrentScreen
    @ObservedObject var user: userJWT
    @State var email    = ""
    @State var password = ""
    @State var secure   = true
    
    var body: some View {
        VStack(alignment: .center, spacing: UIScreen.main.bounds.height / 512 * 3) {
            ZStack{
                customButton("", width: UIScreen.main.bounds.width / 8 * 7, height: UIScreen.main.bounds.height / 8 * 2, color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                VStack {
                    //username Field
                    HStack {
                        Text("Email:")
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.width / 16 * 12, height: UIScreen.main.bounds.height / 48)
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.black, lineWidth: 1)
                            .frame(width: UIScreen.main.bounds.width / 16 * 12, height: UIScreen.main.bounds.height / 24)
                        TextField("Email: ", text: $email)
                            .autocapitalization(.none)
                            .font(.system(size: 16))
                            .multilineTextAlignment(.leading)
                            .frame(width: UIScreen.main.bounds.width / 16 * 11, height: UIScreen.main.bounds.height / 24)
                    }
                    
                    //password Field
                    HStack {
                        Text("Password:")
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.width / 16 * 12, height: UIScreen.main.bounds.height / 48)
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.black, lineWidth: 1)
                            .frame(width: UIScreen.main.bounds.width / 16 * 12, height: UIScreen.main.bounds.height / 24)
                        HStack {
                            if secure {
                                SecureField("Password: ", text: $password)
                                    .autocapitalization(.none)
                                    .font(.system(size: 16))
                                    .multilineTextAlignment(.leading)
                                    .frame(width: UIScreen.main.bounds.width / 64 * 33, height: UIScreen.main.bounds.height / 24)
                                Spacer()
                                Image(systemName: "eye.fill")
                                    .foregroundColor(Color.black)
                                    .onTapGesture {
                                        withAnimation {
                                            secure.toggle()
                                        }
                                    }
                            }
                            else {
                                TextField("Password: ", text: $password)
                                    .autocapitalization(.none)
                                    .font(.system(size: 16))
                                    .multilineTextAlignment(.leading)
                                    .frame(width: UIScreen.main.bounds.width / 16 * 9, height: UIScreen.main.bounds.height / 24)
                                Spacer()
                                Image(systemName: "eye.slash.fill")
                                    .foregroundColor(Color.black)
                                    .onTapGesture {
                                        withAnimation {
                                            secure.toggle()
                                        }
                                    }
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width / 16 * 11, height: UIScreen.main.bounds.height / 24)
                    }
                    
                }
            }
            
            
            // HStack for the user's next steps
            HStack {
                // attempts to login
                skyBlueButton("Login", width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.height / 36)
                    .onTapGesture {
                        // login
                        print("Logging in")
                        login1(email: email, password: password) { (result) in
                            print("logged in successfully")
        
                            user.JWT = result.token
                            user.username = result.user.username
                            user.isAdmin  = result.user.isAdmin
                            user.userID   = result.user.id
                            
                            print("userID: " + user.userID)
                            
                            if(user.isAdmin){
                                screen.currentScreen = 4
                            }else {
                                screen.currentScreen = 2
                            }
                        }
                    }
                
                skyBlueButton("Guess Login", width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.height / 36)
                    .onTapGesture {
                        // login
                        print("Logging in")
                        login1(email: "GuessUser1", password: "GuessUser1") { (result) in
                            user.JWT = result.token
                            user.username = result.user.username
                            user.isAdmin  = result.user.isAdmin
                            user.userID   = result.user.id
                            
                            if(user.isAdmin){
                                screen.currentScreen = 4
                            }else {
                                screen.currentScreen = 2
                            }
                        }
                    }
                skyBlueButton("Admin Login", width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.height / 36)
                    .onTapGesture {
                        // login
                        print("Logging in")
                        login1(email: "admin@test.com", password: "admin") { (result) in
                            user.JWT = result.token
                            user.username = result.user.username
                            user.isAdmin  = result.user.isAdmin
                            user.userID   = result.user.id
                            
                            if(user.isAdmin){
                                screen.currentScreen = 4
                            }else {
                                screen.currentScreen = 2
                            }
                        }
                    }
            }
            .frame(width: UIScreen.main.bounds.width / 16 * 11, height: UIScreen.main.bounds.height / 30)
            
            // HStack to register an account
            HStack {
                Spacer()
                customButton("Register an account", width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height / 36, color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                    .font(.system(size: 14))
                    .foregroundColor(Color.black)
                    .onTapGesture {
                        screen.currentScreen = 1
                    }
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width / 16 * 11, height: UIScreen.main.bounds.height / 30)
        }
    }
}

