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
    let customTabBar = CustomTabBarView()
    
    private var landscapeConstraints: [NSLayoutConstraint] = []
    private var portraitConstraints: [NSLayoutConstraint] = []
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .systemBackground
        view.backgroundColor = UIColor(white: 0.95, alpha: 1.0) // 연한 회색 배경
        setupLayout()
        //startClockTimer()
        startClock()
    }
    // 화면 방향이 바뀔 때 호출되는 메서드
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { _ in
            if size.width > size.height {
                // 가로 모드일 때
                NSLayoutConstraint.deactivate(self.portraitConstraints)
                NSLayoutConstraint.activate(self.landscapeConstraints)
            } else {
                // 세로 모드일 때
                NSLayoutConstraint.deactivate(self.landscapeConstraints)
                NSLayoutConstraint.activate(self.portraitConstraints)
            }
            self.view.layoutIfNeeded()
        })
    }
    
    private func setupLayout() {
        [analogClock, cityCard, customTabBar].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        // 1. 공통 제약 조건 (어떤 방향이든 똑같은 것)
        analogClock.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        // 2. 세로 모드 전용 제약 조건
        portraitConstraints = [
            analogClock.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            analogClock.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            analogClock.widthAnchor.constraint(equalToConstant: 280),
            analogClock.heightAnchor.constraint(equalToConstant: 280),

            cityCard.topAnchor.constraint(equalTo: analogClock.bottomAnchor, constant: 40),
            cityCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cityCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cityCard.heightAnchor.constraint(equalToConstant: 120)
        ]

        // 3. 가로 모드 전용 제약 조건 (시계를 더 크게 만들고 카드 위치 조정)
        // --- 가로 모드 제약 조건 (시계는 왼쪽, 카드는 오른쪽) ---
        landscapeConstraints = [
            analogClock.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            analogClock.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            analogClock.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7),
            analogClock.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7),

            cityCard.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cityCard.leadingAnchor.constraint(equalTo: analogClock.trailingAnchor, constant: 40),
            cityCard.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            cityCard.heightAnchor.constraint(equalToConstant: 140)
        ]

        // 초기 방향에 맞춰 활성화
        if view.frame.width > view.frame.height {
            NSLayoutConstraint.activate(landscapeConstraints)
        } else {
            NSLayoutConstraint.activate(portraitConstraints)
        }
#if NOT_LANDSCAPE
        NSLayoutConstraint.activate([
            // 1. 아날로그 시계: 화면 상단에서 일정 거리 유지
            analogClock.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            analogClock.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            analogClock.widthAnchor.constraint(equalToConstant: 280),
            analogClock.heightAnchor.constraint(equalToConstant: 280),

            // 2. 도시 카드: 시계 아래에 배치 (중복 방지를 위해 시계 하단 기준으로 배치)
            cityCard.topAnchor.constraint(equalTo: analogClock.bottomAnchor, constant: 60),
            cityCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cityCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cityCard.heightAnchor.constraint(equalToConstant: 120),

            // 3. 커스텀 탭 바: 화면 최하단에 고정
            customTabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            customTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            customTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            customTabBar.heightAnchor.constraint(equalToConstant: 70)
        ])
#endif // NOT_LANDSCAPE
    }

    private func updateLayoutForOrientation() {
        if view.frame.width > view.frame.height {
            // 가로 모드
            NSLayoutConstraint.deactivate(portraitConstraints)
            NSLayoutConstraint.activate(landscapeConstraints)
            customTabBar.isHidden = true // 가로 모드에서 탭바를 숨겨 공간 확보 (선택 사항)
        } else {
            // 세로 모드
            NSLayoutConstraint.deactivate(landscapeConstraints)
            NSLayoutConstraint.activate(portraitConstraints)
            customTabBar.isHidden = false
        }
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

