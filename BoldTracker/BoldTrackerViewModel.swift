//
//  BoldTrackerViewModel.swift
//  BoldTracker
//
//  Created by Adrian Aguirre on 02/03/26.
//

import Foundation
import SwiftUI
internal import Combine

class BoldTrackerViewModel: ObservableObject {
    
    // Guarda la racha actual y la última fecha registrada
    @Published var streakCount = 0
    @Published var boldHistory: [Double] = []
    
    private var lastBoldDateInterval: Double = 0
    
    //Creo los últimos 30 días para el calendario
    var last30Days: [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        return (0..<30).compactMap {
            calendar.date(byAdding: .day, value: -$0, to: today)
        }.reversed()
    }
    
    init() {
        streakCount = UserDefaults.standard.integer(forKey: "streakCount")
        lastBoldDateInterval = UserDefaults.standard.double(forKey: "lastBoldDate")
        boldHistory = UserDefaults.standard.array(forKey: "boldHistory") as? [Double] ?? []
    }
    
    func markBoldAction() {
        let calendar = Calendar.current
        let today = Date()
        let todayStart = calendar.startOfDay(for: today)
        let todayInterval = todayStart.timeIntervalSince1970
        
        // Si ya marcaste hoy, no hacemos nada
        if boldHistory.contains(todayInterval) {
            return
        }
        
        // Primera vez
        if lastBoldDateInterval == 0 {
            streakCount = 1
        } else {
            let lastDate = Date(timeIntervalSince1970: lastBoldDateInterval)
            
            if let diff = calendar.dateComponents(
                [.day],
                from: calendar.startOfDay(for: lastDate),
                to: todayStart
            ).day {
                
                if diff == 1 {
                    streakCount += 1
                } else if diff > 1 {
                    streakCount = 1
                }
            }
        }
        
        // Agregamos al historial
        boldHistory.append(todayInterval)
        
        // Actualizamos última fecha
        lastBoldDateInterval = todayInterval
        
        save()
    }
    
    ///BOTON DE RESET SOLO PARA DESARROLLO
    func resetButton () {
        lastBoldDateInterval = 0
        streakCount = 0
        boldHistory.removeAll()
        save()
    }
    
    private func save() {
        UserDefaults.standard.set(streakCount, forKey: "streakCount")
        UserDefaults.standard.set(lastBoldDateInterval, forKey: "lastBoldDate")
        UserDefaults.standard.set(boldHistory, forKey: "boldHistory")
    }
}
