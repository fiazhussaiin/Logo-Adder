


import SwiftUI
import PhotosUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.purple.opacity(0.5)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                VStack(spacing: 30) {
                    // Logo icon with a gradient background
                    ZStack {
                        Circle()
                            .fill(LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.8), Color.blue.opacity(0.8)]), startPoint: .top, endPoint: .bottom))
                            .frame(width: 120, height: 120)
                            .shadow(color: .gray, radius: 10, x: 0, y: 5)
                        
                        Image(systemName: "globe")
                            .imageScale(.large)
                            .font(.system(size: 60))
                            .foregroundStyle(.primary)
                    }
                    .padding(.bottom, 20)

                    Text("Welcome to Image Editor!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom, 20)

                    // Buttons to navigate to the different views with icons and gradients
                    NavigationLink(destination: LogoImageView()) {
                        Label("Add Logo to Image", systemImage: "camera.viewfinder")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.cyan]), startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .shadow(color: .blue.opacity(0.5), radius: 5, x: 0, y: 5)
                    }
                    .padding(.horizontal, 20)

                    NavigationLink(destination: TextAndArrowImageView()) {
                        Label("Add Text & Arrow to Image", systemImage: "pencil.and.outline")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.teal]), startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .shadow(color: .green.opacity(0.5), radius: 5, x: 0, y: 5)
                    }
                    .padding(.horizontal, 20)

//                    NavigationLink(destination: QRCodeView()) {
//                        Label("Generate Code", systemImage: "qrcode")
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red]), startPoint: .leading, endPoint: .trailing))
//                            .foregroundColor(.white)
//                            .cornerRadius(15)
//                            .shadow(color: .orange.opacity(0.5), radius: 5, x: 0, y: 5)
//                    }
//                    .padding(.horizontal, 20)

                    NavigationLink(destination: GridView()) {
                        Label("View Images in Grid", systemImage: "rectangle.grid.3x2")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.pink]), startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .shadow(color: .purple.opacity(0.5), radius: 5, x: 0, y: 5)
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.vertical, 40)
            }
        }
    }
}

