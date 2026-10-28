import SwiftUI

/// Root screen with the custom bottom bar from the Figma design.
struct MainTabView: View {

    @ObservedObject var viewModel: FridgeViewModel

    @EnvironmentObject private var router: AppRouter

    var body: some View {
        Group {
            switch router.selectedTab {
            case .home:
                FridgeHomeView(viewModel: viewModel)
            case .favorites:
                FavoritesView()
            case .fridge:
                MyFridgeView(viewModel: viewModel)
            case .profile:
                ProfileView(viewModel: viewModel)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            AppBottomBar(
                selectedTab: $router.selectedTab,
                onAdd: router.showAddIngredient
            )
        }
    }
}
