import SwiftUI
import NoboruCore

struct QuizSummaryView: View {

    private struct Values {
        static let cirlceSize: CGFloat = 80
        static let circleRotation: CGFloat = -90
        static let circleStrokeWidth: CGFloat = 8
    }

    private let summary: QuizSummary

    public init(summary: QuizSummary) {
        self.summary = summary
    }

    public var body: some View {
        VStack {
            Text("Quiz Completed 🎉")
                .font(.largeTitle)
                .padding(.bottom)
            Circle()
                .stroke(
                    Color.red.opacity(0.4),
                    style: StrokeStyle(
                        lineWidth: Values.circleStrokeWidth,
                        lineCap: .round
                    )
                )
                .frame(
                    width: Values.cirlceSize,
                    height: Values.cirlceSize
                )
                .overlay {
                    Circle()
                        .trim(
                            from: 0,
                            to:  CGFloat(summary.correct)/CGFloat(summary.total)
                        )
                        .stroke(
                            Color.green,
                            style: StrokeStyle(
                                lineWidth: Values.circleStrokeWidth
                            )
                        )
                        .rotationEffect(Angle(degrees: Values.circleRotation))
                        .frame(
                            width: Values.cirlceSize,
                            height: Values.cirlceSize
                        )
                }
            Text("\(summary.correct)/\(summary.total) correct answers")
                .font(.title2)
                .fontWeight(.medium)
        }
    }
}

#Preview {
    QuizSummaryView(summary: .init(correct: 8, incorrect: 2))
}
