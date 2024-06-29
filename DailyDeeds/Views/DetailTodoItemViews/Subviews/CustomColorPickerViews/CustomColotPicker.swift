import SwiftUI

struct CustomColorPicker: View {
    @Binding 
    var selectedColor: Color
    
    @State 
    private var brightness: Double = 1.0
    @State
    private var colorPosition: CGPoint = .zero
    @State
    private var height: CGFloat = 0
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Rectangle()
                        .fill(selectedColor)
                        .frame(width: 50, height: 50)
                        .border(Color.black, width: 1)
                    Text(selectedColor.hexString)
                        .padding()
                }
            } header: {
                Text("Цвет")
            }
            .listRowBackground(Res.Color.Back.secondary)
            
            Section {
                GeometryReader { geometry in
                    ZStack {
                        ColorPalette()
                            .frame(width: geometry.size.width, height: geometry.size.width)
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { value in
                                        let x = min(max(value.location.x, 0), geometry.size.width)
                                        let y = min(max(value.location.y, 0), geometry.size.height)
                                        colorPosition = CGPoint(x: x, y: y)
                                        selectedColor = getColor(at: colorPosition, in: geometry.size)
                                    }
                            )
                        
                        Circle()
                            .fill(selectedColor)
                            .frame(width: 20, height: 20)
                            .position(colorPosition)
                            .shadow(radius: 5)
                    }
                    .frame(width: geometry.size.width, height: geometry.size.width)
                    .onAppear {
                        // FIXME: - Установка начальной позиции в зависимости от выбранного цвета
                        // colorPosition = initialPosition(for: selectedColor, in: geometry.size)
                        height = geometry.size.width
                    }
                }
            }
            .listRowBackground(Res.Color.Back.secondary)
            .frame(height: height)
            
            Section {
                Slider(value: $brightness, in: 0...1, step: 0.01)
                    .onChange(of: brightness) {
                        selectedColor = selectedColor.adjustBrightness(by: brightness)
                    }
            } header: {
                Text("Яркость: \(String(format: "%.0f", brightness * 100))%")
            }
            .listRowBackground(Res.Color.Back.secondary)
        }
        .listSectionSpacing(16)
        .scrollContentBackground(.hidden)
        .background(Res.Color.Back.primary)
    }
    
    private func getColor(at point: CGPoint, in size: CGSize) -> Color {
        let uiColor = UIColor(
            hue: point.x / size.width,
            saturation: point.y / size.height,
            brightness: CGFloat(brightness),
            alpha: 1
        )
        return Color(uiColor)
    }
    
    private func initialPosition(for color: Color, in size: CGSize) -> CGPoint {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        UIColor(color).getHue(
            &hue,
            saturation: &saturation,
            brightness: &brightness,
            alpha: &alpha
        )
        let x = hue * size.width
        let y = saturation * size.height
        return CGPoint(x: x, y: y)
    }
}
