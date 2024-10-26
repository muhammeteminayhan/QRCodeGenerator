//
//  ContentView.swift
//  QRCodeGenerator
//
//  Created by Muhammet Emin Ayhan on 26.10.2024.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                QRCodeGeneratorView()
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}

struct QRCodeGeneratorView: View {
    @State private var inputText: String = ""
    @State private var qrCodeImage: UIImage? = nil
    @State private var showAlert = false
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    var body: some View {
        ZStack {
            Color.gray.opacity(0.2).edgesIgnoringSafeArea(.all)
                .cornerRadius(25)
            VStack(spacing: 20) {
                Text("QR Code Generator")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 40)
                    .foregroundColor(.orange)
                
                HStack {
                    Image(systemName: "link")
                        .foregroundColor(.gray)
                    TextField("Enter Your Link", text: $inputText)
                        .padding(15)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
                        )
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        }
                        .foregroundColor(.black)
                        .padding(.horizontal)
                }
                .padding(.horizontal, 30)
                
                Button {
                    if isValidURL(inputText) {
                        qrCodeImage = generateQRCode(from: inputText)
                    } else {
                        showAlert = true
                    }
                } label: {
                    Text("Generate QR Code")
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(inputText.isEmpty ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.horizontal, 30)
                .disabled(inputText.isEmpty)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Invalid Link"), message: Text("Please enter a valid link"), dismissButton: .default(Text("OK")))
                }
                
                if let qrCodeImage = qrCodeImage {
                    Image(uiImage: qrCodeImage)
                        .interpolation(.none)
                        .resizable()
                        .frame(width: 200, height: 200)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                } else {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 200,height: 200)
                        .overlay (
                            Text("Enter a link and press the button")
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        )
                        .padding()
                        .shadow(radius: 5)
                }
                Spacer()

            }
            .ignoresSafeArea(.all, edges: .all)
        }
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        filter.message = Data(string.utf8)
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        return nil
    }
    
    func isValidURL(_ string: String) -> Bool {
        if let url = URL(string: string), UIApplication.shared.canOpenURL(url) {
            return true
        }
        return false
    }
}
