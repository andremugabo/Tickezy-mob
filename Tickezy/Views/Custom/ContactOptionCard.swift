//
//  ContactOptionCard.swift
//  Tickezy
//
//  Created by M.A on 4/30/25.
//

import SwiftUI

struct ContactOptionCard: View {
    let icon: String
    let method: String
    let maskedValue: String
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(Color.white.opacity(0.2))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text("Via \(method) :")
                    .foregroundColor(.white.opacity(0.8))
                    .font(.subheadline)
                Text(maskedValue)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
            }

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.1))
                )
        )
    }
}
