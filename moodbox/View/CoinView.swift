//
//  CoinView.swift
//  moodbox
//
//  Created by 牧云踏歌 on 2023/3/13.
//

import SwiftUI

struct CoinView: View {
    
    @State private var isA = true
    
    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        
        ZStack{
            
            Circle()
                .foregroundColor(Color("sad"))
                .overlay(content: {
                    Text("😕")
                        .font(.system(size: 200))
                })
                .rotation3DEffect(
                    .degrees(isA ? 0 : 180),
                    axis: (0,1,0)
                )
                .opacity(isA ? 1:0)
                .zIndex(isA ? 0:1)
            
            Circle()
                .foregroundColor(Color("happy"))
                .overlay(content: {
                    Text("😃")
                        .font(.system(size: 200))
                })
                .rotation3DEffect(
                    .degrees(isA ? 0 : 180),
                    axis: (0,1,0)
                )
                .opacity(isA ? 0:1)
                .zIndex(isA ? 1:0)
            
        }.onTapGesture {
            withAnimation(.easeInOut(duration: 1),{
                isA.toggle()
            })
        }
       
    }
}

struct CoinView_Previews: PreviewProvider {
    static var previews: some View {
        CoinView()
            .background(Color(UIColor.systemGray))
    }
}
