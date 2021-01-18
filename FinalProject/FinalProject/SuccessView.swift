//
//  SuccessView.swift
//  FinalProject
//
//  Created by Eric Chen on 1/17/21.
//

import SwiftUI

struct SuccessView: View {
    @ObservedObject var screen: CurrentScreen
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .fill(Color.white)
                VStack {
                    ZStack {
                        customButton("",width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 4 ,color: Color.green)
                        VStack {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: UIScreen.main.bounds.width / 32 * 5, height: UIScreen.main.bounds.width / 32 * 5, alignment: .top)
                                Image(systemName: "checkmark")
                                    .foregroundColor(.green)
                                    .font(.system(size: UIScreen.main.bounds.width / 32 * 3))
                            }
                            .padding()
                            Spacer()
                        }
                        VStack {
                            Text("Success!")
                                .font(.largeTitle)
                                .foregroundColor(Color(#colorLiteral(red: 0.9998918176, green: 1, blue: 0.9998806119, alpha: 1)))
                                .padding(.top)
                            Text("YOUR ORDER WAS SUCCESSFUL!")
                                .font(.system(size: UIScreen.main.bounds.width / 72 * 3))
                                .bold()
                                .foregroundColor(Color(#colorLiteral(red: 0.9998918176, green: 1, blue: 0.9998806119, alpha: 1)))
                            Text("tap anywhere to go back")
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 4, alignment: .center)
                    Spacer()
                }
            }
            
        }
        .onTapGesture {
            screen.currentScreen = 2
        }
    }
}
