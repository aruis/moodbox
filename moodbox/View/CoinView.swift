//
//  CoinView.swift
//  moodbox
//
//  Created by 牧云踏歌 on 2023/3/13.
//

import SwiftUI

struct CoinView: View {
    
    @State private var isA1 = true
    @State private var isA2 = true
    
    var body: some View {
        
        ZStack{
            
            Circle()
                .foregroundColor(Color("sad"))
                .overlay(content: {
                    Text("😕")
                        .font(.system(size: 200))
                })
                .rotation3DEffect(
                    .degrees(isA1 ? 0 : 180),
                    axis: (0,1,0)
                )
                .zIndex(isA2 ? 0:1)
            
            Circle()
                .foregroundColor(Color("happy"))
                .overlay(content: {
                    Text("😃")
                        .font(.system(size: 200))
                })
                .rotation3DEffect(
                    .degrees(isA1 ? 0 : 180),
                    axis: (0,1,0)
                )
                .zIndex(isA2 ? 1:0)
            
        }.onTapGesture {
            withAnimation(.easeInOut(duration: 1),{
                isA1.toggle()
            })
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
                isA2.toggle()
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
