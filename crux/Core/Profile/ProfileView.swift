import SwiftUI

//auth model is saved on device (synchronous), user collection is asynchronous, from the server

@MainActor
final class ProfileViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil
    @Published var showOnboarding = false // Track whether to show onboarding
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
        
        // Check if user has completed onboarding
        if let user = self.user, !user.isOnboarded {
            self.showOnboarding = true // If not onboarded, show onboarding view
        }
    }
}


struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
            if viewModel.showOnboarding {
                // Show onboarding view if user hasn't completed onboarding
                OnboardingView(showOnboarding: $viewModel.showOnboarding, userId: viewModel.user?.userId ?? "")
            } else {
                // Show profile information after onboarding is complete
                List {
                    if let user = viewModel.user {
                        Text("UserID: \(user.userId) ")
                    }
                }
                .task {
                    do {
                        try await viewModel.loadCurrentUser()
                    } catch {
                        print("Failed to load user: \(error)")
                    }
                }
                .navigationTitle("Profile")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink {
                            SettingsView(showSignInView: $showSignInView)
                        } label: {
                            Image(systemName: "gear")
                                .font(.headline)
                        }
                    }
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(showSignInView: .constant(false))
    }
}



