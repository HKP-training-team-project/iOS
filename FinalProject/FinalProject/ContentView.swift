//
//  ContentView.swift
//  FinalProject
//
//  Created by Jonathan Pang on 1/11/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var screen = CurrentScreen()
    @ObservedObject var user = userJWT()
    @ObservedObject var pass = passItem()

    var body: some View {
        switch screen.currentScreen {
        case 1:
            SignupView(screen: screen)
        case 2:
            ShopView(screen: screen, user: user, pass: pass)
        case 3:
            CheckOutView(screen: screen, user: user)
        case 4:
            AdminView(screen: screen, user: user)
        case 5:
            SuccessView(screen: screen)
        case 6:
            ItemDetailView(screen: screen, user: user, item: pass.item)
        default:
            LoginView(screen: screen, user: user)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
