//
//  MenuView.swift
//
//  Petro Project
//
//  Created by Victor Letichevsky on 03/09/22.
//  Updated by Barbara Herrera and Mariana Burlamaqui on 04/09/22.
//

import SwiftUI

struct MenuView: View {
    @State private var start = false
    var body: some View {
        VStack {
            Image("LogoMenu")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.height / 4)
                .padding(.bottom, 60)
            Text("Instruções")
                .font(.largeTitle)
                .foregroundColor(Color( "Instrucao"))
                .bold()
                .padding(.bottom, 1)
            Group {
                (Text("Petro está aqui para te fornecer informações completas a todo momento. Sempre que precisar fazer uma pesquisa, diga ")
                +
                Text("Petro!")
                    .bold())
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 7.5)
            Button {
                start.toggle()
            } label: {
                Text("Começar")
                    .frame(width: UIScreen.main.bounds.width / 1.2, height: UIScreen.main.bounds.height / 20)
                    .background(Color("ButtonColor"))
                    .foregroundColor(Color.white)
                    .cornerRadius(12)
                    .padding(40)
                    .padding(.top, 10)
                    .padding(.bottom, 180)
            }.fullScreenCover(isPresented: $start) {
                SearchView()
            }
        }
    }
}

