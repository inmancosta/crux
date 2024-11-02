import SwiftUI
import FirebaseFirestore


@MainActor
final class ProjectOwnerViewModel: ObservableObject {
    struct ProjectRequest {
        let projectId: String
        let projectName: String
        var requesters: [(userId: String, name: String)]
    }
    
    @Published var projectRequests: [ProjectRequest] = []
    
    // Default initializer
    init() {
        Task {
            await loadAllRequests()
        }
    }
    
    // Initializer for injecting sample data
    init(sampleData: [ProjectRequest]) {
        self.projectRequests = sampleData
    }
    
    // Load all join requests for the owner’s projects
    func loadAllRequests() async {
        do {
            // Fetch projects created by the owner
            let userId = try await AuthenticationManager.shared.getAuthenticatedUser().uid
            let projects = try await ProjectManager.shared.fetchProjectsCreatedByUser(userId: userId)
            
            var allRequests: [ProjectRequest] = []
            
            for project in projects {
                // Fetch requesters for each project
                let requesters = try await ProjectManager.shared.fetchRequesters(for: project.id)
                allRequests.append(ProjectRequest(
                    projectId: project.id,
                    projectName: project.name,
                    requesters: requesters
                ))
            }
            
            self.projectRequests = allRequests
        } catch {
            print("Failed to load requests: \(error)")
        }
    }
    
    // Accept a join request
    func acceptJoinRequest(projectId: String, userId: String) async {
        do {
            try await ProjectManager.shared.acceptJoinRequest(projectId: projectId, userId: userId)
            // Remove the requester from the local list
            if let projectIndex = projectRequests.firstIndex(where: { $0.projectId == projectId }) {
                projectRequests[projectIndex].requesters.removeAll { $0.userId == userId }
            }
        } catch {
            print("Failed to accept join request: \(error)")
        }
    }
    
    // Decline a join request
    func declineJoinRequest(projectId: String, userId: String) async {
        do {
            try await ProjectManager.shared.declineJoinRequest(projectId: projectId, userId: userId)
            // Remove the requester from the local list
            if let projectIndex = projectRequests.firstIndex(where: { $0.projectId == projectId }) {
                projectRequests[projectIndex].requesters.removeAll { $0.userId == userId }
            }
        } catch {
            print("Failed to decline join request: \(error)")
        }
    }
}
