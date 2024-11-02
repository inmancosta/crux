<div align="center">
    <img src="https://github.com/user-attachments/assets/fc666638-d6f8-48dc-a5f3-22454cf22237" alt="Screenshot 1" width="250"/>
    <img src="https://github.com/user-attachments/assets/5564727f-c3a4-48db-9e89-3dbba33d2551" alt="Screenshot 2" width="250"/>
    <img src="https://github.com/user-attachments/assets/9e746de6-9b0f-432c-a68f-5d98a3d84ab5" alt="Screenshot 3" width="250"/>
</div>


# Crux

**Crux** is an app designed to help project owners connect with potential collaborators, allowing users to request to join projects, and giving project owners the tools to manage these requests efficiently. The app streamlines the process of building project teams by providing a centralized platform where users can browse, request to join, and participate in various projects.

## Problem Statement


Finding the right people to work with on technical or creative projects can be challenging, especially in academic or professional environments where people may not know each other's skills or interests. Traditional collaboration tools and forums lack a straightforward way for project owners to vet potential collaborators or for users to express interest in joining specific projects.

**Crux** addresses these pain points by:
- Providing project owners with an easy way to manage join requests.
- Allowing potential collaborators to browse projects and request to join those that match their interests and skills.
- Giving project owners control to accept or decline join requests and maintain a well-curated team.

## Features

- **Browse Projects**: Users can explore projects available on the platform, view project details (such as description, skills required, difficulty level, etc.), and decide which ones they'd like to join.
- **Request to Join**: Interested users can request to join a project directly from the project details page.
- **Request Management for Project Owners**: Project owners have a dedicated view where they can see all pending join requests for their projects, along with requesters' names.
- **Accept/Decline Requests**: Project owners can accept or decline join requests. Accepting a request adds the user to the project’s member list, while declining simply removes the request.
- **Real-time Updates**: The app uses Firestore to enable real-time updates, so project owners see requests as soon as they’re submitted, and users are notified of their request status promptly.


## How It Works

1. **User Sign-up/Sign-in**: Users sign up or log in to the app using Firebase Authentication.
2. **Project Creation**: Project owners can create new projects, specifying the project name, description, required skills, difficulty level, and other relevant details.
3. **Browse and Request to Join**: Other users can browse projects and request to join projects they’re interested in.
4. **Join Request Management**: Project owners receive real-time notifications of new join requests and can accept or decline each request.
   - **Accepting** a request moves the requester to the project's member list.
   - **Declining** simply removes the request without adding the user to the project.


