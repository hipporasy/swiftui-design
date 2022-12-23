//
//  FolderDetailView.swift
//  folder.like.ui
//
//  Created by Marasy Phi on 12/12/22.
//

import Foundation

import SwiftUI

struct FolderDetailView: View {

    let book: Book
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 20) {
                Spacer()
                    VStack(alignment: .leading, spacing: 4) {
                        Text(book.title)
                            .font(.system(size: 18, weight: .medium))
                        Text(book.author)
                            .font(.system(size: 14, weight: .regular))
                        Spacer().frame(height: 8)
                        Button {
                        
                        } label: {
                            Text("Buy it for $\(book.price.formatted())")
                                .foregroundColor(.white)
                                .font(.system(size: 18, weight: .bold))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(hex: 0x6DC4DD)
                                    .blur(radius: 40, opaque: true)
                                    .opacity(0.8)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.black.blur(radius: 40,
                                                 opaque: true).opacity(0.6))
                
            }
            .foregroundColor(Color.primary)
            .frame(maxWidth: .infinity)
            .frame(height: 360)
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
            .background(Image(book.url)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 360, alignment: .center))
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 30)
            
        }
        .frame(maxWidth: .infinity)
        
    }
    
}


struct FolderDetailView_Preview : PreviewProvider {
    
    
    static var previews: some View {
        FolderDetailView(book: .books.first!)
    }
    
    
}
