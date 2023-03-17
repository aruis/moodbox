//
//  HomeView.swift
//  moodbox
//
//  Created by 牧云踏歌 on 2023/3/14.
//

import SwiftUI

struct HomeView: View {
    
    @State private var showCoin = false
    @Namespace private var coinTransition
    
    var body: some View {
        GeometryReader{ proxy in
            let size = proxy.size
            if showCoin {
                Color.black
                    .ignoresSafeArea()
                    .overlay(content: {
                        
                        VStack(spacing:20) {
                            CoinView(coinTransition:coinTransition)
                                .frame(width: size.width/3*2)
                                                            
                            Circle()
                                .fill(.green)
                                .frame(width: 60)
                                .overlay(content: {
                                    Image(systemName: "checkmark")
                                        .font(.largeTitle)
                                        .foregroundColor(.white)
                                })
                                .matchedGeometryEffect(id: "circle", in: coinTransition)
                                .onTapGesture {
                                    withAnimation(.default){
                                        showCoin = false
                                    }
                                    
                                }
                        }
                    })
//                    .transition(AnyTransition.slide)
                
            }
            
            
        }
        .ignoresSafeArea()
        .overlay(alignment: .bottomTrailing, content: {
            if !showCoin {
                VStack {
                    Circle()
                        .fill(.yellow)
                        .frame(width: 60,height: 60)
                        .overlay(content: {
                            Image(systemName: "plus")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                        })
                        .matchedGeometryEffect(id: "circle", in: coinTransition)
                        .onTapGesture {
                            withAnimation(.default){
                                showCoin = true
                            }
                            
                        }
                }
                .padding(.bottom,30)
                .padding(.trailing,45)
            }
            
        })
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
