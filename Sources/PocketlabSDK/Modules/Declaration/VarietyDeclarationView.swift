//
//  SwiftUIView.swift
//  
//
//  Created by Youbaraj POUDEL on 25/11/2023.
//

import SwiftUI

struct Variety: Identifiable, Equatable {
    var id = UUID()
    var name: String
}

struct VarietyCard: View {
    var variety: Variety
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text(variety.name)
                        .font(.headline)
                }
                Spacer()
            }
            .padding(8)
            .frame(height: 20)
        }
    }
}


var varieties = [
    Variety(name: "Faro"),
    Variety(name: "Tosca"),
    Variety(name: "Planet"),
    Variety(name: "Amidala"),
    Variety(name: "Melange"),
    Variety(name: "Dementiel"),
    Variety(name: "Variete autre")
    
 ]

struct VarietyDeclarationView: View {
    @State private var pinnedVarieties: [Variety] = []
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Pinned")) {
                    ForEach(pinnedVarieties) { pinnedVariety in
                        VarietyCard(variety: pinnedVariety)
                    }
                    .onDelete(perform: deletePinnedVariety)
                    .onMove { from, to in
                        varieties.move(fromOffsets: from, toOffset: to)
                    }
                    .swipeActions(edge: .leading) {
                        Button(role: .destructive) {
                            // do click logic
                        } label: {
                            Label("Pin", systemImage: "pin.slash.fill")
                                .font(.title)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        
                    }
                } //end of pinned section
                
                Section(header: Text("All Varieties")) {
                    ForEach(varieties.filter { !pinnedVarieties.contains($0) }) { variety in
                        SwipeToPinCell(content: {
                            VarietyCard(variety: variety)
                        }, onSwipeToPin: {
                            pinnedVarieties.append(variety)
                        })
                    }
                    
                } //end of All varieties
                
            }
            .toolbar {
                EditButton()
            }
            .navigationTitle("")
        }
        
    }
    
    func deletePinnedVariety(at offsets: IndexSet) {
        pinnedVarieties.remove(atOffsets: offsets)
    }

    func movePinnedVariety(from source: IndexSet, to destination: Int) {
        pinnedVarieties.move(fromOffsets: source, toOffset: destination)
    }
    
    struct SwipeToPinCell<Content: View>: View {
        let content: Content
        let onSwipeToPin: () -> Void
        @State private var isPinning = false
        @State private var leadingOffset: CGFloat = 0
        
        init(@ViewBuilder content: @escaping () -> Content, onSwipeToPin: @escaping () -> Void) {
            self.content = content()
            self.onSwipeToPin = onSwipeToPin
        }

        var body: some View {
            ZStack {
                content
                    .swipeActions(edge: .leading) {
                        Button {
                            onSwipeToPin()
                        } label: {
                            Label("Pin", systemImage: "pin.fill")
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .font(.title)
                                .padding()
                                .cornerRadius(10)
                        }
                        .tint(.blue)
                    }
                
                HStack {
                    Spacer()
                    Image(systemName: "checkmark")
                        .resizable()
                        .foregroundColor(.blue)
                        .font(.title)
                        .frame(width: 20, height: 20)
                        .padding(.horizontal, 0)
                        .onTapGesture {
                            withAnimation {
                                onSwipeToPin()
                            }
                        }
                }
                .frame(height: 30)
                .opacity(0.8)
            }
        }
    }
    
    struct PinnedVarietyCard: View {
        var variety: Variety

        var body: some View {
            HStack {
                Image("")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())

                VStack(alignment: .leading) {
                    Text(variety.name)
                        .font(.headline)
                }

                Spacer()
            }
            .padding(8)
            .frame(height: 30) // Adjust the height as needed
        }
    }

    
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        VarietyDeclarationView()
    }
}
