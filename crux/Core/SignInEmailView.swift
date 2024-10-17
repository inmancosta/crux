import SwiftUI

@MainActor
final class SignInEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    // Method to handle sign-up
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found")
            return
        }
        
        let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
        try await UserManager.shared.createNewUser(auth: authDataResult)
    }
    
    // Method to handle sign-in
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found")
            return
        }
        
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
    }
}

struct SignInEmailView: View {
    
    @StateObject private var viewModel = SignInEmailViewModel()
    @Binding var showSignInView: Bool
    @State private var isSignUp = false // To toggle between sign-up and sign-in
    @State private var showAlert = false // To show the alert
    @State private var errorMessage = "" // Store error message
    
    var body: some View {
        VStack {
            // Header text
            Text(isSignUp ? "Sign Up" : "Sign In")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 20)
            
            // TextField for email input
            TextField("Email...", text: $viewModel.email)
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)
            
            // SecureField for password input
            SecureField("Password...", text: $viewModel.password)
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)
            
            // Button to toggle between sign-up and sign-in
            Button {
                Task {
                    do {
                        if isSignUp {
                            try await viewModel.signUp()
                        } else {
                            try await viewModel.signIn()
                        }
                        showSignInView = false
                    } catch {
                        errorMessage = "Incorrect Password"
                        showAlert = true // Trigger alert
                    }
                }
            } label: {
                Text(isSignUp ? "Sign Up" : "Sign In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 55)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(errorMessage), // Display the error message
                    dismissButton: .default(Text("OK"))
                )
            }
            
            // Toggle between sign-in and sign-up
            HStack {
                Text(isSignUp ? "Already have an account?" : "Don't have an account?")
                    .foregroundColor(.gray)
                Button {
                    isSignUp.toggle() // Toggle the state
                } label: {
                    Text(isSignUp ? "Sign In" : "Sign Up")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
            }
            .padding(.top, 20)
            
            Spacer()
        }
        .padding(20)
        
    }
}

struct SignInEmail_Preview: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignInEmailView(showSignInView: .constant(false))
        }
    }
}
