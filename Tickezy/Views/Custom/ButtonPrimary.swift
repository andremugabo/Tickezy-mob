//
//  ButtonPrimary.swift
//  Tickezy
//
//  Created by M.A on 4/23/25.
//

import SwiftUI

struct ButtonPrimary: View {
    let title: String
    let action: ()->Void
    
    var body: some View {
        Button(action: action){
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(10)
                .background(Color.brandBlue)
                .foregroundColor(.white)
                .cornerRadius(20)
            
        }
        
    }
}

#Preview {
    ButtonPrimary(title: "Btn"){}
}
