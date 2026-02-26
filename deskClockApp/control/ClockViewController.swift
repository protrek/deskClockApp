//
//  ClockViewController.swift
//  deskClockApp
//
//  Created by protrek on 2/25/26.
//
import UIKit // 이 줄을 반드시 추가해야 합니다.

class ClockViewController: UIViewController {
    var mainClock = WorldClockModel(cityName: "Newport Beach", country: "USA", timeZoneIdentifier: "PST")
    var subClock = WorldClockModel(cityName: "New York", country: "USA", timeZoneIdentifier: "EST")
    
    let analogClock = AnalogClockView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
    let cityCard = CityCardView()
    
    // Timer 대신 CADisplayLink 사용
    private var displayLink: CADisplayLink? // Timer 대신 사용
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        //startClockTimer()
        startClock()
    }
    
    private func setupLayout() {
        // 2. 아날로그 시계 추가 및 위치 설정
        analogClock.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(analogClock)
        
        view.addSubview(cityCard)
        cityCard.translatesAutoresizingMaskIntoConstraints = false
        
        // 3. Auto Layout 제약 조건 (화면 중앙 배치)
        NSLayoutConstraint.activate([
            analogClock.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            analogClock.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            analogClock.widthAnchor.constraint(equalToConstant: 250),
            analogClock.heightAnchor.constraint(equalToConstant: 250),
            
            // 도시 카드 하단 배치
            cityCard.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            cityCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cityCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cityCard.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        // 4. 레이아웃이 적용되도록 강제 호출
        view.layoutIfNeeded()
        analogClock.layer.cornerRadius = 125 // 크기가 결정된 후 곡률 적용
    }

    private func startClockTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            // 1. 모델에서 시간 데이터 가져오기
            let now = self.mainClock.localTime
            
            // 2. 뷰 업데이트 명령 (Controller의 역할)
            self.analogClock.updateHands(date: now)
            // 수정 후 코드:
            self.cityCard.configure(with: self.subClock)
        }
    }
    
    private func startClock() {
        // 기존 타이머가 있다면 중지
        displayLink?.invalidate()
        
        // 화면 주사율에 맞춰 호출되는 DisplayLink 설정
        displayLink = CADisplayLink(target: self, selector: #selector(updateClock))
        // 스크롤 등 다른 작업 중에도 멈추지 않도록 .common 모드에 추가
        displayLink?.add(to: .main, forMode: .common)
    }

    @objc private func updateClock() {
        let now = Date()
        // 1. 아날로그 시계 업데이트
        analogClock.updateHands(date: now)
        // 2. 하단 도시 카드 업데이트
        cityCard.configure(with: subClock)
    }

    // 메모리 관리를 위해 화면이 사라질 때 해제
    deinit {
        displayLink?.invalidate()
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm"
        return formatter.string(from: date)
    }
}

