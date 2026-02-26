import UIKit

class AnalogClockView: UIView {
    private let hourHand = UIView()
    private let minuteHand = UIView()
    private let secondHand = UIView() // 초침 추가
    private let centerDot = UIView()
    private var isFaceConfigured = false // 중복 생성 방지
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupClock()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupClock() {
        self.backgroundColor = UIColor(white: 0.15, alpha: 1.0)
        
        // 바늘 공통 설정 (두께와 색상)
        setupHand(hourHand, width: 6, height: 60, color: .lightGray)
        setupHand(minuteHand, width: 4, height: 90, color: .white)
        setupHand(secondHand, width: 2, height: 100, color: .systemPink) // 초침은 얇고 강조된 색상으로
        
        // 중앙 점 추가
        centerDot.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        centerDot.backgroundColor = .white
        centerDot.layer.cornerRadius = 5
        addSubview(centerDot)
    }

    private func setupHand(_ hand: UIView, width: CGFloat, height: CGFloat, color: UIColor) {
        hand.backgroundColor = color
        hand.frame = CGRect(x: 0, y: 0, width: width, height: height)
        hand.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0) // 아래쪽 끝을 기준으로 회전
        addSubview(hand)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.width / 2
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        // 뷰의 크기가 잡힌 후 숫자판 설정
        if !isFaceConfigured && self.frame.width > 0 {
            setupClockFace()
            isFaceConfigured = true
        }
        
        // 기존 바늘 위치 고정 코드
        let midPoint = CGPoint(x: bounds.midX, y: bounds.midY)

        hourHand.center = center
        minuteHand.center = center
        secondHand.center = center
        centerDot.center = center
    }

    // 각도 계산 및 애니메이션 적용 (가장 중요한 부분)
    func updateHands(date: Date) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second, .nanosecond], from: date)
        
        let hour = CGFloat(components.hour ?? 0 % 12)
        let minute = CGFloat(components.minute ?? 0)
        let second = CGFloat(components.second ?? 0)
        let nanosecond = CGFloat(components.nanosecond ?? 0)

        // 나노초 단위까지 계산하여 1초 사이의 간격을 메꿉니다. (이게 핵심입니다!)
        let preciseSecond = second + (nanosecond / 1_000_000_000)
        
        // 각도 계산 (라디안)
        let hAngle = (hour * 30 + minute * 0.5) * .pi / 180
        let mAngle = (minute * 6 + second * 0.1) * .pi / 180
        let sAngle = (preciseSecond * 6) * .pi / 180 // 초당 6도씩 부드럽게 회전

        // 애니메이션 블록 없이 직접 transform을 적용하여 멈춤 현상을 방지합니다.
        self.hourHand.transform = CGAffineTransform(rotationAngle: hAngle)
        self.minuteHand.transform = CGAffineTransform(rotationAngle: mAngle)
        self.secondHand.transform = CGAffineTransform(rotationAngle: sAngle)
    }
    
    private func setupClockFace() {
        let radius = self.frame.width / 2 - 25 // 시계 테두리에서 안쪽으로 들어온 거리
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        
        for i in 1...12 {
            let label = UILabel()
            label.text = "\(i)"
            label.font = .systemFont(ofSize: 20, weight: .semibold)
            label.textColor = .lightGray
            label.textAlignment = .center
            label.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            
            // 각도 계산 (12시는 0도 또는 360도이므로 -90도 보정)
            let angle = CGFloat(i) * 30 * .pi / 180 - (.pi / 2)
            
            // 숫자의 중심 위치 계산
            let x = center.x + radius * cos(angle)
            let y = center.y + radius * sin(angle)
            
            label.center = CGPoint(x: x, y: y)
            addSubview(label)
        }
    }
}
