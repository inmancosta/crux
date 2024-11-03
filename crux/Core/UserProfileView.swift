import SwiftUI

struct UserProfileView: View {
    let userId: String
    @State private var user: DBUser?
    @State private var isLoading = false

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading user profile...")
            } else if let user = user {
                VStack(spacing: 10) {
                    // Profile Picture
                    if let photoUrl = user.photoUrl, let url = URL(string: photoUrl) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1))
                        } placeholder: {
                            ProgressView()
                        }
                    } else {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 100, height: 100)
                    }

                    // User Info
                    Text(user.name)
                        .font(.system(size: 22, weight: .bold, design: .monospaced))
                    Text("Email: \(user.email)")
                        .font(.system(size: 16, design: .monospaced))
                        .foregroundColor(.secondary)
                    Text("School/Grad Year: \(user.schoolGradYear)")
                        .font(.system(size: 16, design: .monospaced))
                    Text("Github: \(user.githubUsername ?? "Not available")")
                        .font(.system(size: 16, design: .monospaced))
                }
                .padding()
            } else {
                Text("User not found")
                    .foregroundColor(.secondary)
            }
        }
        .onAppear {
            loadUserProfile()
        }
        .navigationTitle("User Profile")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func loadUserProfile() {
        isLoading = true
        Task {
            do {
                let fetchedUser = try await UserManager.shared.getUser(userId: userId)
                self.user = fetchedUser
            } catch {
                print("Failed to load user profile: \(error)")
            }
            isLoading = false
        }
    }
}
