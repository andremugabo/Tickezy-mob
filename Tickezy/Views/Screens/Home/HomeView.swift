//
//  HomeView.swift
//  Tickezy
//
//  Created by M.A on 4/23/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var svc: EventService
    
    var body: some View {
        NavigationStack {
            List(svc.events) {
                e in
                NavigationLink(value: e){
                    EventRow(event: e)
                }
            }
            .navigationDestination(for: Event.self){ e in
                EventDetailView(event: e)
            }
            .navigationTitle("Events")
        }
    }
}

#Preview {
    HomeView()
}
