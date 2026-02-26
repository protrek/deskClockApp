import UIKit

class AnalogClockView: UIView {
    private let outerCircle = UIView()
    private let innerCircle = UIView()
    private let moonIcon = UIImageView() // 상단의 달 아이콘
    
    // 바늘 및 기타 컴포넌트 선언 (기존 코드 유지)
    private let hourHand = UIView()
    private let minuteHand = UIView()
    private let secondHand = UIView()
    private let centerDot = UIView()
    private var isFaceConfigured = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupClock()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupClock() {
        self.backgroundColor = .clear // 메인 배경은 투명하게
        
        // 1. 바깥쪽 회색 원
        outerCircle.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        addSubview(outerCircle)
        
        // 2. 안쪽 검은색 원
//        innerCircle.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
//        addSubview(innerCircle)
        
        // 3. 달 아이콘 (피그마 디자인 반영)
        moonIcon.image = UIImage(systemName: "moon.fill")
        moonIcon.tintColor = UIColor(red: 1.0, green: 0.7, blue: 0.7, alpha: 1.0) // 연분홍색
        outerCircle.addSubview(moonIcon)
        
        // 4. 바늘 설정 (기존 setupHand 호출)
        setupHand(hourHand, width: 8, height: 60, color: UIColor(white: 0.2, alpha: 1.0))
        setupHand(minuteHand, width: 6, height: 90, color: .white)
        setupHand(secondHand, width: 2, height: 110, color: .red)
        
        innerCircle.backgroundColor = UIColor(white: 0.6, alpha: 1.0)
        addSubview(innerCircle)
        
        addSubview(centerDot)
    }

    private func setupHand(_ hand: UIView, width: CGFloat, height: CGFloat, color: UIColor) {
        hand.backgroundColor = color
        hand.frame = CGRect(x: 0, y: 0, width: width, height: height)
        hand.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0) // 아래쪽 끝을 기준으로 회전
        addSubview(hand)
    }

//    override func layoutSubviews() {
//        super.layoutSubviews()
//        let center = CGPoint(x: bounds.midX, y: bounds.midY)
//        let side = min(frame.width, frame.height)
//        
//        // 바깥쪽 원 크기 (전체)
//        outerCircle.frame = CGRect(x: 0, y: 0, width: side, height: side)
//        outerCircle.layer.cornerRadius = side / 2
//        outerCircle.center = center
//        
//        // 안쪽 원 크기 (약 55% 크기)
//        let innerSide = side * 0.05
//        innerCircle.frame = CGRect(x: 0, y: 0, width: innerSide, height: innerSide)
//        innerCircle.layer.cornerRadius = innerSide / 2
//        innerCircle.center = center
//        
//        // 달 아이콘 위치 (12시 방향 상단)
//        moonIcon.frame = CGRect(x: (side - 20) / 2, y: 30, width: 20, height: 20)
//        
//        if !isFaceConfigured {
//            //setupTicks(radius: side / 2 - 10)
//            setupClockFaceCircle()
//            isFaceConfigured = true
//        }
//        
//        // 바늘 위치 고정
//        [hourHand, minuteHand, secondHand, centerDot].forEach { $0.center = center }
//    }

    // AnalogClockView.swift 수정

    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        
        // 시계판의 점들을 모두 지우고 새로 그려야 바뀐 크기에 맞게 재배치됩니다.
        // (또는 기존 점들의 center 값만 업데이트하는 로직이 필요합니다.)
        self.subviews.filter { $0 is UILabel || $0.layer.cornerRadius > 0 }.forEach {
            if $0 != innerCircle && $0 != outerCircle && $0 != centerDot {
                $0.removeFromSuperview()
            }
        }
        
        setupClockFaceCircle() // 바뀐 크기(frame)에 맞춰 다시 그리기
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        
         // 이중 원형 구조 배치
        outerCircle.frame = bounds
        outerCircle.layer.cornerRadius = bounds.width / 2
        
        let innerSide = bounds.width * 0.08
        innerCircle.frame = CGRect(x: 0, y: 0, width: innerSide, height: innerSide)
        innerCircle.center = center
        innerCircle.layer.cornerRadius = innerSide / 2

        // 중요: 이미 구성되었다면 다시 그리지 않음 (중복 방지)
        if !isFaceConfigured {
            setupClockFaceCircle() // 원형 점 눈금 생성
            isFaceConfigured = true
        }

        
        [hourHand, minuteHand, secondHand, centerDot, innerCircle, outerCircle].forEach {
            $0.center = center
        }
    }
    
#if NOT_LANDSCAPE
    override func layoutSubviews() {
        super.layoutSubviews()
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        // 이중 원형 구조 배치
        outerCircle.frame = bounds
        outerCircle.layer.cornerRadius = bounds.width / 2
        
        let innerSide = bounds.width * 0.08
        innerCircle.frame = CGRect(x: 0, y: 0, width: innerSide, height: innerSide)
        innerCircle.center = center
        innerCircle.layer.cornerRadius = innerSide / 2

        // 중요: 이미 구성되었다면 다시 그리지 않음 (중복 방지)
        if !isFaceConfigured {
            setupClockFaceCircle() // 원형 점 눈금 생성
            isFaceConfigured = true
        }

        // 바늘 위치 초기화
        [hourHand, minuteHand, secondHand, centerDot].forEach { $0.center = center }
    }
#endif // NOT_LANDSCAPE
    
    // 눈금 추가 (선택 사항)
    private func setupTicks(radius: CGFloat) {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        for i in 0..<12 {
            let tick = UIView()
            tick.backgroundColor = UIColor(white: 0.9, alpha: 0.5)
            tick.frame = CGRect(x: 0, y: 0, width: 2, height: 8)
            tick.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
            tick.center = center
            tick.transform = CGAffineTransform(rotationAngle: CGFloat(i) * 30 * .pi / 180)
                .translatedBy(x: 0, y: -radius)
            addSubview(tick)
        }
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
    
    private func setupClockFaceCircle() {
        // 테두리에서 약간 안쪽으로 반지름 설정
        let radius = self.frame.width / 2 - 15
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        
        // 60개의 점 그리기
        for i in 0..<60 {
            let dot = UIView()
            
            // 5분 단위 점(큰 점)과 일반 점(작은 점) 구분
            let isFiveMinute = i % 5 == 0
            let dotSize: CGFloat = isFiveMinute ? 4 : 2
            
            dot.frame = CGRect(x: 0, y: 0, width: dotSize, height: dotSize)
            dot.backgroundColor = isFiveMinute ? .white : UIColor(white: 1.0, alpha: 0.3)
            dot.layer.cornerRadius = dotSize / 2 // 원으로 만들기
            
            // 각도 계산 (6도씩 회전)
            let angle = CGFloat(i) * 6 * .pi / 180 - (.pi / 2)
            
            // 원형 궤적상의 좌표 계산
            let x = center.x + radius * cos(angle)
            let y = center.y + radius * sin(angle)
            
            dot.center = CGPoint(x: x, y: y)
            addSubview(dot)
        }
    }
    
    private func setupClockFaceBar() {
        let radius = self.frame.width / 2 - 10 // 테두리와 눈금 사이 간격
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        
        // 60개의 눈금 그리기 (360도 / 60분 = 6도씩)
        for i in 0..<60 {
            let tick = UIView()
            
            // 5분 단위 눈금은 더 밝고 길게 설정
            let isFiveMinuteTick = i % 5 == 0
            tick.backgroundColor = isFiveMinuteTick ? .white : .darkGray
            
            let width: CGFloat = isFiveMinuteTick ? 3 : 1
            let height: CGFloat = isFiveMinuteTick ? 15 : 7
            
            tick.frame = CGRect(x: 0, y: 0, width: width, height: height)
            
            // 눈금의 회전축을 아래쪽 끝으로 설정하여 원형으로 배치
            tick.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
            tick.center = center
            
            // 각도 계산 (6도씩 회전)
            let angle = CGFloat(i) * 6 * .pi / 180
            
            // 1. 회전 시키고 2. 반지름만큼 밖으로 밀어내기
            tick.transform = CGAffineTransform(rotationAngle: angle)
                .translatedBy(x: 0, y: -radius)
                
            addSubview(tick)
        }
    }
    
    private func setupClockFaceNumber() {
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
