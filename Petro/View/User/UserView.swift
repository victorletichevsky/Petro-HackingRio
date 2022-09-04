//
//  UserView.swift
//  Petro
//
//  Created by Victor Letichevsky on 03/09/22.
//

import SwiftUI


struct UserView: View {
    var user: User
    var body: some View {
        Form {
            HStack {
                Image(user.profileImage)
                    .resizable()
                    .clipped()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(width: UIScreen.main.bounds.width / 3.5, height: UIScreen.main.bounds.width / 3.5)
                VStack {
                    Text(user.name)
                        .font(.title2)
                        .frame( alignment: .center)
                    Text(user.competencies)
                        .font(.title3)
                        .frame( alignment: .trailing)
                        .padding(.top, 3)
                    
                }
            }
            Section(header: Text("Contatos")) {
                Group {
                    Text("Telefone: ")
                        .bold()
                    +
                    Text(user.tel)
                }
                
                
                Group {
                    Text("E-mail: ")
                        .bold()
                    +
                    Text(user.email)
                }
            }
            Section(header: Text("Projetos")) {
                ForEach(user.projetos) { projeto in
                    Text(projeto.titulo)
                }
            }
            .accentColor(Color("Instrucao"))
            
        }
    }
}
