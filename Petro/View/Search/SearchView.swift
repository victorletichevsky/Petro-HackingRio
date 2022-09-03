//
//  SearchView.swift
//  Petro
//
//  Created by Victor Letichevsky on 03/09/22.
//

import SwiftUI
import AVFoundation

struct FirstView: View {
    @StateObject var speechRecognizerViewModel = SpeechRecognizerViewModel()
    var body: some View {
        NavigationView {
            List {
                ForEach(speechRecognizerViewModel.searchResult) { user in
                    NavigationLink(destination: UserView(user: user)) {
                        Text(user.name)
                    }
                }
            }
            .navigationTitle("Pesquisar")
            .searchable(text: $speechRecognizerViewModel.searchUser, placement: .navigationBarDrawer(displayMode: .always))
        }
        .onAppear {
            speechRecognizerViewModel.reset()
            speechRecognizerViewModel.transcribe()
        }
        .onChange(of: speechRecognizerViewModel.searchUser) { _ in
            print(speechRecognizerViewModel.searchUser)
        }
    }
}

