import SwiftUI

struct Bookmark: Identifiable {
    let id = UUID()
    var title: String
    var description: String
}

struct ContentView: View {
    @State var bookmarks = [
        Bookmark(title: "第一個書籤", description: "這是第一個書籤的描述。"),
        Bookmark(title: "第二個書籤", description: "這是第二個書籤的描述。"),
        Bookmark(title: "第三個書籤", description: "這是第三個書籤的描述。")
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "#0f2027").edgesIgnoringSafeArea(.all) // 深藍色背景
                
                List {
                    ForEach($bookmarks) { $bookmark in
                        NavigationLink(destination: BookmarkDetail(bookmark: $bookmark)) {
                            VStack(alignment: .leading, spacing: 10) {
                                Text(bookmark.title)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(hex: "#f4f4f4")) // 米白色
                                Text(bookmark.description)
                                    .font(.body)
                                    .foregroundColor(Color(hex: "#f4f4f4").opacity(0.8)) // 米白色，帶透明度
                            }
                            .padding()
                            .background(Color(hex: "#203a43").opacity(0.5)) // 深灰色，帶透明度
                            .cornerRadius(10)
                            .padding(.vertical, 5)
                            .shadow(color: Color(hex: "#2c5364"), radius: 3, x: 0, y: 2) // 深藍色陰影
                        }
                    }
                }
                .navigationTitle("書籤列表")
            }
        }
    }
}

struct BookmarkDetail: View {
    @Binding var bookmark: Bookmark
    @State private var isReadingModeActive = false // 判斷是否進入朗讀模式
    @State private var editingTitle = ""
    @State private var editingDescription = ""
    
    var body: some View {
        ZStack {
            Color(hex: "#0f2027").edgesIgnoringSafeArea(.all) // 深藍色背景
            
            VStack {
                Spacer()
                TextEditor(text: $editingTitle)
                    .padding()
                TextEditor(text: $editingDescription)
                    .padding()
                Spacer()
                
                HStack {
                    Button(action: {
                        // 保存編輯的內容
                        bookmark.title = editingTitle
                        bookmark.description = editingDescription
                    }) {
                        Text("保存")
                            .foregroundColor(Color(hex: "#f4f4f4")) // 米白色
                            .padding()
                            .background(Color(hex: "#203a43")) // 深灰色
                            .cornerRadius(10)
                            .shadow(color: Color(hex: "#2c5364"), radius: 3, x: 0, y: 2) // 深藍色陰影
                    }
                    Button(action: {
                        // 進入朗讀模式
                        isReadingModeActive.toggle()
                    }) {
                        Text("進入朗讀模式")
                            .foregroundColor(Color(hex: "#f4f4f4")) // 米白色
                            .padding()
                            .background(Color(hex: "#203a43")) // 深灰色
                            .cornerRadius(10)
                            .shadow(color: Color(hex: "#2c5364"), radius: 3, x: 0, y: 2) // 深藍色陰影
                    }
                }
                .padding()
            }
            .onAppear {
                // 初始化編輯內容
                editingTitle = bookmark.title
                editingDescription = bookmark.description
            }
            .sheet(isPresented: $isReadingModeActive, content: {
                // 這裡將會顯示朗讀模式的內容
                ReadingModeView(bookmark: $bookmark)
            })
            .navigationTitle("編輯書籤")
        }
    }
}

struct ReadingModeView: View {
    @Binding var bookmark: Bookmark
    
    var body: some View {
        ZStack {
            Color(hex: "#0f2027").edgesIgnoringSafeArea(.all) // 深藍色背景
            
            VStack {
                Spacer()
                Text("朗讀模式")
                    .foregroundColor(Color(hex: "#f4f4f4")) // 米白色
                    .padding()
                    .background(Color(hex: "#203a43")) // 深灰色
                    .cornerRadius(10)
                    .shadow(color: Color(hex: "#2c5364"), radius: 3, x: 0, y: 2) // 深藍色陰影
                Spacer()
            }
        }
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#", into: nil)
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
