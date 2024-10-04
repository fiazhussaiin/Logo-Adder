

import SwiftUI

struct GridView: View {
    @State private var images: [UIImage] = []
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack {
            if images.isEmpty {
                Text("No images available")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
                
                Image(systemName: "photo.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                        ForEach(images.indices, id: \.self) { index in
                            Image(uiImage: images[index])
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                                .clipped()
                                .onLongPressGesture {
                                    // Trigger context menu on long press
                                    // Note: Context menu already used in view
                                }
                                .contextMenu {
                                    Button(action: {
                                        copyImage(images[index])
                                    }) {
                                        Text("Copy")
                                        Image(systemName: "doc.on.doc")
                                    }
                                    
                                    Button(action: {
                                        shareImage(images[index])
                                    }) {
                                        Text("Share")
                                        Image(systemName: "square.and.arrow.up")
                                    }
                                    
                                    Button(action: {
                                        saveToPhotos(images[index])
                                    }) {
                                        Text("Download")
                                        Image(systemName: "arrow.down")
                                    }
                                    
                                    Button(action: {
                                        deleteImage(at: index)
                                    }) {
                                        Text("Delete")
                                        Image(systemName: "trash")
                                    }
                                }
                        }
                    }
                    .padding()
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Action Completed"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            loadImages()
        }
    }
    
    private func loadImages() {
        // Load images from UserDefaults
        if let imageDataArray = UserDefaults.standard.array(forKey: "SavedImages") as? [Data] {
            images = imageDataArray.compactMap { UIImage(data: $0) }
        }
    }
    
    private func copyImage(_ image: UIImage) {
        UIPasteboard.general.image = image
        alertMessage = "Image copied to clipboard."
        showAlert = true
    }
    
    private func shareImage(_ image: UIImage) {
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
            rootViewController.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    private func saveToPhotos(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        alertMessage = "Image saved to Photos."
        showAlert = true
    }
    
    private func deleteImage(at index: Int) {
        images.remove(at: index)
        // Save the updated image array back to UserDefaults
        let imageDataArray = images.compactMap { $0.pngData() }
        UserDefaults.standard.set(imageDataArray, forKey: "SavedImages")
        alertMessage = "Image deleted."
        showAlert = true
    }
}

