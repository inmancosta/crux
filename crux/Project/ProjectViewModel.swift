import SwiftUI

@MainActor
final class ProjectViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var description: String = ""
    @Published var tags: [String] = []
    @Published var skills: [String] = []
    @Published var skillsInput: String = ""  // Add this line
    @Published var difficultyLevel: String = "Easy" // Set a default value

    
    @Published var projects: [Project] = []
    // Method to upload the project
    func uploadProject() async throws {
        guard let authUser = try? AuthenticationManager.shared.getAuthenticatedUser() else {
            print("User not authenticated")
            return
        }

        // Convert skillsInput (comma-separated) into an array
        let skillsArray = skillsInput.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        skills = skillsArray

        // Create the project with the current user's details
        let project = Project(
            name: name,
            description: description,
            tags: tags,
            createdBy: authUser.email ?? "Unknown",
            creatorId: authUser.uid,
            skills: skills,
            difficultyLevel: difficultyLevel
        )

        // Upload the project to Firestore
        try await ProjectManager.shared.uploadProject(project: project, userId: authUser.uid)
    }
    
    func fetchProjects() async throws {
            let fetchedProjects = try await ProjectManager.shared.fetchProjects()
            self.projects = fetchedProjects
        }
}
