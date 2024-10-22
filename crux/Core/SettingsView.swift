import SwiftUI

@MainActor


final class SettingsViewModel: ObservableObject {
    
    
    func signOut() throws {
       try AuthenticationManager.shared.signOut()
        
    }
    
    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func updateEmail() async throws {
        let email = "hello123@gmail.com"
        try await AuthenticationManager.shared.updateEmail(email: email)
    }
    
    func updatePassword() async throws {
        let password = "hello123"
        try await AuthenticationManager.shared.updatePassword(password: password)
    }
}

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        List {
            Button("Log out") {
                Task {
                    do {
                        try viewModel.signOut()
                        showSignInView = true
                        dismiss()
                    } catch {
                        print(error)
                    }
                }
            }
            
            Section {
                
                Button("reset password") {
                    Task {
                        do {
                            try await viewModel.resetPassword()
                            print("PASSWORD RESET")
                        } catch {
                            print(error)
                        }
                    }
                }
                
                Button("update password") {
                    Task {
                        do {
                            try await viewModel.updatePassword()
                            print("PASSWORD UPDTED")
                        } catch {
                            print(error)
                        }
                    }
                }
                
                Button("update email") {
                    Task {
                        do {
                            try await viewModel.updateEmail()
                            print("EMAIL UPDATED")
                        } catch {
                            print(error)
                        }
                    }
                }
                
            } header: {
                Text("Email functions")
            }
        }
        .navigationBarTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView(showSignInView: .constant(false))
        }
    }
}


