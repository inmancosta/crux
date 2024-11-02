import SwiftUI

//auth model is saved on device (synchronous), user collection is asynchronous, from the server

@MainActor
final class ProfileViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil
    @Published var showOnboarding = false // Track whether to show onboarding
    @Published var isLoading = false // Track loading state

    func loadCurrentUser() async throws {
        self.isLoading = true // Start loading
        defer { self.isLoading = false } // Ensure loading state is turned off when finished

        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        
        // Clear the current user data before fetching the new user data
        self.user = nil
        
        // Fetch user data
        let fetchedUser = try await UserManager.shared.getUser(userId: authDataResult.uid)
        self.user = fetchedUser

        // Check if the user has completed onboarding
        if let user = self.user, !user.isOnboarded {
            self.showOnboarding = true // Show onboarding view if user is not onboarded
        }
    }
    
    func signOut() throws {
            try AuthenticationManager.shared.signOut()
            self.user = nil // Clear user data on sign-out
        }
}

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading user data...")
                } else if viewModel.showOnboarding {
                    OnboardingView(showOnboarding: $viewModel.showOnboarding, userId: viewModel.user?.userId ?? "")
                } else {
                    List {
                        if let user = viewModel.user {
                            // Profile Picture Display
                            HStack {
                                if let photoUrl = user.photoUrl, let url = URL(string: photoUrl) {
                                    AsyncImage(url: url) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 100, height: 100)
                                            .clipShape(Circle())
                                    } placeholder: {
                                        ProgressView()
                                    }
                                } else {
                                    Circle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: 100, height: 100)
                                }
                                Text("Profile Picture")
                                    .font(.headline)
                                    .padding(.leading)
                            }
                            
                            // Profile Information
                            Text("NAME: \(user.name)")
                            Text("School/Grad Year: \(user.schoolGradYear)")
                            Text("Email: \(user.email)")
                            Text("Github: \(user.githubUsername ?? "Not available")")
                            Text("PREFS: \(user.preferences.joined(separator: ", "))")
                            
                        }
                        OwnerRequestsView()
                    }
                    .refreshable {
                        do {
                            try await viewModel.loadCurrentUser()
                        } catch {
                            print("Failed to refresh user: \(error)")
                        }
                    }
                    .navigationTitle("Profile")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            // Navigation link to SettingsView
                            NavigationLink(destination: SettingsView(showSignInView: $showSignInView, profileViewModel: viewModel)) {
                                Image(systemName: "gear")
                                    .font(.headline)
                            }
                        }
                        ToolbarItem(placement: .navigationBarLeading) {
                                                    NavigationLink(destination: CreateProjectView()) {
                                                        Image(systemName: "plus")
                                                            .font(.headline)
                                                    }
                                                }
                    }
                }
            }
            .task {
                do {
                    try await viewModel.loadCurrentUser()
                } catch {
                    print("Failed to load user: \(error)")
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
