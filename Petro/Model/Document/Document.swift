//
//  Document.swift
//  Petro
//
//  Created by Victor Letichevsky on 03/09/22.
//

import Foundation

struct Document: Identifiable {
    var id = UUID()
    var titulo: String
    var autor: String
    var descricao: String
}
