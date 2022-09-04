//
//  User.swift
//  Petro
//
//  Created by Victor Letichevsky on 03/09/22.
//

import Foundation

struct User: Identifiable {
    var id = UUID()
    var name: String
    var competencies: String
    var profileImage: String
    var tel: String
    var email: String
    var projetos: [Document]
    var password: String
}
