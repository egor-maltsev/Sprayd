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

    private struct UpdateUsernameRequest: Codable {
        let username: String
    }

    private struct UpdateBioRequest: Codable {
        let bio: String
    }

    private struct UpdateAvatarRequest: Codable {
        let img: Data
    }

    private struct ChangePasswordRequest: Codable {
        let currentPassword: String
        let newPassword: String
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

    /// PATCH /users/me/username (Bearer token)
    func changeUsername(token: String, username: String) async throws -> UserProfileResponse {
        let body = try JSONEncoder().encode(UpdateUsernameRequest(username: username))
        return try await sender.send(
            endpoint: "/users/me/username",
            method: .patch,
            headers: authorizedJSONHeaders(token: token),
            body: body
        )
    }

    /// PATCH /users/me/bio (Bearer token)
    func changeBio(token: String, bio: String) async throws -> UserProfileResponse {
        let body = try JSONEncoder().encode(UpdateBioRequest(bio: bio))
        return try await sender.send(
            endpoint: "/users/me/bio",
            method: .patch,
            headers: authorizedJSONHeaders(token: token),
            body: body
        )
    }

    /// POST /users/me/avatar (Bearer token)
    func changeAvatar(token: String, imageData: Data) async throws -> UserProfileResponse {
        let body = try JSONEncoder().encode(UpdateAvatarRequest(img: imageData))
        return try await sender.send(
            endpoint: "/users/me/avatar",
            method: .post,
            headers: authorizedJSONHeaders(token: token),
            body: body
        )
    }

    /// PATCH /users/me/password (Bearer token)
    func changePassword(
        token: String,
        currentPassword: String,
        newPassword: String
    ) async throws {
        let body = try JSONEncoder().encode(
            ChangePasswordRequest(
                currentPassword: currentPassword,
                newPassword: newPassword
            )
        )
        try await sender.sendEmpty(
            endpoint: "/users/me/password",
            method: .patch,
            headers: authorizedJSONHeaders(token: token),
            body: body
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
}
