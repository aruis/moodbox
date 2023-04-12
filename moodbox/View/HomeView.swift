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
    @State private var takePhoto = false
    @State private var listOffset: CGFloat = .zero
    @State private var isButtonHidden = false
    //    @State private var isHappy = true
    
    @ObservedObject private var selectItem:RecordViewModel = RecordViewModel()
    
    @Namespace private var coinTransition
    
    var body: some View {
        NavigationView {
            GeometryReader{ proxy in
                let size = proxy.size
                List {
                    ForEach(records) { item in
                        itemInList(item: item,size: size)
                    }
                }
                .listStyle(.plain)
                .listRowInsets(EdgeInsets())
                .overlay(
                    GeometryReader { proxy in
                                       let minY = proxy.frame(in: .global).minY
                                       let height = proxy.size.height
                                       let contentHeight = proxy.frame(in: .local).height
                                       
                                       let offset = max(minY, -(contentHeight - height))
                                       Color.clear.preference(key: ViewOffsetKey.self, value: offset)
                                   }
                                   .onPreferenceChange(ViewOffsetKey.self) { offset in
                                       let isHidden = offset < listOffset
                                       withAnimation {
                                           isButtonHidden = isHidden
                                       }
                                       listOffset = offset
                                       print("List scrolled with offset: \(listOffset)")
                                   }
                )
                
                //                    .listRowSeparator(<#T##visibility: Visibility##Visibility#>)
                .toolbar {
                    ToolbarItem {
                        Button(action: {
                            records.forEach({
                                viewContext.delete($0)
                                
                            })
                            
                            
                            do {
                                try viewContext.save()
                            } catch {
                                let nsError = error as NSError
                                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                            }
                            
                        }) {
                            Label("Clear", systemImage: "trash")
                        }
                    }
                }
                .sheet(isPresented: $showCoin){
                    pickView(size: size)
                        .fullScreenCover(isPresented: $takePhoto){
                            ImagePicker(selectedImage: $selectItem.image)
                                .ignoresSafeArea()
                        }
                }
                
                
            }
            .navigationTitle("心情盒子\(records.count)")
            
            //            .ignoresSafeArea()
        }
        
        
        .overlay(alignment: .bottomTrailing, content: {
            if !showCoin {
                
                Button{
                    withAnimation(.default){
                        selectItem.clear()
                        showCoin = true
                    }
                }label: {
                    Image(systemName: "plus")
                        .font(.largeTitle)
                }
                .buttonStyle(CircularButtonStyle(color: Color.yellow))
                .padding(.trailing,18)
                .opacity(isButtonHidden ? 0 : 1)
    
                
                
                
            }
            
        })
    }
    
    @ViewBuilder
    func itemInList(item:Record,size:CGSize)-> some View{
        
        let index = records.firstIndex(of: item)!
        
        HStack{
            Text(item.happy_type == 1 ?"😃" : "😕")
                .font(.system(size: 55))
                .overlay(alignment: .center , content: {
                    if index < records.count - 1 {
                        Color.gray
                            .frame(width: 1,height: 50)
                            .offset(y:64)
                    }
                })
            
            HStack(alignment:.firstTextBaseline){
                Text(item.create, formatter: itemFormatter)
                    .font(.title2)
                
                Button{
                    selectItem.setRecord(record: item)
                    showCoin = true
                }label: {
                    Image(systemName: "square.and.pencil")
                        .font(.title)
                    
                }
                .buttonStyle(.borderless)
            }
            
            
        }
        
        
        
        .listRowSeparator(.hidden)
        .listRowInsets(.init(top: 0,
                             leading: 25,
                             bottom: 60,
                             trailing: 0))
        
        
        
    }
    
    @ViewBuilder
    func pickView(size:CGSize)-> some View{
        NavigationStack {
            ScrollView{
                VStack(alignment: .center, spacing:25) {
                    CoinView(coinTransition:coinTransition,happyType:$selectItem.happy_type)
                        .frame(width: size.width/3*2)
                    
                    if let image =  selectItem.image{
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height:300)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                    
                    Button{
                        takePhoto = true
                    }label: {
                        Image(systemName: "camera")
                    }
                    
                    TextEditor(text: $selectItem.content)
                    //                        .padding(10)
                        .font(.title2)
                        .frame(width: size.width*0.8,height: size.height * 0.3)
                        .border(Color.black,width: 1)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                    //                        .padding(10)
                    
                    Button{
                        addItem()
                        
                        withAnimation(.default){
                            showCoin = false
                        }
                    }label: {
                        Image(systemName: "checkmark")
                            .font(.largeTitle)
                    }
                    .buttonStyle(CircularButtonStyle(color: Color.yellow))
                    
                    //                    Circle()
                    //                        .fill(.green)
                    //                        .frame(width: 60)
                    //                        .overlay(content: {
                    //                            Image(systemName: "checkmark")
                    //                                .font(.largeTitle)
                    //                                .foregroundColor(.white)
                    //                        })
                    //                        .onTapGesture {
                    //
                    //
                    //                        }
                    //                                .transition(.slide)
                }
            }
            .toolbar{
                
                if let record = selectItem.model{
                    Button( role: .destructive){
                        viewContext.delete(record)
                        do {
                            try viewContext.save()
                        } catch {
                            let nsError = error as NSError
                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                        }
                        showCoin = false
                    }label: {
                        Image(systemName: "trash")
                    }
                }
            }
            
        }
    }
    
    @ViewBuilder
    func pickCoinButton()-> some View{
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
                        selectItem.clear()
                        showCoin = true
                    }
                    
                }
        }
        .padding(.bottom,30)
        .padding(.trailing,45)
        
    }
    
    private func addItem() {
        withAnimation {
            
            
            let record = (selectItem.model != nil) ? selectItem.model! : Record(context: viewContext)
            
            if record.isInserted {
                record.create = Date()
                record.id = UUID().uuidString
            }
            //            record.create = Date()
            record.happy_type = selectItem.happy_type
            record.content = selectItem.content
            do {
                try viewContext.save()
                selectItem.clear()
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

private struct ViewOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
