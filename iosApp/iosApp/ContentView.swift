import PhotosUI
import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel = ViewModel()
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var showPopover: Bool = false
    
    var body: some View {
        if selectedImageData == nil {
            PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()) {
                    Text("Select a photo")
                }
                .onChange(of: selectedItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            selectedImageData = data
                        }
                    }
                }
        }
        if let selectedImageData, let uiImage = UIImage(data: selectedImageData) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, alignment: .top)
            
            Button("Get text", action: {
                self.showPopover = true
                self.viewModel.getTextsFromImage(image: uiImage)
            })
            .popover(isPresented: $showPopover, content: {
                ForEach(self.viewModel.identifiedTexts, id: \.self) { text in
                    Text(text)
                }
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
