//struct OwnerRequestsView: View {
import SwiftUI


struct OwnerRequestsView: View {
    @StateObject private var viewModel = ProjectOwnerViewModel()
    
    init(sampleData: [ProjectOwnerViewModel.ProjectRequest]? = nil) {
        if let sampleData = sampleData {
            // Set the sample data directly in the view model
            _viewModel = StateObject(wrappedValue: ProjectOwnerViewModel(sampleData: sampleData))
        } else {
            _viewModel = StateObject(wrappedValue: ProjectOwnerViewModel())
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Join Requests")
                    .font(.system(size: 28, weight: .bold, design: .monospaced))
                
                // Loop through each project that has requests
                ForEach(viewModel.projectRequests, id: \.projectId) { projectRequest in
                    VStack(alignment: .leading, spacing: 10) {
                        Text(projectRequest.projectName)
                            .font(.system(size: 18, weight: .semibold, design: .monospaced))
                            .padding(.bottom, 5)
                        
                        // List each requester for this project
                        ForEach(projectRequest.requesters, id: \.userId) { requester in
                            HStack {
                                Text(requester.name)
                                    .font(.system(size: 16, design: .monospaced))
                                
                                Spacer()
                                
                                Button(action: {
                                    Task {
                                        await viewModel.acceptJoinRequest(projectId: projectRequest.projectId, userId: requester.userId)
                                    }
                                }) {
                                    Text("Accept")
                                        .foregroundColor(.green)
                                }
                                
                                Button(action: {
                                    Task {
                                        await viewModel.declineJoinRequest(projectId: projectRequest.projectId, userId: requester.userId)
                                    }
                                }) {
                                    Text("Decline")
                                        .foregroundColor(.red)
                                }
                            }
                            .padding(.vertical, 2)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
                }
            }
            .padding()
        }
    }
}


struct OwnerRequestsView_Previews: PreviewProvider {
    static var previews: some View {
        // Define sample data for preview
        let sampleRequests = [
            ProjectOwnerViewModel.ProjectRequest(
                projectId: "1",
                projectName: "Sample Project 1",
                requesters: [
                    (userId: "user1", name: "Alice Johnson"),
                    (userId: "user2", name: "Bob Smith")
                ]
            ),
            ProjectOwnerViewModel.ProjectRequest(
                projectId: "2",
                projectName: "Sample Project 2",
                requesters: [
                    (userId: "user3", name: "Charlie Brown"),
                    (userId: "user4", name: "Diana Prince")
                ]
            )
        ]
        
        // Pass sample data to the OwnerRequestsView
        OwnerRequestsView(sampleData: sampleRequests)
            .previewLayout(.sizeThatFits)
    }
}

