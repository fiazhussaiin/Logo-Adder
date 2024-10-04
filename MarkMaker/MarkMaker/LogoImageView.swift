

import SwiftUI

struct LogoImageView: View {
    @State private var selectedImage: UIImage?
    @State private var logoImage: UIImage? // Will be selected from gallery
    @State private var editedImage: UIImage?
    @State private var showImagePicker = false
    @State private var showLogoPicker = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isImageButtonPressed = false
    @State private var isLogoButtonPressed = false
    @State private var isAddLogoButtonPressed = false
    
    
    var body: some View {
        ScrollView{
            VStack {
                if let image = editedImage ?? selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                        .shadow(radius: 10)
                } else {
                    Text("Select an image to add a logo")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                }
                
                // Indicate if the logo image is selected
                if logoImage != nil {
                    Text("Logo selected")
                        .font(.headline)
                        .foregroundColor(.green)
                        .padding()
                } else {
                    Text("No logo selected")
                        .font(.headline)
                        .foregroundColor(.red)
                        .padding()
                }
                
                // Horizontal stack for buttons
                HStack(spacing: 20) {
                    VStack{
                        Button(action: {
                            showImagePicker = true
                            isImageButtonPressed.toggle()
                        }) {
                            HStack {
                                Image(systemName: "photo")
                                Text("Select Image")
                            }
                            .padding()
                            .background(isImageButtonPressed ? LinearGradient(gradient: Gradient(colors: [Color.blue, Color.cyan]), startPoint: .leading, endPoint: .trailing) : LinearGradient(gradient: Gradient(colors: [Color.blue, Color.cyan]), startPoint: .leading, endPoint: .trailing))
                            
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        }
                        .simultaneousGesture(LongPressGesture().onEnded { _ in
                            isImageButtonPressed = false
                        })
                        
                        
                        // Button to select a logo from the gallery
                        Button(action: { showLogoPicker = true }) {
                            HStack {
                                Image(systemName: "photo.on.rectangle")
                                Text("Select Logo")
                            }
                            .padding()
                            .background(LinearGradient(gradient: Gradient(colors: [Color.pink, Color.orange]), startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        }
                    }
                    // Button to add a logo to the image
                    Button(action: addLogo) {
                        HStack {
                            Image(systemName: "plus.circle")
                            Text("Add Logo")
                        }
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.teal]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }
                }
                .padding(.vertical)
                
                HStack(spacing: 20) {
                    // Button to save the image to the Photos
                    VStack{
                        Button(action: saveToPhotos) {
                            VStack {
                                Image(systemName: "square.and.arrow.down")
                                Text("Download")
                            }
                            .padding()
                            .background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red]), startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        }
                        
                        // Additional actions: Copy, Share
                        Button(action: copyImage) {
                            VStack {
                                Image(systemName: "doc.on.doc")
                                Text("Copy")
                            }
                            .padding()
                            .background(LinearGradient(gradient: Gradient(colors: [Color.black, Color.green]), startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        }
                    }
                    VStack{
                        Button(action: saveImageToUserDefaults) {
                            HStack {
                                Image(systemName: "doc.on.doc")
                                Text("Save")
                            }
                            .padding()
                            .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.pink]), startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        }
                        
                        Button(action: shareImage) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                Text("Share")
                            }
                            .padding()
                            .background(LinearGradient(gradient: Gradient(colors: [Color.indigo, Color.purple]), startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        }
                    }
                }
                .padding(.vertical)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $selectedImage)
            }
            .sheet(isPresented: $showLogoPicker) {
                ImagePicker(image: $logoImage)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Action Completed"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    private func addLogo() {
        guard let baseImage = selectedImage, let logo = logoImage else {
            alertMessage = "Please select an image and a logo first."
            showAlert = true
            return
        }
        
        // Adding the logo to the base image
        let size = baseImage.size
        UIGraphicsBeginImageContext(size)
        
        baseImage.draw(in: CGRect(origin: .zero, size: size))
        
        // Drawing the logo at the bottom center of the image
        let logoSize = CGSize(width: 250, height: 250)
        let logoOrigin = CGPoint(x: (size.width - logoSize.width) / 2, y: size.height - logoSize.height - 50)
        logo.draw(in: CGRect(origin: logoOrigin, size: logoSize), blendMode: .normal, alpha: 1.0)
        
        editedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Save edited image to UserDefaults
        
        
        alertMessage = "Logo added to image."
        showAlert = true
    }
    
    private func saveToPhotos() {
        guard let image = editedImage ?? selectedImage else {
            alertMessage = "Please select an image first."
            showAlert = true
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        alertMessage = "Image Downloaded to Photos."
        showAlert = true
    }
    
    private func copyImage() {
        guard let image = editedImage ?? selectedImage else {
            alertMessage = "Please select an image first."
            showAlert = true
            return
        }
        
        UIPasteboard.general.image = image
        alertMessage = "Image copied to clipboard."
        showAlert = true
    }
    
    private func shareImage() {
        guard let image = editedImage ?? selectedImage else {
            alertMessage = "Please select an image first."
            showAlert = true
            return
        }
        
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
    
    private func saveImageToUserDefaults() {
        guard let image = editedImage ?? selectedImage else {
            alertMessage = "Please select an image first."
            showAlert = true
            return
        }
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return }
        
        var savedImages = UserDefaults.standard.array(forKey: "SavedImages") as? [Data] ?? []
        savedImages.append(imageData)
        UserDefaults.standard.set(savedImages, forKey: "SavedImages")
        alertMessage = "Image has been saved!"
        showAlert = true
    }
    
    private func loadSavedImages() -> [UIImage] {
        guard let savedImageData = UserDefaults.standard.array(forKey: "SavedImages") as? [Data] else { return [] }
        return savedImageData.compactMap { UIImage(data: $0) }
    }
}


