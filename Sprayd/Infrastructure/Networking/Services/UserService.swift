//
//  UserService.swift
//  Sprayd
//
//  Created by лизо4ка курунок on 09.04.2026.
//

import Foundation

final class UserService {

    private let sender: Sender

    init(sender: Sender) {
        self.sender = sender
    }

    // MARK: - Models

    struct UserProfileResponse: Codable {
        let id: UUID?
        let email: String
        let username: String
        let bio: String
        let avatar: String?
        let posted: [UUID]
        let visited: [UUID]
        let liked: [UUID]
    }

    private struct UpdateUserRequest: Codable {
        let username: String?
        let bio: String?
        let avatar: Data?
        let currentPassword: String?
        let newPassword: String?
    }

    // MARK: - API

    /// GET /users/:id
    func getUser(id: UUID) async throws -> UserProfileResponse {
        try await sender.send(
            endpoint: "/users/\(id.uuidString)",
            method: .get
        )
    }

    /// GET /users/me (Bearer token)
    func getCurrentUser(token: String) async throws -> UserProfileResponse {
        try await sender.send(
            endpoint: "/users/me",
            method: .get,
            headers: ["Authorization": "Bearer \(token)"]
        )
    }

    /// PATCH /users/me (Bearer token)
    func changeUsername(token: String, username: String) async throws -> UserProfileResponse {
        try await patchCurrentUser(
            token: token,
            request: UpdateUserRequest(
                username: username,
                bio: nil,
                avatar: nil,
                currentPassword: nil,
                newPassword: nil
            )
        )
    }

    /// PATCH /users/me (Bearer token)
    func changeBio(token: String, bio: String) async throws -> UserProfileResponse {
        try await patchCurrentUser(
            token: token,
            request: UpdateUserRequest(
                username: nil,
                bio: bio,
                avatar: nil,
                currentPassword: nil,
                newPassword: nil
            )
        )
    }

    /// PATCH /users/me (Bearer token)
    func changeAvatar(token: String, imageData: Data) async throws -> UserProfileResponse {
        try await patchCurrentUser(
            token: token,
            request: UpdateUserRequest(
                username: nil,
                bio: nil,
                avatar: imageData,
                currentPassword: nil,
                newPassword: nil
            )
        )
    }

    /// PATCH /users/me (Bearer token)
    func changePassword(
        token: String,
        currentPassword: String,
        newPassword: String
    ) async throws -> UserProfileResponse {
        try await patchCurrentUser(
            token: token,
            request: UpdateUserRequest(
                username: nil,
                bio: nil,
                avatar: nil,
                currentPassword: currentPassword,
                newPassword: newPassword
            )
        )
    }

    /// DELETE /users/me (Bearer token)
    func deleteAccount(token: String) async throws {
        try await sender.sendEmpty(
            endpoint: "/users/me",
            method: .delete,
            headers: ["Authorization": "Bearer \(token)"]
        )
    }

    private func authorizedJSONHeaders(token: String) -> [String: String] {
        [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
    }

    private func patchCurrentUser(
        token: String,
        request: UpdateUserRequest
    ) async throws -> UserProfileResponse {
        let body = try JSONEncoder().encode(request)
        return try await sender.send(
            endpoint: "/users/me",
            method: .patch,
            headers: authorizedJSONHeaders(token: token),
            body: body
        )
    }
}
