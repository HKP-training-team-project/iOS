//
//  SignupView.swift
//  FinalProject
//
//  Created by Jonathan Pang on 1/11/21.
//

import SwiftUI

struct SignupView: View {
    @ObservedObject var screen: CurrentScreen
    @State var username            = ""
    @State var email               = ""
    @State var password            = ""
    @State var confirmPassword     = ""
    @State var secure              = true
    @State var showingAlertSignUp  = false
    @State var alertMessage        = ""
    
    // makes sure the password has any 2 combinations of letters, digits, or special symbols
    func subVerificationPassword(_ password: String) -> Bool {
        var pass          = 0
        var verifications = ["letters": false, "digits": false, "special": false]
        for character in password.unicodeScalars {
            if !verifications["letters"]! {
                if CharacterSet.letters.contains(character) {
                    pass += 1
                    verifications["letters"] = true
                }
            }
            if !verifications["digits"]! {
                if CharacterSet.decimalDigits.contains(character) {
                    pass += 1
                    verifications["digits"] = true
                }
            }
            if !verifications["special"]! {
                if !CharacterSet.letters.contains(character) && !CharacterSet.letters.contains(character) {
                    pass += 1
                    verifications["special"] = true
                }
            }
            if pass >= 2 {
                return true
            }
        }
        return false
    }

    // checks if the user can signup with their password
    func verifyPassword() -> Bool {
        if password != confirmPassword {
            return false
        }
        if password.count < 8 || confirmPassword.count < 8 {
            return false
        }
        if (subVerificationPassword(password) && subVerificationPassword(confirmPassword)) == false {
            return false
        }
        return true
    }
    
    var body: some View {
        // VStack with the user's contents
        VStack(alignment: .center, spacing: UIScreen.main.bounds.height / 64) {
            ZStack {
                customButton("", width: UIScreen.main.bounds.width / 8 * 7, height: UIScreen.main.bounds.height / 8 * 2, color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                VStack {
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.black, lineWidth: 1)
                                .frame(width: UIScreen.main.bounds.width / 32 * 11, height: UIScreen.main.bounds.height / 24)
                            TextField("Username: ", text: $username)
                                .autocapitalization(.none)
                                .font(.system(size: 16))
                                .multilineTextAlignment(.leading)
                                .frame(width: UIScreen.main.bounds.width / 32 * 9, height: UIScreen.main.bounds.height / 24)
                        }
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.width / 16 * 12, height: UIScreen.main.bounds.height / 24)
                    
                    // username tab
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.black, lineWidth: 1)
                            .frame(width: UIScreen.main.bounds.width / 16 * 12, height: UIScreen.main.bounds.height / 24)
                        // current state of the user's username
                        HStack {
                            TextField("Email: ", text: $email)
                                .autocapitalization(.none)
                                .font(.system(size: 16))
                                .multilineTextAlignment(.leading)
                                .frame(width: UIScreen.main.bounds.width / 16 * 9, height: UIScreen.main.bounds.height / 24)
                            Spacer()
                            
                        }
                        .frame(width: UIScreen.main.bounds.width / 16 * 11, height: UIScreen.main.bounds.height / 24)
                    }
                    
                    // password tab
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.black, lineWidth: 1)
                            .frame(width: UIScreen.main.bounds.width / 16 * 12, height: UIScreen.main.bounds.height / 24)
                        HStack {
                            SecureField("Password: ", text: $password)
                                .autocapitalization(.none)
                                .font(.system(size: 16))
                                .multilineTextAlignment(.leading)
                                .frame(width: UIScreen.main.bounds.width / 16 * 9, height: UIScreen.main.bounds.height / 24)
                            Spacer()
                        }
                        .frame(width: UIScreen.main.bounds.width / 16 * 11, height: UIScreen.main.bounds.height / 24)
                    }
                    
                    // confirm password tab
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.black, lineWidth: 1)
                            .frame(width: UIScreen.main.bounds.width / 16 * 12, height: UIScreen.main.bounds.height / 24)
                        // HStack to switch between SecureField and TextField
                        HStack {
                            if secure {
                                SecureField("Confirm Password: ", text: $confirmPassword)
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
                                TextField("Confirm Password: ", text: $confirmPassword)
                                    .autocapitalization(.none)
                                    .font(.system(size: 16))
                                    .multilineTextAlignment(.leading)
                                    .frame(width: UIScreen.main.bounds.width / 64 * 33, height: UIScreen.main.bounds.height / 24)
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
                whiteButton("Back", width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.height / 30)
                    .onTapGesture {
                        //Back to home screen
                        screen.currentScreen = 0 
                    }
                Spacer()
                // attempts to signup
                whiteButton("Sign Up", width: UIScreen.main.bounds.width / 5, height: UIScreen.main.bounds.height / 30)
                    .onTapGesture {
                        if (verifyPassword()){
                            signup(username: username, email: email , password: password, confirmPassword: confirmPassword) { (message) in
                                alertMessage = message.description
                                showingAlertSignUp.toggle()
                            }
                        }
                        else {
                            alertMessage = "There was an error signing up"
                            showingAlertSignUp.toggle()
                        }
                    }
            }
            .frame(width: UIScreen.main.bounds.width / 16 * 11, height: UIScreen.main.bounds.height / 36)
            .alert(isPresented: $showingAlertSignUp){
                Alert(title: Text(alertMessage), message: nil, dismissButton: .default(Text("OK")))
            }
        }
    }
}
