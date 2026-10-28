import SwiftUI

enum OnlineRecipeSource: String, CaseIterable, Identifiable {
    case live
    case mockSuccess
    case mockEmpty
    case mockTransport
    case mockHTTP
    case mockDecoding

    var id: Self { self }

    var title: String {
        switch self {
        case .live:
            return "Live API"
        case .mockSuccess:
            return "Mock Success"
        case .mockEmpty:
            return "Mock Empty"
        case .mockTransport:
            return "Transport Error"
        case .mockHTTP:
            return "HTTP Error"
        case .mockDecoding:
            return "Decoding Error"
        }
    }
}

@MainActor
struct OnlineRecipesView: View {

    let liveService: any OnlineRecipeServiceProtocol
    var initialQuery: String = "chicken"

    @State private var selectedSource: OnlineRecipeSource = .live

    var body: some View {
        VStack(spacing: 0) {

            if selectedSource != .live {
                Label(
                    "Demo mode · \(selectedSource.title) · no real API request",
                    systemImage: "testtube.2"
                )
                .font(.caption.weight(.medium))
                .foregroundStyle(.orange)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.orange.opacity(0.12), in: Capsule())
                .padding(.top, 8)
            }

            OnlineRecipesResultsView(
                service: service(for: selectedSource),
                initialQuery: initialQuery
            )
            .id(selectedSource)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Online Recipes")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Picker("Data Source", selection: $selectedSource) {
                        ForEach(OnlineRecipeSource.allCases) { source in
                            Text(source.title)
                                .tag(source)
                        }
                    }
                } label: {
                    Image(
                        systemName: selectedSource == .live
                            ? "antenna.radiowaves.left.and.right"
                            : "testtube.2"
                    )
                }
                .accessibilityLabel("Data Source")
            }
        }
    }

    private func service(
        for source: OnlineRecipeSource
    ) -> any OnlineRecipeServiceProtocol {

        switch source {

        case .live:
            return liveService

        case .mockSuccess:
            return MockOnlineRecipeService(
                scenario: .success
            )

        case .mockEmpty:
            return MockOnlineRecipeService(
                scenario: .empty
            )

        case .mockTransport:
            return MockOnlineRecipeService(
                scenario: .transportError
            )

        case .mockHTTP:
            return MockOnlineRecipeService(
                scenario: .httpError
            )

        case .mockDecoding:
            return MockOnlineRecipeService(
                scenario: .decodingError
            )
        }
    }
}

@MainActor
private struct OnlineRecipesResultsView: View {

    @StateObject private var viewModel: OnlineRecipesViewModel

    init(
        service: any OnlineRecipeServiceProtocol,
        initialQuery: String
    ) {
        _viewModel = StateObject(
            wrappedValue: OnlineRecipesViewModel(
                service: service,
                searchText: initialQuery
            )
        )
    }

    private var isLoading: Bool {
        if case .loading = viewModel.state {
            return true
        }
        return false
    }

    var body: some View {
        VStack(spacing: 0) {

            SearchField(
                placeholder: "Search meals",
                text: $viewModel.searchText,
                onSubmit: {
                    Task {
                        await viewModel.search()
                    }
                }
            )
            .disabled(isLoading)
            .padding()

            Group {
                switch viewModel.state {

                case .idle:
                    ContentUnavailableView(
                        "Search for Recipes",
                        systemImage: "magnifyingglass",
                        description: Text(
                            "Enter a meal name to search."
                        )
                    )

                case .loading:
                    VStack(spacing: 16) {
                        Spacer()

                        ProgressView("Loading recipes...")

                        Spacer()
                    }
                    .frame(maxWidth: .infinity)

                case .success(let meals):
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(meals) { meal in
                                NavigationLink(
                                    value: AppRoute.onlineRecipeDetails(meal)
                                ) {
                                    MealRow(meal: meal)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                    .scrollDismissesKeyboard(.interactively)

                case .empty:
                    ContentUnavailableView(
                        "No Recipes Found",
                        systemImage: "magnifyingglass",
                        description: Text(
                            "Try another search term."
                        )
                    )

                case .failure(let message):
                    VStack(spacing: 16) {
                        Spacer()

                        ContentUnavailableView(
                            "Request Failed",
                            systemImage: "wifi.exclamationmark",
                            description: Text(message)
                        )

                        Button {
                            Task {
                                await viewModel.retry()
                            }
                        } label: {
                            Label(
                                "Retry",
                                systemImage: "arrow.clockwise"
                            )
                        }
                        .buttonStyle(.borderedProminent)

                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .task {
            await viewModel.search()
        }
    }
}
