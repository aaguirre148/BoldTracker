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
    private var lastBoldDateInterval: Double = 0
    
    init() {
        streakCount = UserDefaults.standard.integer(forKey: "streakCount")
        lastBoldDateInterval = UserDefaults.standard.double(forKey: "lastBoldDate")
    }
    
    func markBoldAction() {
        let today = Date()
        let calendar = Calendar.current
        
        // Si nunca se ha guardado fecha
        if lastBoldDateInterval == 0 {
            streakCount = 1
            lastBoldDateInterval = today.timeIntervalSince1970
            return
        }
        
        let lastDate = Date(timeIntervalSince1970: lastBoldDateInterval)
        
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
        save()
    }
    
    ///BOTON DE RESET SOLO PARA DESARROLLO
    func resetButton () {
        lastBoldDateInterval = 0
        streakCount = 0
        save()
    }
    
    private func save() {
        UserDefaults.standard.set(streakCount, forKey: "streakCount")
        UserDefaults.standard.set(lastBoldDateInterval, forKey: "lastBoldDate")
    }
}
