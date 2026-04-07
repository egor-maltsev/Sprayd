//
//  CreateAccountView.swift
//  Sprayd
//
//  Created by loxxy on 06.04.2026.
//

import SwiftUI

struct CreateAccountView: View {
    // MARK: - Constants
    private enum Const {
        static let buttonHeight: CGFloat = 56
        static let buttonCornerRadius: CGFloat = 28

        static let titleText = "Create\naccount"
        static let usernameTitle = "Username"
        static let emailTitle = "Email"
        static let passwordTitle = "Password"
        static let repeatPasswordTitle = "Password"
        static let usernamePlaceholder = "Enter username*"
        static let emailPlaceholder = "Enter email*"
        static let passwordPlaceholder = "Enter password*"
        static let repeatPasswordPlaceholder = "Repeat password*"
        static let continueText = "Continue"
    }

    // MARK: - Fields
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var repeatedPassword: String = ""

    let onContinueTapped: () -> Void

    // MARK: - Body
    var body: some View {
        ZStack {
            RadialGradient.onboardingBackground
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: Metrics.doubleModule) {
                Text(Const.titleText)
                    .font(.ClimateCrisis52)
                    .foregroundStyle(Color.black)

                AuthInputField(
                    title: Const.usernameTitle,
                    placeholder: Const.usernamePlaceholder,
                    text: $username,
                    textContentType: .username
                )

                AuthInputField(
                    title: Const.emailTitle,
                    placeholder: Const.emailPlaceholder,
                    text: $email,
                    textContentType: .emailAddress
                )

                AuthInputField(
                    title: Const.passwordTitle,
                    placeholder: Const.passwordPlaceholder,
                    text: $password,
                    isSecure: true,
                    textContentType: .oneTimeCode
                )

                AuthInputField(
                    title: Const.repeatPasswordTitle,
                    placeholder: Const.repeatPasswordPlaceholder,
                    text: $repeatedPassword,
                    isSecure: true,
                    textContentType: .oneTimeCode
                )

                continueButton
                    .padding(.top, Metrics.doubleModule)

                Spacer()
            }
            .padding(.horizontal, Metrics.tripleModule)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    // MARK: - Subviews
    private var continueButton: some View {
        Button(action: onContinueTapped) {
            HStack {
                Text(Const.continueText)
                    .font(.InstrumentMedium20)
                    .foregroundStyle(Color.white)

                Spacer()

                Icons.chevronRight
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.white)
            }
            .padding(.horizontal, Metrics.tripleModule)
            .frame(height: Const.buttonHeight)
            .background(Color.black)
            .clipShape(RoundedRectangle(cornerRadius: Const.buttonCornerRadius))
        }
        .buttonStyle(.plain)
        .padding(.horizontal, Metrics.tripleModule)
    }
}

// MARK: - Preview
#Preview {
    CreateAccountView(onContinueTapped: {})
}
