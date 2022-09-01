//
//  Note.swift
//  Ansel
//
//  Created by Tyler Reckart on 8/27/22.
//

import SwiftUI
import PhotosUI
import UIKit

struct ZoomableScrollView<Content: View>: UIViewRepresentable {
    private var content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    func makeUIView(context: Context) -> UIScrollView {
        // set up the UIScrollView
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator
        scrollView.maximumZoomScale = 20
        scrollView.minimumZoomScale = 1
        scrollView.bouncesZoom = true

        // create a UIHostingController to hold our SwiftUI content
        let hostedView = context.coordinator.hostingController.view!
        hostedView.translatesAutoresizingMaskIntoConstraints = true
        hostedView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        hostedView.frame = scrollView.bounds
        scrollView.addSubview(hostedView)

        return scrollView
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(hostingController: UIHostingController(rootView: self.content))
    }

    func updateUIView(_ uiView: UIScrollView, context: Context) {
        // update the hosting controller's SwiftUI content
        context.coordinator.hostingController.rootView = self.content
        assert(context.coordinator.hostingController.view.superview == uiView)
    }

    class Coordinator: NSObject, UIScrollViewDelegate {
        var hostingController: UIHostingController<Content>

        init(hostingController: UIHostingController<Content>) {
            self.hostingController = hostingController
        }

        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return hostingController.view
        }
    }
}

struct ImageViewer: View {
    var image: UIImage
    
    @State private var currentAmount = 0.0
    @State private var finalAmount = 1.0
    @State private var viewState = CGSize.zero

    var body: some View {
        ZoomableScrollView {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct ReciprocityNoteCard: View {
    var note: Note

    var body: some View {
        VStack(alignment: .leading) {
            Text("Reciprocity Calculations")
                .font(.system(size: 12))
                .foregroundColor(Color(.systemGray))
            ForEach(Array(note.reciprocityData as! Set<ReciprocityData>), id: \.self) { result in
                ReciprocityFactorData(result: result)
                    .shadow(color: Color.black.opacity(0.025), radius: 10, y: 8)
            }
        }
        .padding(.bottom, 10)
    }
}

struct FilterNoteCard: View {
    var note: Note
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Filter Factor Calculations")
                .font(.system(size: 12))
                .foregroundColor(Color(.systemGray))
            ForEach(Array(note.filterData as! Set<FilterData>), id: \.self) { result in
                FilterFactorData(result: result)
                    .shadow(color: Color.black.opacity(0.025), radius: 10, y: 8)
            }
        }
        .padding(.bottom, 10)
    }
}

struct BellowsNoteCard: View {
    var note: Note
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Bellows Extension Calculations")
                .font(.system(size: 12))
                .foregroundColor(Color(.systemGray))
            ForEach(Array(note.bellowsData as! Set<BellowsExtensionData>), id: \.self) { result in
                BellowsData(result: result)
                    .shadow(color: Color.black.opacity(0.025), radius: 10, y: 8)
            }
        }
    }
}

struct Gear: View {
    var note: Note
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if note.camera != nil {
                HStack(spacing: 2) {
                    Image(systemName: "camera")
                        .frame(width: 20)
                    Text(note.camera!.manufacturer!)
                    Text(note.camera!.model!)
                }
                .font(.caption)
                .foregroundColor(.accentColor)
            }
            
            if note.lens != nil {
                HStack(spacing: 2) {
                    Image(systemName: "camera.aperture")
                        .frame(width: 20)
                    Text(note.lens!.manufacturer!)
                    Text("\(note.lens!.focalLength)mm f/\(note.lens!.maximumAperture.clean)")
                }
                .font(.caption)
                .foregroundColor(.accentColor)
            }
            
            if note.emulsion != nil {
                HStack(spacing: 2) {
                    Image(systemName: "film")
                        .frame(width: 20)
                    Text(note.emulsion!.manufacturer!)
                    Text(note.emulsion!.name!)
                }
                .font(.caption)
                .foregroundColor(.accentColor)
            }
        }
        .padding(.bottom, 10)
    }
}

struct NoteView: View {
    var note: Note
    
    @State var isEditing: Bool = false
    
    @State var showReciprocitySheet: Bool = false
    @State var showFilterSheet: Bool = false
    @State var showBellowsSheet: Bool = false
    
    @State private var selectedImages: [PhotosPickerItem] = []
    @State private var selectedPhotosData: [Data] = []
    
    @FocusState private var focusedField: FocusField?
    
    @State private var editBody: String = ""
    
    @State private var noteImages: [UIImage] = []
    
    func imagesFromCoreData(object: Data?) -> [UIImage]? {
        var retVal = [UIImage]()

        guard let object = object else { return nil }
        if let dataArray = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: object) {
            for data in dataArray {
                if let data = data as? Data, let image = UIImage(data: data) {
                    retVal.append(image)
                }
            }
        }
        
        return retVal
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if isEditing {
                    TextField("Start typing...", text: $editBody, axis: .vertical)
                        .zIndex(1)
                        .textFieldStyle(.plain)
                        .focused($focusedField, equals: .noteBody)
                        .onAppear {
                            self.focusedField = .noteBody
                        }
                        .padding(.top, 10)
                        .padding(.bottom, 18)
                } else {
                    Text(note.body!)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 10)
                        .padding(.bottom, 20)
                }
                
                if noteImages.count > 0 {
                    VStack {
                        ForEach(noteImages, id: \.self) { image in
                            NavigationLink(destination: ImageViewer(image: image)) {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(8)
                            }
                            .padding(.bottom)
                        }
                    }
                }
                
                Gear(note: note)
                
                if note.reciprocityData!.count > 0 {
                    ReciprocityNoteCard(note: note)
                }
                
                if note.filterData!.count > 0 {
                    FilterNoteCard(note: note)
                }
                
                if note.bellowsData!.count > 0 {
                    BellowsNoteCard(note: note)
                }
            }
            .padding(.horizontal)
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showReciprocitySheet) {
                ReciprocityHistorySheet()
            }
            .sheet(isPresented: $showFilterSheet) {
                FilterHistorySheet()
            }
            .sheet(isPresented: $showBellowsSheet) {
                BellowsExtensionHistorySheet()
            }
            .onAppear {
                editBody = note.body!
                
                let dataImages = note.images ?? Data()
                if dataImages.count > 0 {
                    noteImages = imagesFromCoreData(object: dataImages)!
                }
            }
        }
    }
}
