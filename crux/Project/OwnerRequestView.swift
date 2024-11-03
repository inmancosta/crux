import SwiftUI

struct OwnerRequestsView: View {
    let requests: [ProjectOwnerViewModel.ProjectRequest]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Join Requests")
                    .font(.system(size: 28, weight: .bold, design: .monospaced))

                // Loop through each project that has requests
                ForEach(requests, id: \.projectId) { projectRequest in
                    VStack(alignment: .leading, spacing: 10) {
                        Text(projectRequest.projectName)
                            .font(.system(size: 18, weight: .semibold, design: .monospaced))
                            .padding(.bottom, 5)

                        // List each requester for this project
                        ForEach(projectRequest.requesters, id: \.userId) { requester in
                            HStack {
                                NavigationLink(destination: UserProfileView(userId: requester.userId)) {
                                    Text(requester.name)
                                        .font(.system(size: 16, design: .monospaced))
                                        .foregroundColor(.blue)
                                        .underline()
                                }

                                Spacer()

                                Button(action: {
                                    Task {
                                        try await ProjectManager.shared.acceptJoinRequest(projectId: projectRequest.projectId, userId: requester.userId)
                                    }
                                }) {
                                    Text("Accept")
                                        .foregroundColor(.green)
                                }

                                Button(action: {
                                    Task {
                                        try await ProjectManager.shared.declineJoinRequest(projectId: projectRequest.projectId, userId: requester.userId)
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
