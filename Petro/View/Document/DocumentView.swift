//
//  DocumentView.swift
//  Petro
//
//  Created by Victor Letichevsky on 03/09/22.
//

import SwiftUI

struct DocumentView: View {
    var document: Document
    var body: some View {
        Form{
            HStack{
                VStack {
                    Text(document.titulo)
                        .font(.title2)
                        .frame( alignment: .trailing)
                        .padding(.trailing, 30)
                    Text(document.autor)
                        .font(.title3)
                        .frame( alignment: .trailing)
                        .padding(.top, 3)
                        .padding(.leading, 0)
                        .padding(.trailing, 30)
                    Text(document.descricao)
                        .font(.title3)
                        .frame( alignment: .trailing)
                        .padding(.top, 3)
                        .padding(.trailing, 30)
                }
            }
        }
    }
}
