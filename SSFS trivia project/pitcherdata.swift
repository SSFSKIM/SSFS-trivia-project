//
//  data.swift
//  SSFS trivia project
//
//  Created by Steve on 5/1/24.
//

import Foundation

struct Player: Decodable {
  let season: String
  let age: Int
  let playerName: String
  let teamName: String
  let wins: Int?
  let losses: Int?
  let era: Double?
  let qualityStarts: Int?
  let inningsPitched: Double?
  let hits: Int?
  let runs: Int?
  let earnedRuns: Int?
  let homeRuns: Int?
  let walks: Int?
  let hitByPitch: Int?
  let strikeouts: Int?
  let strikeoutsPerNine: Double?
  let walksPerNine: Double?
  let strikeoutToWalkRatio: Double?
  let hitsPerNine: Double?
  let battingAverage: Double?
  let whip: Double?
  let fip: Double?
  let war: Double
  let FBvalue: Double?
  let SLvalue: Double?
  let CTvalue : Double?
  let CBvalue: Double?
  let CHvalue: Double?
  let FBvalue100: Double?
  let SLvalue100: Double?
  let CTvalue100 : Double?
  let CBvalue100: Double?
  let CHvalue100: Double?
  let Barrelpercentage: Double?
  let Hardhitpercentage: Double?
  let ExitVelo: Double?

  
}

func fetchPitchingLeaders(completion: @escaping ([Player]) -> Void) {
  guard let url = URL(string: "https://www.fangraphs.com/_next/data/3ckubF_ynPQFFgnUqN9zi/leaders/major-league.json?pos=all&stats=pit&lg=all&qual=y&type=8&ind=1&team=0&rost=0&players=0&startdate=&enddate=&season1=2010&season=2023&pageitems=200") else { return }

  let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
    if let error = error {
      print("Error fetching data:", error)
      completion([])
      return
    }

    guard let data = data else { return }

    do {
      let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
      guard let leaders = jsonObject["leaders"] as? [[String: Any]] else {
        print("Leaders data not found")
        completion([])
        return
      }

      var players: [Player] = []
      for leader in leaders {
        guard let player = Player(from: leader) else { continue }
        players.append(player)
      }

      let sortedPlayers = players.sorted { $0.war > $1.war } // Sort by WAR (descending)
      completion(sortedPlayers)
    } catch {
      print("Error parsing JSON data:", error)
      completion([])
    }
  }
  task.resume()
}

// Example usage
fetchPitchingLeaders { (players) in
  for player in players {
    print("Player: \(player.playerName), Team: \(player.teamName), WAR: \(player.war)")
  }
}
