import SwiftUI

struct OnboardingCoordinatorView: View {
    @ObservedObject var coordinator: OnboardingCoordinator
    
    private var onboardingStepTransition: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .trailing),
            removal: .move(edge: .leading)
        )
    }

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            ZStack {
                switch coordinator.step {
                case .welcome:
                    coordinator.makeWelcomeView()
                        .transition(onboardingStepTransition)
                case .chooseAccount:
                    coordinator.makeChooseAccountView()
                        .transition(onboardingStepTransition)
                }
            }
            .navigationDestination(for: OnboardingRoute.self) { route in
                coordinator.destination(for: route)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}
