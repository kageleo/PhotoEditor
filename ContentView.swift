//
//  ContentView.swift
//  PhotoEditorApp
//
//  Created by 吉郷景虎 on 2020/08/11.
//  Copyright © 2020 Kagetora Yoshigo. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var imageController: ImageController
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    Image(uiImage: self.imageController.displayedImage!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height*(3/4))
                        .clipped()
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ThumbnailView(width: geometry.size.width*(20/100), height: geometry.size.height*(15/100), filterName: "Original", filter: .Original)
                            ThumbnailView(width: geometry.size.width*(20/100), height: geometry.size.height*(15/100), filterName: "Sepia", filter: .Sepia)
                            ThumbnailView(width: geometry.size.width*(20/100), height: geometry.size.height*(15/100), filterName: "Mono", filter: .Mono)
                            ThumbnailView(width: geometry.size.width*(20/100), height: geometry.size.height*(15/100), filterName: "Vibrance", filter: .Vibrance)
                            ThumbnailView(width: geometry.size.width*(20/100), height: geometry.size.height*(15/100), filterName: "Highlight", filter: .Highlight)
                            ThumbnailView(width: geometry.size.width*(20/100), height: geometry.size.height*(15/100), filterName: "Vignette", filter: .Vignette)
                        }
                    }
                        .frame(width: geometry.size.width, height: geometry.size.height*(1/4))
                }
            }
                .navigationBarTitle("Filter App", displayMode: .inline)
                .navigationBarItems(leading: LeadingNavigationBarItems(), trailing: TrailingNavigationBarItems())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ImageController())
    }
}

struct ThumbnailView: View {
    
    @EnvironmentObject var imageController: ImageController
    
    var width: CGFloat
    var height: CGFloat
    var filterName: String
    var filter: FilterType
    
    var body: some View {
        Button(action: {self.imageController.displayedImage = self.imageController.generateFilteredImage(inputImage: self.imageController.originalImage!, filter: self.filter)}) {
            VStack {
                Text(filterName)
                    .foregroundColor(.black)
                Image(uiImage: imageController.generateFilteredImage(inputImage: imageController.thumbnailImage!, filter: filter))
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width, height: height)
                    .cornerRadius(20)
                    .clipped()
            }
                .padding(.leading, 10)
                .padding(.trailing, 10)
        }
    }
}

struct LeadingNavigationBarItems: View {
    
//    @Binding var showImagePicker: Bool
    @EnvironmentObject var imageController: ImageController
    @State var showImagePicker = false
    @State var showCameraView = false
    
    var body: some View {
        
            HStack {
                Button(action: {self.showImagePicker = true}) {
                    Image(systemName: "photo")
//                        .foregroundColor(Color(UIColor.blue))
                        .imageScale(.large)
                        .padding(.leading, 5)
                }
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(imageController: self.imageController, showImagePicker: self.$showImagePicker)
                    }
                
                Button(action: {self.showCameraView = true}) {
                    Image(systemName: "camera")
//                        .foregroundColor(Color(UIColor.blue))
                        .imageScale(.large)
                        .padding(.leading, 15)
                }
                    .sheet(isPresented: self.$showCameraView) {
                        CameraView(imageController: self.imageController, showCameraView: self.$showCameraView)
                    }
        }
    }
}

struct TrailingNavigationBarItems: View {
    
    @EnvironmentObject var imageController: ImageController
    
    @State private var showingAlert = false
    
    var body: some View {
        Button(action: {
            self.imageController.saveImage()
            self.showingAlert = true
        }) {
            Image(systemName: "square.and.arrow.down")
//                .foregroundColor(Color(UIColor.blue))
                .imageScale(.large)
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("画像を保存しました"))
        }
    }
}
