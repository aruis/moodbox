//
//  ImagePicker.swift
//  moodbox
//
//  Created by 牧云踏歌 on 2023/4/8.
//


import UIKit
import SwiftUI

struct ImagePicker:UIViewControllerRepresentable{
    var sourceType: UIImagePickerController.SourceType = .camera
    
    @Binding var selectedImage: UIImage
    
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) ->  UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator:NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
        var parent: ImagePicker
        init(_ parent: ImagePicker){
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                
                
                
//                let saveImage = UIImage(data: image.aspectFittedToHeight(400).jpegData(compressionQuality: 0.85)!) ?? UIImage()
//
                parent.selectedImage = image
                
                
            }
            parent.dismiss()
        }
        
        
    }
}
