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
    @AppStorage("lastBoldDate") private var lastBoldDateInterval: Double = 0

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
            
            Button(action: resetButton) {
                Text("Reset")
                    .foregroundColor(.red)
            }
            .padding()
            
            Spacer()
        }
        .padding()
    }
    
    func markBoldAction() {
        let today = Date()
        
        // Si nunca se ha guardado fecha
        if lastBoldDateInterval == 0 {
            streakCount = 1
            lastBoldDateInterval = today.timeIntervalSince1970
            return
        }
            
        let lastDate = Date(timeIntervalSince1970: lastBoldDateInterval)
            
        let calendar = Calendar.current
        
        if let diff = calendar.dateComponents([.day], from: calendar.startOfDay(for: lastDate),
                                                 to: calendar.startOfDay(for: today)).day {
               
               if diff == 1 {
                   // Día consecutivo
                   streakCount += 1
               } else if diff > 1 {
                   // Se rompió la racha
                   streakCount = 1
               }
               // Si diff == 0 no hacemos nada (ya marcó hoy)
           }
           
           lastBoldDateInterval = today.timeIntervalSince1970
    }
    
    ///BOTON DE RESET SOLO PARA DESARROLLO
    func resetButton () {
        lastBoldDateInterval = 0
        streakCount = 0
    }
}

#Preview {
    DailyBoldTrackerView()
}
