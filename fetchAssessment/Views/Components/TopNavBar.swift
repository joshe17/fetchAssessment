//
//  TopNavBar.swift
//  fetchAssessment
//
//  Created by Joshua Ho on 3/17/24.
//

import SwiftUI

struct TopNavBar: View {
    @Binding var path: [HomeNavigation]
    var hasBackButton: Bool
    
    var body: some View {
        ZStack {
            background
            if hasBackButton == true {
                backButton
            }
            logo
        }
        .frame(maxWidth: .infinity, maxHeight: 50)
    }
    
    private var background: some View {
        Color("periwinkle")
            .edgesIgnoringSafeArea(.all)
            .frame(height: 65)
    }
    
    private var backButton: some View {
        HStack {
            Button {
                _ = path.popLast()
            } label: {
                Image(systemName: "chevron.left")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 20, maxHeight: 20)
                    .foregroundColor(.black)
            }
            Spacer()
        }
        .padding()
    }
    
    private var logo: some View {
        Image(systemName: "birthday.cake.fill")
            .resizable()
            .scaledToFit()
            .frame(maxWidth: 50)
            .foregroundColor(.black)
    }
}

#Preview {
    TopNavBar(path: .constant([]), hasBackButton: true)
}
