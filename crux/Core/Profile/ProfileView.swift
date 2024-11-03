import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published private(set) var user: DBUser? = nil
    @Published var joinRequests: [ProjectOwnerViewModel.ProjectRequest] = []
    @Published var showOnboarding = false // Track whether to show onboarding
    @Published var isLoading = false // Track loading state

    func loadCurrentUser() async throws {
        self.isLoading = true
        defer { self.isLoading = false }
        
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
        
        // Load join requests for user's projects
        if let user = self.user {
            try await loadJoinRequests(for: user)
        }
    }
    
    private func loadJoinRequests(for user: DBUser) async throws {
        // Fetch projects created by the user and load join requests
        let projects = try await ProjectManager.shared.fetchProjectsCreatedByUser(userId: user.userId)
        
        var allRequests: [ProjectOwnerViewModel.ProjectRequest] = []
        
        for project in projects {
            let requesters = try await ProjectManager.shared.fetchRequesters(for: project.id)
            allRequests.append(ProjectOwnerViewModel.ProjectRequest(
                projectId: project.id,
                projectName: project.name,
                requesters: requesters
            ))
        }
        
        self.joinRequests = allRequests
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
                            profilePictureSection(for: user)
                            profileInformationSection(for: user)
                            joinRequestsSection(viewModel: viewModel)  // Pass viewModel to joinRequestsSection
                        }
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
    
    // Profile Picture Section
    private func profilePictureSection(for user: DBUser) -> some View {
        HStack {
            if let photoUrl = user.photoUrl, let url = URL(string: photoUrl) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1))
                } placeholder: {
                    ProgressView()
                }
            } else {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 80, height: 80)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(user.name)
                    .font(.system(size: 18, weight: .bold, design: .monospaced))
                Text(user.email)
                    .font(.system(size: 14, weight: .regular, design: .monospaced))
                    .foregroundColor(.secondary)
            }
            .padding(.leading, 8)
        }
        .padding(.vertical)
    }

    // Profile Information Section
    private func profileInformationSection(for user: DBUser) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("School/Grad Year: \(user.schoolGradYear)")
                .font(.system(size: 16, weight: .regular, design: .monospaced))
            Text("Github: \(user.githubUsername ?? "Not available")")
                .font(.system(size: 16, weight: .regular, design: .monospaced))
            Text("Preferences: \(user.preferences.joined(separator: ", "))")
                .font(.system(size: 16, weight: .regular, design: .monospaced))
        }
        .padding(.vertical)
    }

    // Join Requests Section with Correct ViewModel Passing
    private func joinRequestsSection(viewModel: ProfileViewModel) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            OwnerRequestsView(requests: viewModel.joinRequests)
        }
        .padding(.vertical)
    }
}
