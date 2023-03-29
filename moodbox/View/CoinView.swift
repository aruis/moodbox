//
//  CoinView.swift
//  moodbox
//
//  Created by 牧云踏歌 on 2023/3/13.
//

import SwiftUI

struct CoinView: View {
    
    var coinTransition: Namespace.ID
    
    
    @Binding var happyType:Int16
    
    @State private var isA2 = true
    
    @State private var isShow = false
    
    var body: some View {
        
        ZStack{
          
            
//            Circle()
//                .foregroundColor(Color("sad"))
//                .overlay(content: {
//                    Text("😕")
//                        .font(.system(size: 200))
//                })
//                .rotation3DEffect(
//                    .degrees(isA1 ? 0 : 180),
//                    axis: (0,1,0)
//                )
//                .zIndex(isA2 ? 0:1)
//                .matchedGeometryEffect(id: "circle", in: coinTransition)
            
            if isShow {
                Text("😕")
                    .font(.system(size: 200))
                    .rotation3DEffect(
                        .degrees(happyType == 1 ? 0 : 180),
                        axis: (0,1,0)
                    )
                    .zIndex(isA2 ? 1:3)
//                    .matchedGeometryEffect(id: "sad0", in: coinTransition)
            }

     
            Circle()
                .foregroundColor(Color("happy"))
                .rotation3DEffect(
                    .degrees(happyType == 1 ? 0 : 180),
                    axis: (0,1,0)
                )
                .zIndex(2)
                .matchedGeometryEffect(id: "circle", in: coinTransition)
//                .zIndex(isA2 ? 1:0)
            
            if isShow {
                Text("😃")
                    .font(.system(size: 200))
                    .rotation3DEffect(
                        .degrees(happyType == 1 ? 0 : 180),
                        axis: (0,1,0)
                    )
                    .zIndex(isA2 ? 3:1)
//                    .matchedGeometryEffect(id: "happy0", in: coinTransition)
            }                       
            
        }.onTapGesture {
            withAnimation(.easeInOut(duration: 1),{
                happyType = (happyType == 1 ? 0 : 1)
            })
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
                isA2.toggle()
            })
        }.onAppear{
//            isShow = true
            withAnimation(.easeIn(duration: 0.5).delay(0.1),{
                isShow = true
            })
            
            isA2 = happyType == 1
        }
        
    }
}

struct CoinView_Previews: PreviewProvider {
    
    static var previews: some View {
        let namespace = Namespace().wrappedValue
        CoinView(coinTransition:namespace,happyType:.constant(1))
            .background(Color(UIColor.systemGray))
    }
}
