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
    
    init() {
        streakCount = UserDefaults.standard.integer(forKey: "streakCount")
        lastBoldDateInterval = UserDefaults.standard.double(forKey: "lastBoldDate")
        boldHistory = UserDefaults.standard.array(forKey: "boldHistory") as? [Double] ?? []
    }
    
    func markBoldAction() {
        let today = Date()
        let calendar = Calendar.current
        let todayStart = Calendar.current.startOfDay(for: today).timeIntervalSince1970
        let lastDate = Date(timeIntervalSince1970: lastBoldDateInterval)
        
        // Si nunca se ha guardado fecha
        if lastBoldDateInterval == 0 {
            streakCount = 1
            lastBoldDateInterval = today.timeIntervalSince1970
        }
        
        //Bold History
        if !boldHistory.contains(todayStart) {
            boldHistory.append(todayStart)
            return
        }
        //Revisa si la racha permanece o se ha roto
        if let diff = calendar.dateComponents([.day], from: calendar.startOfDay(for: lastDate),
                                              to: calendar.startOfDay(for: today)).day {
            if diff == 1 { // Día consecutivo
                streakCount += 1
            } else if diff > 1 { // Se rompió la racha/
                streakCount = 1
            }
            // Si diff == 0 no hacemos nada (ya marcamos una acción audaz hoy)
        }
        
        lastBoldDateInterval = today.timeIntervalSince1970
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
