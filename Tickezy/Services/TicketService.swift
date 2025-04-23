//
//  TicketService.swift
//  Tickezy
//
//  Created by M.A on 4/23/25.
//

import Foundation


final class TicketService: ObservableObject {
    static let shared = TicketService()
    @Published var tickets: [Ticket] = []
    private init(){}
}
