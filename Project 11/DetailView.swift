//
//  DetailView.swift
//  Project 11
//
//  Created by Makwan BK on 1/24/20.
//  Copyright © 2020 Makwan BK. All rights reserved.
//

import CoreData
import SwiftUI

struct DetailView: View {
    let book : Book
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentMode
    @State private var isShowingAlert = false
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                ZStack(alignment: .bottomTrailing) {
                    Image(self.book.genre ?? "Fantasy")
                        .frame(maxWidth: geo.size.width)
                    
                    Text(self.book.genre?.uppercased() ?? "FANTASY")
                        .font(.caption)
                        .fontWeight(.black)
                    .padding(8)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.75))
                        .clipShape(Capsule())
                    .offset(x: -5, y: -5)
                    
                }
                
                Text(self.book.author ?? "UNKNOWN AUTHOR")
                    .font(.title)
                    .foregroundColor(.secondary)
                
                Text(self.book.review ?? "UNKNWON BOOK REVIEW")
                .padding()
                
                RatingView(rating: .constant(Int(self.book.rating)))
                    .font(.largeTitle)
                
                Text(self.getDate())
                    .font(.system(size: 17)).bold()
                    .foregroundColor(.secondary)
                    .padding(25)
                
                Spacer()
                
            }
        }
        .navigationBarTitle(Text(book.title ?? "UNKNWON"), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            self.isShowingAlert = true
        }) {
            Image(systemName: "trash")
        })
        .alert(isPresented: $isShowingAlert) {
            Alert(title: Text("Delete book"), message: Text("Are you sure?"), primaryButton: .destructive(Text("Delete")) {
                self.deleteBook()
                }, secondaryButton: .cancel())
        }
    }
    
    func deleteBook() {
        moc.delete(book)
        
//        try? moc.save()
        
        presentMode.wrappedValue.dismiss()
    }
    
    func getDate() -> String {
        let format = DateFormatter()
        format.dateStyle = .medium
        let get = format.string(from: Date())
        return get
    }
    
}

struct DetailView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        let book = Book(context: moc)
        
        book.title = "Test book"
        book.author = "Test author"
        book.genre = "Fantasy"
        book.rating = 4
        book.review = "This is a great book"
        
        return NavigationView {
            DetailView(book: book)
        }
    }
}
