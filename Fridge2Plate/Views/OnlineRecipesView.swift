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

    @State private var selectedSource: OnlineRecipeSource = .live

    var body: some View {
        VStack(spacing: 0) {

            HStack {
                Text("Data Source")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Spacer()

                Picker("Data Source", selection: $selectedSource) {
                    ForEach(OnlineRecipeSource.allCases) { source in
                        Text(source.title)
                            .tag(source)
                    }
                }
                .pickerStyle(.menu)
            }
            .padding(.horizontal)
            .padding(.top, 8)

            if selectedSource != .live {
                Text("Demo mode — no real API request")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.bottom, 8)
            }

            OnlineRecipesResultsView(
                service: service(for: selectedSource)
            )
            .id(selectedSource)
        }
        .navigationTitle("Online Recipes")
        .navigationBarTitleDisplayMode(.inline)
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

    init(service: any OnlineRecipeServiceProtocol) {
        _viewModel = StateObject(
            wrappedValue: OnlineRecipesViewModel(
                service: service
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

            HStack(spacing: 12) {
                TextField(
                    "Search meals",
                    text: $viewModel.searchText
                )
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .submitLabel(.search)
                .disabled(isLoading)
                .onSubmit {
                    Task {
                        await viewModel.search()
                    }
                }

                Button("Search") {
                    Task {
                        await viewModel.search()
                    }
                }
                .disabled(isLoading)
            }
            .padding()

            Divider()

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
                    List(meals) { meal in
                        HStack(spacing: 12) {

                            AsyncImage(
                                url: meal.strMealThumb.flatMap(
                                    URL.init(string:)
                                )
                            ) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Image(systemName: "fork.knife")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(14)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(width: 64, height: 64)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 10)
                            )

                            VStack(
                                alignment: .leading,
                                spacing: 4
                            ) {
                                Text(meal.strMeal)
                                    .font(.headline)

                                Text("Meal ID: \(meal.idMeal)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()
                        }
                        .padding(.vertical, 4)
                    }

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
