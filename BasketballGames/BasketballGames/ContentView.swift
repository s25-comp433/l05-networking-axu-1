//
//  ContentView.swift
//  BasketballGames
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI

struct Game: Codable, Identifiable {
    var id: Int
    var score: Score
    var date: String
    var isHomeGame: Bool
    var opponent: String
    var team: String
}

struct Score: Codable {
    var unc: Int
    var opponent: Int
}

struct ContentView: View {
    @State private var games = [Game]()
    
    var body: some View {
        NavigationStack {
            List(games) { game in
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(game.team) vs \(game.opponent)")
                        Spacer()
                        Text("\(game.score.unc) - \(game.score.opponent)")
                            .foregroundStyle(game.score.unc >= game.score.opponent ? .green : .red)
                    }.font(.headline)
                    HStack {
                        Text("\(game.date)")
                        Spacer()
                        Text("\(game.isHomeGame ? "Home" : "Away")")
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("UNC Basketball")
            .task {
                await loadData()
            }
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "https://api.samuelshi.com/uncbasketball") else {
            print("Invalid URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode([Game].self, from: data) {
                games = decodedResponse
            }
        } catch {
            print("Invalid data")
        }
    }
}

#Preview {
    ContentView()
}
