//
//  OwnerRequestView.swift
//  crux
//
//  Created by Crist Costa on 11/2/24.
//

import SwiftUI

import SwiftUI

struct OwnerRequestsView: View {
    @StateObject private var viewModel = ProjectOwnerViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Join Requests")
                        .font(.largeTitle)
                        .bold()
                    
                    // Loop through each project that has requests
                    ForEach(viewModel.projectRequests, id: \.projectId) { projectRequest in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(projectRequest.projectName)
                                .font(.headline)
                                .padding(.bottom, 5)
                            
                            // List each requester for this project
                            ForEach(projectRequest.requesters, id: \.userId) { requester in
                                HStack {
                                    Text(requester.name)
                                        .font(.body)
                                    
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
            .onAppear {
                Task {
                    await viewModel.loadAllRequests()
                }
            }
//            .navigationTitle("Project Requests")
        }
    }
}
