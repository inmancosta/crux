import SwiftUI

@MainActor
final class ProjectViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var description: String = ""
    @Published var tags: [String] = []
    @Published var skills: [String] = []
    @Published var difficultyLevel: String = ""
    
    // Method to upload the project
    func uploadProject() async throws {
        guard let authUser = try? AuthenticationManager.shared.getAuthenticatedUser() else {
            print("User not authenticated")
            return
        }
        
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
}
