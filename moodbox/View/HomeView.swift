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
        sortDescriptors: [NSSortDescriptor(keyPath: \Record.create, ascending: false)],
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
                            
                                                        let index = records.firstIndex(of: item)!
                            
                            //                            print(index)
                            
                            HStack{
                                
                                
                                
                                Text(item.happy_type == 1 ?"😃" : "😕")
                                    .font(.system(size: 55))
                                
                                
                                
                                Text(item.create, formatter: itemFormatter)
                                    .font(.title2)
                                
                            }
                            .listRowSeparator(.hidden)
                            .listRowInsets(.init(top: 0,
                                                 leading: 25,
                                                 bottom: 0,
                                                 trailing: 0))
                            
                            if index < records.count - 1 {
                                Color.gray
                                    .frame(width: 1,height: 60)
                                    .offset(x:33)
                            }
                            
                            
                            
                        }
                        //                        .onDelete(perform: deleteItems)
                    }
                    .listStyle(.plain)
                    .listRowInsets(EdgeInsets())
                    //                    .listRowSeparator(<#T##visibility: Visibility##Visibility#>)
                    .toolbar {
#if os(iOS)
                        ToolbarItem(placement: .navigationBarTrailing) {
                            EditButton()
                        }
#endif
                        ToolbarItem {
                            Button(action: {
                                
                                records.forEach({
                                    viewContext.delete($0)
                                    //                                    $0.happy_type
                                    
                                    
                                })
                                
                                
                                
                                do {
                                    try viewContext.save()
                                } catch {
                                    // Replace this implementation with code to handle the error appropriately.
                                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                                    let nsError = error as NSError
                                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                                }
                                
                            }) {
                                Label("Clear", systemImage: "trash")
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
                                            addItem(happyType: isHappy ? 1 : 0 )
                                            
                                            withAnimation(.default){
                                                showCoin = false
                                            }
                                            
                                        }
                                    //                                .transition(.slide)
                                }
                            })
                        //                    .transition(AnyTransition.slide)
                        
                    }
                }
                
                
                
            }
            .navigationTitle("心情盒子")
            
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
    //    formatter.dateStyle = .medium
    //    formatter.timeStyle = .medium
    //    formatter.locale = Locale(identifier: "zh-CN")
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter
}()

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
