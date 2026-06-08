import SwiftUI

struct ContentView: View {
    @State private var display = "0"
    @State private var currentNumber: Double = 0
    @State private var previousNumber: Double = 0
    @State private var currentOperation: Operation = .none
    @State private var shouldResetDisplay = false

    enum Operation {
        case none, add, subtract, multiply, divide
    }

    let buttons: [[CalcButton]] = [
        [.clear, .negative, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equals]
    ]

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "1a1a2e"), Color(hex: "16213e"), Color(hex: "0f3460")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 12) {
                Spacer()

                HStack {
                    Spacer()
                    Text(display)
                        .font(.system(size: displayFontSize, weight: .light, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.4)
                        .padding(.horizontal, 28)
                }
                .padding(.bottom, 20)

                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { button in
                            ButtonView(button: button) {
                                handleTap(button)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.bottom, 20)
        }
    }

    private var displayFontSize: CGFloat {
        if display.count > 9 { return 50 }
        if display.count > 7 { return 60 }
        return 72
    }

    private func handleTap(_ button: CalcButton) {
        switch button {
        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine:
            if shouldResetDisplay {
                display = button.rawValue
                shouldResetDisplay = false
            } else {
                display = display == "0" ? button.rawValue : display + button.rawValue
            }
        case .decimal:
            if shouldResetDisplay {
                display = "0."
                shouldResetDisplay = false
            } else if !display.contains(".") {
                display += "."
            }
        case .add, .subtract, .multiply, .divide:
            previousNumber = Double(display) ?? 0
            currentOperation = button.toOperation
            shouldResetDisplay = true
        case .equals:
            currentNumber = Double(display) ?? 0
            let result = calculate()
            display = formatResult(result)
            currentOperation = .none
        case .clear:
            display = "0"
            currentNumber = 0
            previousNumber = 0
            currentOperation = .none
        case .negative:
            if let value = Double(display) {
                display = formatResult(-value)
            }
        case .percent:
            if let value = Double(display) {
                display = formatResult(value / 100)
            }
        }
    }

    private func calculate() -> Double {
        switch currentOperation {
        case .add: return previousNumber + currentNumber
        case .subtract: return previousNumber - currentNumber
        case .multiply: return previousNumber * currentNumber
        case .divide: return currentNumber != 0 ? previousNumber / currentNumber : 0
        case .none: return currentNumber
        }
    }

    private func formatResult(_ value: Double) -> String {
        if value == value.rounded() && abs(value) < 1e15 {
            return String(format: "%.0f", value)
        }
        let formatted = String(format: "%.8f", value)
        // Remove trailing zeros after decimal point
        if formatted.contains(".") {
            var result = formatted
            while result.hasSuffix("0") { result.removeLast() }
            if result.hasSuffix(".") { result.removeLast() }
            return result
        }
        return formatted
    }
}

enum CalcButton: String, Hashable {
    case zero = "0", one = "1", two = "2", three = "3", four = "4"
    case five = "5", six = "6", seven = "7", eight = "8", nine = "9"
    case add = "+", subtract = "−", multiply = "×", divide = "÷"
    case equals = "=", decimal = ".", clear = "AC", negative = "+/−", percent = "%"

    var toOperation: ContentView.Operation {
        switch self {
        case .add: return .add
        case .subtract: return .subtract
        case .multiply: return .multiply
        case .divide: return .divide
        default: return .none
        }
    }

    var backgroundColor: Color {
        switch self {
        case .add, .subtract, .multiply, .divide, .equals:
            return Color(hex: "e94560")
        case .clear, .negative, .percent:
            return Color(hex: "533483").opacity(0.7)
        default:
            return Color.white.opacity(0.12)
        }
    }

    var foregroundColor: Color {
        return .white
    }

    var isWide: Bool { self == .zero }
}

struct ButtonView: View {
    let button: CalcButton
    let action: () -> Void
    @State private var isPressed = false

    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.1)) { isPressed = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) { isPressed = false }
            }
            action()
        }) {
            Text(button.rawValue)
                .font(.system(size: 28, weight: .medium, design: .rounded))
                .foregroundColor(button.foregroundColor)
                .frame(
                    maxWidth: button.isWide ? .infinity : .infinity,
                    maxHeight: .infinity
                )
                .frame(height: 72)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(button.backgroundColor)
                        .shadow(color: button.backgroundColor.opacity(0.4), radius: isPressed ? 2 : 8, y: isPressed ? 1 : 4)
                )
                .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(.plain)
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        self.init(
            red: Double((rgb >> 16) & 0xFF) / 255.0,
            green: Double((rgb >> 8) & 0xFF) / 255.0,
            blue: Double(rgb & 0xFF) / 255.0
        )
    }
}

#Preview {
    ContentView()
}
