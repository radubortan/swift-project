import Foundation

class PdfViewModel : ObservableObject {
    @Published var PDFUrl : URL?
    @Published var showShareSheet: Bool = false
}
