//
//  DocumentView.swift
//
//  Petro Project
//
//  Created by Victor Letichevsky on 03/09/22.
//  Updated by Barbara Herrera and Bernardo Delgado on 03/09/22.
//

import SwiftUI

struct DocumentView: View {
    var document: Document
    var body: some View {
        HStack (spacing: 0.0){
            VStack{
                HStack (alignment: .top){
                        Text("Título:    ")
                            .bold()
                            .frame( alignment: .topLeading)
                        Text(document.titulo)
                            .frame(width:UIScreen.main.bounds.width*2/3)
                }
                .padding()
                .border(.bar)
                HStack (alignment: .top){
                    Text("Autor:     ")
                        .bold()
                        .frame( alignment: .topLeading)
                    Text(document.autor)
                        .frame(width:UIScreen.main.bounds.width*2/3)
                        .textCase(.uppercase)
                }
                .padding()
                .border(.bar)
                HStack (alignment: .top){
                    Text("Descrição:")
                        .bold()
                        .frame( alignment: .topLeading)
                    Text(document.descricao)
                        .frame(width:UIScreen.main.bounds.width*2/3)
                }
            .padding()
            .border(.bar)
            Spacer()
            }
            .border(.bar)
        }
    }
}
