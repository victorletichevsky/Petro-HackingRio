//
//  SearchView.swift
//  Petro
//
//  Created by Victor Letichevsky on 03/09/22.
//

import SwiftUI
import AVFoundation

struct SearchView: View {
    @StateObject var speechRecognizerViewModel = SpeechRecognizerViewModel()
    @State var selection = 0
    enum SearchFilter: String, CaseIterable {
        case users = "Usuários"
        case documents = "Documentos"
    }
    var body: some View {
        NavigationView {
            VStack {
                Picker("Filtro", selection: $selection) {
                    Text("Usuários").tag(0)
                    Text("Documentos").tag(1)
                }.pickerStyle(.segmented)
                List {
                    if selection == 0 {
                        ForEach(speechRecognizerViewModel.searchResult) { user in
                            NavigationLink(destination: UserView(user: user)) {
                                Text(user.name)
                            }
                        }
                    } else {
                        
                    }
                }
                .navigationTitle("Pesquisar")
                
                .searchable(text: $speechRecognizerViewModel.searchUser, placement: .navigationBarDrawer(displayMode: .always))
                //            .toolbar {
                //                ToolbarItem(placement: .navigationBarTrailing) {
                //                    Picker("Filtro", selection: $selection, content: {
                //                        Text("Usuárioss").tag(0)
                //                        Text("Documentos").tag(1)
                //                    }).pickerStyle(SegmentedPickerStyle())
                //                }
                //            }
            }
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

