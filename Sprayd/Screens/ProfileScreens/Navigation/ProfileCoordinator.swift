//
//  ProfileCoordinator.swift
//  Sprayd
//
//  Created by loxxy on 03.04.2026.
//

import SwiftUI
import Combine

final class ProfileCoordinator: ObservableObject {
    // MARK: - Fields
    @Published var path: [ProfileRoute] = []
    private let artAdditionRepository: ArtAdditionRepository
    private let authorizationService: AuthorizationService
    private let userService: UserService
    private let tokenStore: SessionTokenStoring
    private let imageLoaderService: ImageLoaderService

    // MARK: - Lifecycle
    init(
        authorizationService: AuthorizationService,
        imageLoaderService: ImageLoaderService,
        userService: UserService,
        tokenStore: SessionTokenStoring,
        artAdditionRepository: ArtAdditionRepository

    ) {
        self.authorizationService = authorizationService
        self.imageLoaderService = imageLoaderService
        self.userService = userService
        self.tokenStore = tokenStore
        self.artAdditionRepository = artAdditionRepository
    }
    // MARK: - Navigation logic
    func openAddArt() {
        path.append(.addArt)
    }

    func openSignIn() {
        path.append(.signIn)
    }

    func openCreateAccount() {
        path.append(.createAccount)
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeAll()
    }
    
    @ViewBuilder
    func makeRootView() -> some View {
        if tokenStore.hasToken() {
            MyProfileAssembly(
                authorizationService: authorizationService,
                userService: userService,
                tokenStore: tokenStore,
                imageLoaderService: imageLoaderService
            )
            .build(
                onAddArt: { [weak self] in
                    self?.openAddArt()
                }
            )
        } else {
            ChooseAccountAssembly().build(
                onSignInTapped: { [weak self] in
                    self?.openSignIn()
                },
                onCreateAccountTapped: { [weak self] in
                    self?.openCreateAccount()
                },
                onProceedWithoutAccountTapped: { [weak self] in
                    self?.popToRoot()
                }
            )
        }
    }
    
    @ViewBuilder
    func destination(for route: ProfileRoute) -> some View {
        switch (route) {
        case .addArt:
            ArtAdditionView(
                onBackButtonTapped: { [weak self] in
                    self?.pop()},
                viewModel: ArtAdditionViewModel(
                    repository: artAdditionRepository
                )
            )
        case .signIn:
            SignInAssembly(
                authorizationService: authorizationService,
                tokenStore: tokenStore
            )
            .build(onLoginSuccess: { [weak self] in
                self?.popToRoot()
            })
        case .createAccount:
            CreateAccountAssembly(
                authorizationService: authorizationService,
                tokenStore: tokenStore
            )
            .build(onRegistrationSuccess: { [weak self] in
                self?.popToRoot()
            })
        }
    }
}
