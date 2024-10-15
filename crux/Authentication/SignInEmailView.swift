//
//  SignInEmailView.swift
//  crux
//
//  Created by Crist Costa on 10/14/24.
//

import SwiftUI


@MainActor
final class SignInEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func signIn()  {
        guard !email.isEmpty, !password.isEmpty else {
            print("no email or password found.")
            return
        }
        
        Task{
            do{
                let returnedUserData = try await AuthenticationManager.shared.createUser(email: email, password: password)
            } catch {
                print("error: \(error)")
            }
        }
    }
    
    
}

struct SignInEmailView: View {
    
    @StateObject private var viewModel = SignInEmailViewModel()
    
    var body: some View {
        VStack{
            TextField("Email...", text: $viewModel.email)
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)
            
            SecureField("Password...", text: $viewModel.password)
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)
            
            Button {
                viewModel.signIn()
            } label: {
                    Text("sign in")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 55) // Ensure it takes the full width
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            
                
            Spacer()

        }
        .padding(20)
        .navigationTitle("Sign In With Email")
    }
    
}

    struct SignInEmail_Preview: PreviewProvider{
        static var previews: some View{
            NavigationStack{
                SignInEmailView()
            }
        }
    }
    
