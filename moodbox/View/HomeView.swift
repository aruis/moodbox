//
//  HomeView.swift
//  moodbox
//
//  Created by 牧云踏歌 on 2023/3/14.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Record.create, ascending: true)],
        animation: .default)
    private var records: FetchedResults<Record>
    
    
    @State private var showCoin = false
    @State private var isHappy = true
    
    @Namespace private var coinTransition
    
    var body: some View {
        NavigationView {
            GeometryReader{ proxy in
                let size = proxy.size
                ZStack{
                    
                    List {
                        ForEach(records) { item in
                            NavigationLink {
                                Text("Item at \(item.create, formatter: itemFormatter)")
                            } label: {
                                HStack{
                                    
                                    if item.happy_type == 1{
                                        Text("😃")
                                    }else{
                                        Text("😕")
                                    }
                                    
                                    Text(item.create, formatter: itemFormatter)
                                }
                                
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .toolbar {
#if os(iOS)
                        ToolbarItem(placement: .navigationBarTrailing) {
                            EditButton()
                        }
#endif
                        ToolbarItem {
                            Button(action: {
                                addItem(happyType: isHappy ? 1 : 0 )
                            }) {
                                Label("Add Item", systemImage: "plus")
                            }
                        }
                    }
//                    Text("Select an item")
                    
                    if showCoin {
                        Color.black
                            .ignoresSafeArea()
                            .overlay(content: {
                                
                                VStack(alignment: .center, spacing:20) {
                                    CoinView(coinTransition:coinTransition,isHappy: $isHappy)
                                        .frame(width: size.width/3*2)
                                    
                                    Circle()
                                        .fill(.green)
                                        .frame(width: 60)
                                        .overlay(content: {
                                            Image(systemName: "checkmark")
                                                .font(.largeTitle)
                                                .foregroundColor(.white)
                                        })
                                        .onTapGesture {
                                            withAnimation(.default){
                                                showCoin = false
                                            }
                                            addItem(happyType: isHappy ? 1 : 0 )
                                        }
                                    //                                .transition(.slide)
                                }
                            })
                        //                    .transition(AnyTransition.slide)
                        
                    }
                }
                
                
                
            }
            
//            .ignoresSafeArea()
        }
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
    
    private func addItem(happyType:Int16) {
        withAnimation {
            let newItem = Record(context: viewContext)
            newItem.create = Date()
            newItem.happy_type = happyType
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { records[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
