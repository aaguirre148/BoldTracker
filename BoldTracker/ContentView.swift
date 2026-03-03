//
//  ContentView.swift
//  BoldTracker
//
//  Created by Adrian Aguirre on 30/10/25.
//

import SwiftUI

struct DailyBoldTrackerView: View {
    
    @StateObject private var viewModel = BoldTrackerViewModel()
    
    var body: some View {
        VStack(spacing: 24) {
            Text("🔥 Daily Bold Tracker")
                .font(.largeTitle)
                .bold()
            
            Text("Racha actual: \(viewModel.streakCount) días")
                .font(.title2)
                .foregroundColor(.secondary)
            
            Button(action: viewModel.markBoldAction) {
                Text("Hoy fui audaz 💥")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding()
            
            Button(action: viewModel.resetButton) {
                Text("Reset")
                    .foregroundColor(.red)
            }
            .padding()
            
            Spacer()
        }
        .padding()
    }
    
    
}

#Preview {
    DailyBoldTrackerView()
}
