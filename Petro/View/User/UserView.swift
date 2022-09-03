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
                        .frame( alignment: .trailing)
                        .padding(.trailing, 30)
                    Text(user.competencies)
                        .font(.title3)
                        .frame( alignment: .trailing)
                        .padding(.top, 3)
                        .padding(.trailing, 30)
                }
            }
            Section(header: Text("Projetos que já trabalhou")) {
                Text("Projeto x")
                Text("Projeto y")
            }
        }
    }
}
