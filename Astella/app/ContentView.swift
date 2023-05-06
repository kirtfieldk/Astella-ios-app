//
//  ContentView.swift
//  Astella
//
//  Created by Keith Kirtfield on 4/28/23.
//

import SwiftUI




struct ContentView: View {
//    Maintain state between renders
    @StateObject var viewModel = FetchMessages()
    @State private var path = NavigationPath()
     let locationService = LocationTrackingViewController()
    var body: some View {
        NavigationStack(path: $path) {
            List {
                NavigationLink("Events",value: present(LocationTrackingViewController(), Animation: true))
            }
            
        }

        }
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
