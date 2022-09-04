//
//  SearchView.swift
//  Petro
//
//  Created by Victor Letichevsky on 03/09/22.
//

import SwiftUI

struct SearchView: View {
    @StateObject var speechRecognizerViewModel = SpeechRecognizerViewModel()
    @State var selection = 0
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(named: "ButtonColor")
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
    }
    var body: some View {
        NavigationView {
            VStack {
                Picker("Filtro", selection: $selection) {
                    Text("Usuários").tag(0)
                    Text("Documentos").tag(1)
                }
                .padding(.horizontal, 10)
                .pickerStyle(.segmented)
                List {
                    if selection == 0 {
                        ForEach(speechRecognizerViewModel.searchResultUser) { user in
                            NavigationLink(destination: UserView(user: user)) {
                                Text(user.name)
                            }
                        }
                    } else {
                        ForEach(speechRecognizerViewModel.searchResultDocument) { document in
                            NavigationLink(destination: DocumentView(document: document)) {
                                Text(document.titulo)
                            }
                        }
                    }
                }
                .navigationTitle("Pesquisar")
                .searchable(text: $speechRecognizerViewModel.searchUser, placement: .navigationBarDrawer(displayMode: .always))
            }
        }
        .onAppear {
            speechRecognizerViewModel.reset()
            speechRecognizerViewModel.transcribe()
            let appearance = UINavigationBarAppearance()
                       let textColor = UIColor(Color("Instrucao"))
                                              appearance.largeTitleTextAttributes = [
                           .foregroundColor: textColor,
                       ]
                       UINavigationBar.appearance().standardAppearance = appearance
        }
        .onChange(of: speechRecognizerViewModel.searchUser) { _ in
            print(speechRecognizerViewModel.searchUser)
        }
    }
}

