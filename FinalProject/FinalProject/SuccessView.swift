//
//  SuccessView.swift
//  FinalProject
//
//  Created by Eric Chen on 1/17/21.
//

import SwiftUI

struct SuccessView: View {
   // @ObservedObject var screen: CurrentScreen
    var body: some View {
        VStack{
            ZStack{
                Rectangle()
                    .fill(Color.black)
                VStack{
                    ZStack{
                        customButton("",width: UIScreen.main.bounds.width, height: 200 ,color: Color.green)
                        
                        /*
                        RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                            .fill(Color.green)
                        */
                        VStack{
                            ZStack{
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 60, height: 60, alignment: .top)
                                Image(systemName: "checkmark")
                                    .foregroundColor(.green)
                                    .font(.system(size: 45))
                            }
                            .padding()
                            Spacer()
                        }
                        VStack{
                            Text("Success!")
                                .font(.largeTitle)
                                .foregroundColor(Color(#colorLiteral(red: 0.9998918176, green: 1, blue: 0.9998806119, alpha: 1)))
                                .padding(.top)
                            Text("YOUR ORDER WAS SUCCESSFUL!")
                                .font(.system(size: 20))
                                .bold()
                                .foregroundColor(Color(#colorLiteral(red: 0.9998918176, green: 1, blue: 0.9998806119, alpha: 1)))
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width, height: 200, alignment: .center)
                    Spacer()
                }
            }
            
        }
        .onTapGesture {
            print("tapped!")
        }
    }
}


struct SuccessView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessView()
    }
}

/*
 Text("Success!")
     .font(.largeTitle)
     .frame(width: UIScreen.main.bounds.width, height: 200, alignment: .center)
     .background(Color(#colorLiteral(red: 0, green: 0.7891366482, blue: 0.3804230094, alpha: 1)))
     .cornerRadius(25)
 */

/*
 Circle()
     .stroke()
     .frame(width: UIScreen.main.bounds.width, height: 10, alignment: .center)
 */

/*
 Image(systemName: "checkmark")
     .font(.title)
     .foregroundColor(.white)
 */
