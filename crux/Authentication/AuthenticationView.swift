//
//  AuthenticationView.swift
//  crux
//
//  Created by Crist Costa on 10/14/24.
//

import SwiftUI

struct AuthenticationView: View {
    
    @Binding var showSignInView: Bool
    
    var body: some View {
        
        VStack {
            
            NavigationLink{
                SignInEmailView(showSignInView: $showSignInView)
            } label : {
                Text("sign in with email")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 55) // Ensure it takes the full width
                    .background(Color.blue)
                    .cornerRadius(10)
                    
            }
            Spacer()
        }
            .padding()
            .navigationTitle("sign in")
           
    }
}

//#Preview {
//    NavigationStack{
//        AuthenticationView(showSignInView: si)
//    }
//}
