import SwiftUI

import SwiftUI

@MainActor
final class ProjectListViewModel: ObservableObject {
    @Published private(set) var user: DBUser? = nil
    @Published var recommendedProjects: [Project] = []
    @Published var allProjects: [Project] = []
    @Published var isLoading = false

    // Load user details and recommended projects
    func loadUserAndProjects() async throws {
        self.isLoading = true
        defer { self.isLoading = false }

        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)

        // If user has preferences, fetch recommended projects
        if let preferences = user?.preferences, !preferences.isEmpty {
            recommendedProjects = try await ProjectManager.shared.fetchRecommendedProjects(userPreferences: preferences)
        }

        // Fetch all projects
        allProjects = try await ProjectManager.shared.fetchProjects()
    }
}


struct ProjectListView: View {
    @StateObject private var viewModel = ProjectListViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Main Title
                Text("Projects")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.leading)
                    .padding(.top)

                // Recommended Projects Section
                if !viewModel.recommendedProjects.isEmpty {
                    Text("Recommended for You")
                        .font(.headline)
                        .padding(.leading, 8)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) { // Adjusted spacing to prevent overlap
                            ForEach(viewModel.recommendedProjects) { project in
                                NavigationLink(destination: ProjectDetailView(project: project)) {
                                    ProjectCardView(project: project)
                                        .frame(width: 180) // Adjusted width for spacing
                                        .padding(.vertical, 10) // Optional padding to balance card layout
                                }
                            }
                        }
                        .padding(.horizontal, 16) // Outer padding to prevent edge overlap
                    }
                    .padding(.bottom, 10)
                }

                // Other sections (e.g., Web Dev, App Dev, AI)
                sectionWithTitle(title: "Web Development", filterTag: "Web Dev")
                sectionWithTitle(title: "App Development", filterTag: "App Dev")
                sectionWithTitle(title: "AI", filterTag: "AI")
            }
            .padding(.horizontal, 8)
            
            .task {
                do {
                    try await viewModel.loadUserAndProjects()
                } catch {
                    print("Failed to load user or projects: \(error)")
                }
            }
        }
        .refreshable {
                    do {
                        try await viewModel.loadUserAndProjects() // Refresh data on pull down
                    } catch {
                        print("Failed to refresh projects: \(error)")
                    }
                }
        .background(Color(.systemGray6))
    }

    @ViewBuilder
    private func sectionWithTitle(title: String, filterTag: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .padding(.leading, 8)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) { // Consistent spacing to prevent overlap
                    ForEach(viewModel.allProjects.filter { $0.tags.contains(filterTag) }) { project in
                        NavigationLink(destination: ProjectDetailView(project: project)) {
                            ProjectCardView(project: project)
                                .frame(width: 180) // Adjusted width to ensure adequate spacing
                                .padding(.vertical, 10) // Optional vertical padding for balanced layout
                        }
                    }
                }
                .padding(.horizontal, 16) // Outer padding to avoid edge overlap
            }
        }
        .padding(.bottom, 10)
    }
}
