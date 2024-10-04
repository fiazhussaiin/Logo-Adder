



import SwiftUI

struct TextAndArrowImageView: View {
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var inputText: String = ""
    @State private var isTypingText = false
    @State private var showShareSheet = false
    @State private var savedImages: [UIImage] = []

    var body: some View {
        VStack {
            ZStack {
                VStack{
                    Text("You should Tap on return of keyboard to add Text")
                        .foregroundColor(.gray)
                        .padding()
                    
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                            .padding()
                            .overlay(
                                VStack {
                                    if isTypingText {
                                        TextField("Enter text", text: $inputText, onCommit: {
                                            addTextToImage(text: inputText)
                                            isTypingText = false
                                        })
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding()
                                        .background(Color.white.opacity(0.8))
                                        .cornerRadius(10)
                                    }
                                }
                            )
                    } else {
                        Text("Select an image to add text or arrows")
                            .foregroundColor(.gray)
                            .padding()
                            .background(Color.black.opacity(0.2))
                            .cornerRadius(10)
                            .padding()
                    }
                }
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.black, Color.gray]), startPoint: .top, endPoint: .bottom)
                        .edgesIgnoringSafeArea(.all)
                )
            }
            HStack {
                VStack{
                    Button(action: { showImagePicker = true }) {
                        Label("Select Image", systemImage: "photo")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    
                    Button(action: { isTypingText.toggle() }) {
                        Label("Add Text", systemImage: "textformat")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                }

//                Button(action: { isTypingText.toggle() }) {
//                    Label("Add", systemImage: "arrow.right")
//                        .padding()
//                        .background(Color.purple)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                        .shadow(radius: 5)
//                }
            }
            .padding()

            HStack {
                IconButton(icon: "square.and.arrow.up", action: shareImage)
                IconButton(icon: "doc.on.doc", action: copyImage)
                IconButton(icon: "arrow.down.doc", action: saveToPhotos)
                IconButton(icon: "folder.badge.plus", action: saveToUserDefaults)
            }
            .padding()

        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $selectedImage)
        }
        .sheet(isPresented: $showShareSheet) {
            if let image = selectedImage {
                ShareSheet(activityItems: [image])
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Action Completed"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    private func addTextToImage(text: String) {
        guard let image = selectedImage else {
            alertMessage = "Please select an image first."
            showAlert = true
            return
        }
        let renderer = UIGraphicsImageRenderer(size: image.size)
        let font = UIFont.systemFont(ofSize: 80)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
       
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.red,
            .paragraphStyle: paragraphStyle
        ]

        let textSize = text.size(withAttributes: attributes)
        let textRect = CGRect(
            x: (image.size.width - textSize.width) / 2,
            y: (image.size.height - textSize.height) / 2,
            width: textSize.width,
            height: textSize.height
        )

        let textImage = renderer.image { context in
            image.draw(in: CGRect(origin: .zero, size: image.size))
            text.draw(in: textRect, withAttributes: attributes)
        }
        
        selectedImage = textImage
        alertMessage = "Text added to image."
        showAlert = true
    }
    
    private func addArrowToImage() {
        guard var image = selectedImage else {
            alertMessage = "Please select an image first."
            showAlert = true
            return
        }
        let renderer = UIGraphicsImageRenderer(size: image.size)
        image = renderer.image { context in
            image.draw(in: CGRect(origin: .zero, size: image.size))
            
            // Arrow Drawing
            let arrowPath = UIBezierPath()
            arrowPath.move(to: CGPoint(x: image.size.width * 0.25, y: image.size.height * 0.5))
            arrowPath.addLine(to: CGPoint(x: image.size.width * 0.75, y: image.size.height * 0.5))
            
            UIColor.blue.setStroke()
            arrowPath.lineWidth = 5
            arrowPath.stroke()
        }
        
        selectedImage = image
        alertMessage = "Arrow added to image."
        showAlert = true
    }

    private func saveToPhotos() {
        guard let image = selectedImage else {
            alertMessage = "Please select an image first."
            showAlert = true
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        alertMessage = "Image Downloaded to Photos."
        showAlert = true
    }

    private func shareImage() {
        guard selectedImage != nil else {
            alertMessage = "Please select an image first."
            showAlert = true
            return
        }
        showShareSheet = true
    }

    private func copyImage() {
        guard let image = selectedImage else {
            alertMessage = "Please select an image first."
            showAlert = true
            return
        }

        UIPasteboard.general.image = image
        alertMessage = "Image copied to clipboard."
        showAlert = true
    }

    private func saveToUserDefaults() {
        guard let image = selectedImage else {
            alertMessage = "Please select an image first."
            showAlert = true
            return
        }
        
        if let imageData = image.pngData() {
            var savedImages = UserDefaults.standard.array(forKey: "SavedImages") as? [Data] ?? []
            savedImages.append(imageData)
            UserDefaults.standard.set(savedImages, forKey: "SavedImages")
            alertMessage = "Image saved to in App."
            showAlert = true
        }
    }
}

struct IconButton: View {
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.title)
                .padding()
                .background(Circle().fill(Color.gray.opacity(0.2)))
        }
        .foregroundColor(.black)
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        return UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}


