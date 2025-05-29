//
//  EventRow.swift
//  Tickezy
//
//  Created by M.A on 4/23/25.
//

import SwiftUI

struct EventRow: View {
    let event: Event
    var body: some View {
        HStack {
            Image(event.imageName)
                .resizable()
                .frame(width: 60, height: 60)
                .cornerRadius(8)
            VStack(alignment: .leading) {
                Text(event.title).bold()
                Text(event.location).font(.subheadline).foregroundColor(.secondary)
            }
        }
    }
}
 
