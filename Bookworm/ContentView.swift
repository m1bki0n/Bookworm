//
//  ContentView.swift
//  Project 11
//
//  Created by Makwan BK on 1/24/20.
//  Copyright © 2020 Makwan BK. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Book.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Book.title, ascending: true)
    ]) var books: FetchedResults<Book>

    @State private var showingAddBookScreen = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(books, id: \.self) { book in
                    NavigationLink(destination: DetailView(book: book)) {
                        EmojiRatingView(rating: book.rating)
                            .font(.largeTitle)
                        
                        VStack(alignment: .leading) {
                            Text(book.title ?? "UNKNOWN")
                                .font(.headline)
                                .foregroundColor(book.rating == 1 ? .red : .black)
                            Text(book.author ?? "UN AUTHOR")
                                .foregroundColor(.secondary)
                        }
                    }
                }
            .onDelete(perform: delete)
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("Bookworm")
                .navigationBarItems(leading: EditButton(), trailing:
                    Button(action: {
                    self.showingAddBookScreen.toggle()
                    }) {
                        Image(systemName: "plus")
                })
                .sheet(isPresented: $showingAddBookScreen) {
                    AddBook().environment(\.managedObjectContext, self.moc)
            }
            
        }
    }
    
    func delete(at offsets: IndexSet) {
        for offset in offsets {
            let book = books[offset]
            moc.delete(book)
        }
        try? moc.save()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
