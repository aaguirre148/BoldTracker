//
//  ContentView.swift
//  BoldTracker
//
//  Created by Adrian Aguirre on 30/10/25.
//

import SwiftUI

struct DailyBoldTrackerView: View {
    // Guarda la racha actual y la última fecha registrada
    @AppStorage("streakCount") private var streakCount = 0
    @AppStorage("lastBoldDate") private var lastBoldDate = ""

    // Fecha actual
    let today = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
    
    var body: some View {
        VStack(spacing: 24) {
            Text("🔥 Daily Bold Tracker")
                .font(.largeTitle)
                .bold()
            
            Text("Racha actual: \(streakCount) días")
                .font(.title2)
                .foregroundColor(.secondary)
            
            Button(action: markBoldAction) {
                Text("Hoy fui audaz 💥")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding()
            
            Spacer()
        }
        .padding()
    }
    
    func markBoldAction() {
        if lastBoldDate != today { // Si ayer fui audaz y no se ha roto la racha
            if let lastDate = DateFormatter.shortStyle.date(from: lastBoldDate),
               let diff = Calendar.current.dateComponents([.day], from: lastDate, to: Date()).day,
               diff == 1 {
                streakCount += 1
            } else {
                streakCount = 1
            }
            lastBoldDate = today
        }
    }
}

extension DateFormatter {
    static let shortStyle: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}


#Preview {
    DailyBoldTrackerView()
}
