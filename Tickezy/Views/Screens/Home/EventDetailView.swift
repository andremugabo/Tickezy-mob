//
//  EventDetailView.swift
//  Tickezy
//
//  Created by M.A on 4/23/25.
//

import SwiftUI

struct EventDetailView: View {
    let event: Event
    var body: some View {
        ScrollView {
            Image(event.imageName).resizable().scaledToFit()
            VStack(alignment: .leading, spacing: 16){
                Text(event.title).font(.title).bold()
                Text(event.date, style:  .date)
                Text(event.location).font(.subheadline)
                Text(event.description)
                ButtonPrimary(title: "Buy Ticket"){
                    //To Ticket purchse screen
                }
            }
        }
    }
}


