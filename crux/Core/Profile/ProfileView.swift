import SwiftUI

//auth model is saved on device (synchronous), user collection is asynchronous, from the server

@MainActor
final class ProfileViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil

    func loadCurrentUser() async throws{
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user  = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
}

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool

    var body: some View {
        List {
            if let user = viewModel.user{
                Text("UserID: \(user.userId) ")
            }
        }
        .task {
            try? await viewModel.loadCurrentUser()
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

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(showSignInView: .constant(false))
    }
}
//
//import SwiftUI
//
//@MainActor
//final class ProfileViewModel: ObservableObject {
//    
//    @Published private(set) var user: AuthDataResultModel? = nil
//
//    func loadCurrentUser() throws {
//        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
//        self.user = authDataResult // Set the user here
//    }
//}
//
//struct ProfileView: View {
//    @StateObject private var viewModel = ProfileViewModel()
//    @Binding var showSignInView: Bool
//
//    var body: some View {
//        List {
//            if let user = viewModel.user {
//                Text("UserID: \(user.uid)")
//            }
//        }
//        .onAppear {
//            try? viewModel.loadCurrentUser() // Try loading the current user
//        }
//        .navigationTitle("Profile")
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                NavigationLink {
//                    SettingsView(showSignInView: $showSignInView)
//                } label: {
//                    Image(systemName: "gear")
//                        .font(.headline)
//                }
//            }
//        }
//    }
//}
//
//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView(showSignInView: .constant(false))
//    }
//}
