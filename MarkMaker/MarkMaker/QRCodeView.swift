

import SwiftUI
import CoreImage.CIFilterBuiltins
import AVFoundation

struct QRCodeView: View {
    @State private var inputText: String = ""
    @State private var qrImage: UIImage?
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isShowingScanner = false
    @State private var showShareSheet = false
    @State private var scannedCode: String?
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.purple.opacity(0.7)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                TextField("Enter text for QR Code", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                if let qrCodeImage = qrImage {
                    Image(uiImage: qrCodeImage)
                        .resizable()
                        .frame(width: 100, height: 100)
                        
                       
                    Text("Hurrah! QR Code has been generated Just Use this to save or share!")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    Text("No QR Code generated")
                        .foregroundColor(.white)
                        .padding()
                }

                VStack(spacing: 20) {
                    HStack {
                        Button(action: generateQRCode) {
                            Label("Generate QR Code", systemImage: "qrcode")
                                .padding()
                                .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.green.opacity(0.7)]), startPoint: .leading, endPoint: .trailing))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .shadow(radius: 10)
                        }
                        
//                        Button(action: {
//                            isShowingScanner = true
//                        }) {
//                            Label("Scan QR Code", systemImage: "viewfinder")
//                                .padding()
//                                .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.7)]), startPoint: .leading, endPoint: .trailing))
//                                .foregroundColor(.white)
//                                .cornerRadius(10)
//                                .shadow(radius: 10)
//                        }
                    }
                    .padding()
                }
                
                VStack(spacing: 20) {
                    Button(action: saveQRCodeToPhotos) {
                        Label("Save to Photos", systemImage: "square.and.arrow.down")
                            .padding()
                            .background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.orange.opacity(0.7)]), startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                    }

                    HStack {
                        Button(action: copyQRCodeToClipboard) {
                            Label("Copy QR Code", systemImage: "doc.on.doc")
                                .padding()
                                .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.purple.opacity(0.7)]), startPoint: .leading, endPoint: .trailing))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .shadow(radius: 10)
                        }
                        
                        Button(action: shareQRCode) {
                            Label("Share QR Code", systemImage: "square.and.arrow.up")
                                .padding()
                                .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.red.opacity(0.7)]), startPoint: .leading, endPoint: .trailing))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .shadow(radius: 10)
                        }
                    }
                    
                    Button(action: saveQRCodeToUserDefaults) {
                        Label("Save to UserDefaults", systemImage: "floppydisk")
                            .padding()
                            .background(LinearGradient(gradient: Gradient(colors: [Color.gray, Color.gray.opacity(0.7)]), startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                    }
                }
                .padding()
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Action Completed"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .sheet(isPresented: $isShowingScanner) {
            QRCodeScannerView(scannedCode: $scannedCode, isShowingScanner: $isShowingScanner)
                .onChange(of: scannedCode) { newCode in
                    if let code = newCode {
                        inputText = code
                        qrImage = nil // Optionally clear the previous QR code image
                        alertMessage = "Scanned QR Code: \(code)"
                        showAlert = true
                    }
                }
        }
        .sheet(isPresented: $showShareSheet) {
            if let image = qrImage {
                ShareSheet(activityItems: [image])
            }
        }
    }
    
    private func generateQRCode() {
        guard !inputText.isEmpty else {
            alertMessage = "Please enter text for QR code."
            showAlert = true
            return
        }

        let data = Data(inputText.utf8)
        let filter = CIFilter.qrCodeGenerator()
        filter.setValue(data, forKey: "inputMessage")

        if let outputImage = filter.outputImage {
            // Scale the image correctly
            let scaleX = UIScreen.main.scale
            let transform = CGAffineTransform(scaleX: scaleX * 10, y: scaleX * 10)
            let scaledImage = outputImage.transformed(by: transform)

            // Convert CIImage to UIImage
            let uiImage = UIImage(ciImage: scaledImage)
            qrImage = uiImage
            alertMessage = "QR Code generated."
        } else {
            alertMessage = "Failed to generate QR Code."
        }

        showAlert = true
    }

    private func saveQRCodeToPhotos() {
        guard let image = qrImage else {
            alertMessage = "No QR code to save. Please generate one first."
            showAlert = true
            return
        }

        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        alertMessage = "QR Code saved to Photos."
        showAlert = true
    }

    private func copyQRCodeToClipboard() {
        guard let image = qrImage else {
            alertMessage = "No QR code to copy. Please generate one first."
            showAlert = true
            return
        }

        UIPasteboard.general.image = image
        alertMessage = "QR Code copied to clipboard."
        showAlert = true
    }

    private func shareQRCode() {
        guard let image = qrImage else {
            alertMessage = "No QR code to share. Please generate one first."
            showAlert = true
            return
        }

        showShareSheet = true
    }
    
    private func saveQRCodeToUserDefaults() {
        guard let image = qrImage else {
            alertMessage = "No QR code to save. Please generate one first."
            showAlert = true
            return
        }

        if let imageData = image.pngData() {
            var savedImages = UserDefaults.standard.array(forKey: "SavedImages") as? [Data] ?? []
            savedImages.append(imageData)
            UserDefaults.standard.set(savedImages, forKey: "SavedImages")
            alertMessage = "QR Code saved to UserDefaults."
            showAlert = true
        }
    }
}











import SwiftUI
import AVFoundation

struct QRCodeScannerView: UIViewControllerRepresentable {
    @Binding var scannedCode: String?
    @Binding var isShowingScanner: Bool

    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: QRCodeScannerView

        init(parent: QRCodeScannerView) {
            self.parent = parent
        }

        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            if let metadataObject = metadataObjects.first {
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject, readableObject.type == .qr else { return }
                if let stringValue = readableObject.stringValue {
                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                    DispatchQueue.main.async {
                        self.parent.scannedCode = stringValue
                        self.parent.isShowingScanner = false
                    }
                }
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let session = AVCaptureSession()
        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)

        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.frame = viewController.view.layer.bounds
        viewController.view.layer.addSublayer(videoPreviewLayer)

        guard let device = AVCaptureDevice.default(for: .video), let input = try? AVCaptureDeviceInput(device: device) else { return viewController }

        session.addInput(input)

        let output = AVCaptureMetadataOutput()
        session.addOutput(output)

        output.setMetadataObjectsDelegate(context.coordinator, queue: DispatchQueue.main)
        output.metadataObjectTypes = [.qr]

        session.startRunning()

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
