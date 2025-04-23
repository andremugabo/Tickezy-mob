//
//  Ticket.swift
//  Tickezy
//
//  Created by M.A on 4/23/25.
//

import Foundation


struct Ticket: Identifiable, Codable {
    var id = UUID()
    let eventID: UUID
    let seat: String
    let qrCode: String
}
