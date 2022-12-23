import SwiftUI

private let screen = UIScreen.main.bounds

struct ContentView: View {
    
    @State var showContent: Bool = false
    @State var viewState = CGSize.zero
    @State var selectedBook: Book = .books.first!
    var body: some View {
        
        ZStack {
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    Text("My Books")
                        .font(.system(size: 28, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                        .padding(.trailing)
                        .padding(.top)
                    VStack {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150, maximum: 170), spacing: 20)], spacing: 20) {
                            ForEach(Book.books) { book in
                                Button(action: {
                                    selectedBook = book
                                    showContent = true
                                }) {
                                    FolderLikeView(book: book)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
                .background(Color.init(hex: 0xFAFAFA))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
            .offset(y: showContent ? -450 : 0)
            .rotation3DEffect(Angle(degrees: showContent ? Double(viewState.height / 10) - 10 : 0), axis: (x: 10.0, y: 0, z: 0))
            .scaleEffect(showContent ? 0.9 : 1)
            .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0), value: showContent)
            .edgesIgnoringSafeArea(.bottom)
            
            
            FolderDetailView(book: selectedBook)
                .background(Color.black.opacity(0.001))
                .offset(y: showContent ? 0 : screen.height)
                .offset(y: viewState.height)
                .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0), value: showContent)
                .onTapGesture {
                    self.showContent.toggle()
                }
                .gesture(
                    DragGesture().onChanged { value in
                        self.viewState = value.translation
                    }
                        .onEnded { value in
                            if self.viewState.height > 50 {
                                self.showContent = false
                            }
                            self.viewState = .zero
                        }
                )
        }
        
    }
}


struct FolderLikeView: View {
    let book: Book
    var gradientTextBackground: LinearGradient {
        let _color: Color = .init(hex: 0x111B1C)
        let gradient = Gradient(stops: [
            .init(color: _color.opacity(0), location: 0),
            .init(color: _color.opacity(0.2), location: 0.6),
            .init(color: _color.opacity(0.7), location: 0.75),
            .init(color: _color.opacity(1), location: 1),
        ])
        return LinearGradient(gradient: gradient, startPoint: .top, endPoint: .bottom)
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            BackCardView()
                .frame(height: 250)
                .frame(maxWidth: .infinity)
                .background(Color(hex: 0x6DC4DD))
                .clipShape(Parallelogram(depth: 30, flipped: true))
                .padding(.trailing, 20)
            
            ZStack(alignment: .bottomLeading) {
                VStack(alignment: .leading) {
                    Spacer()
                    
                    Text(book.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(book.author)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer().frame(height: 10)
                }
                .padding([.leading, .trailing], 10)
                .frame(width: .infinity, height: 220)
                .frame(alignment: .leading)
                .background(gradientTextBackground)
            }
            .background(Image(book.url)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 220, alignment: .center))
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .frame(height: 220)
            .frame(maxWidth: .infinity)
            
        }
        .frame(maxWidth: .infinity)
    }
    
}

struct BackCardView: View {
    var body: some View {
        VStack {
            Spacer()
        }
    }
}


struct Parallelogram: Shape {
    
    var depth: CGFloat
    var flipped: Bool = false
    var cornerRadius: CGFloat = 12.0
    
    func path(in rect: CGRect) -> Path {
        Path { p in
            if flipped {
                p.move(to: CGPoint(x: 0, y: 0))
                p.addArc(center: .init(x: cornerRadius, y: cornerRadius),
                         radius: cornerRadius,
                         startAngle: .init(degrees: 180),
                         endAngle: .init(degrees: 270),
                         clockwise: false)
                p.addLine(to: CGPoint(x: rect.width - cornerRadius, y: depth))
                p.addArc(center: .init(x: rect.width - cornerRadius, y: depth + cornerRadius),
                         radius: cornerRadius,
                         startAngle: .init(degrees: -90),
                         endAngle: .init(degrees: 0),
                         clockwise: false)
                p.addLine(to: CGPoint(x: rect.width, y: rect.height))
                p.addArc(center: .init(x: rect.width - cornerRadius, y: rect.height - cornerRadius),
                         radius: cornerRadius,
                         startAngle: .init(degrees: 0),
                         endAngle: .init(degrees: 90),
                         clockwise: false)
                p.addLine(to: CGPoint(x: cornerRadius, y: rect.height - depth))
                p.addArc(center: .init(x: cornerRadius, y: rect.height - depth - cornerRadius),
                         radius: cornerRadius,
                         startAngle: .init(degrees: 90),
                         endAngle: .init(degrees: 180),
                         clockwise: false)
            } else {
                p.move(to: CGPoint(x: 0, y: depth))
                p.addLine(to: CGPoint(x: rect.width, y: 0))
                p.addLine(to: CGPoint(x: rect.width, y: rect.height - depth))
                p.addLine(to: CGPoint(x: 0, y: rect.height))
            }
            p.closeSubpath()
        }
    }
    
}

private extension CGFloat {
    func toRadians() -> Angle {
        return .init(radians: Double(self) * .pi / 180.0)
    }
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

struct Book: Identifiable {
    var id: String { return title }
    let title: String
    let author: String
    let url: String
    let price: Double
    
    static let books: [Book] = [
        .init(title: "Sidd HARTHA", author: "Hermann Hesse", url: "cover", price: 29.99),
        .init(title: "Thirst", author: "Varsha Bajaj for Penguin Random House.", url: "cover4", price: 59.99),
        .init(title: "Lightning Strike", author: "Tanya Landman", url: "lightning", price: 25.5),
        .init(title: "Hide-and-Seek History: The Greeks", author: "Jonny Marx", url: "greek", price: 69.96),
        .init(title: "Hide-and-Seek History: The Egyptians", author: "Jonny Marx", url: "egypt", price: 1.99),
        .init(title: "Bracelets for Bina's Brothers", author: "Charlesbridge", url: "bracelets", price: 2.99),
        .init(title: "Fortress Blood", author: "L. D. Goffigan", url: "cover2", price: 6.99),
        .init(title: "All this time", author: "Mikki Daughtry", url: "cover3", price: 7.99),
        .init(title: "The Little Mermaid", author: "Hans Christian Andersan", url: "cover5", price: 12.99),
        .init(title: "Late Night Thoughts", author: "Vee.", url: "cover6", price: 99.99)
    ]
    
}


struct BlurView: UIViewRepresentable {
    typealias UIViewType = UIView
    var style: UIBlurEffect.Style
    
    func makeUIView(context: UIViewRepresentableContext<BlurView>) -> UIView {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = .clear
        
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurView, at: 0)
        
        NSLayoutConstraint.activate([
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<BlurView>) {
        
    }
}
