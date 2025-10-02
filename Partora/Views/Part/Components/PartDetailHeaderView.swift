import SwiftUI

@available(iOS 14.0, *)
struct PartDetailHeaderView: View {
    let part: Part
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.6)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(height: 200)
                
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: "gear.badge.checkmark")
                            .font(.system(size: 36, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    
                    VStack(spacing: 8) {
                        Text(part.partNumber)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text(part.description)
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                    }
                    
                    HStack(spacing: 20) {
                        VStack(spacing: 4) {
                            Text("$\(String(format: "%.2f", Double(part.priceCents) / 100))")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Text("Price")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        
                        Rectangle()
                            .fill(Color.white.opacity(0.3))
                            .frame(width: 1, height: 40)
                        
                        VStack(spacing: 4) {
                            Text("\(part.quantityOnHand)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Text("In Stock")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.bottom, 20)
    }
}
