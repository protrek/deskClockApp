//
//  CustomTabBarView.swift
//  deskClockApp
//
//  Created by protrek on 2/26/26.
//
import UIKit

class CustomTabBarView: UIView {
    private let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // 탭 바 배경 설정
        self.backgroundColor = UIColor(white: 0.98, alpha: 1.0)
        self.layer.cornerRadius = 35 // 둥근 디자인
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually // .equalSpacing 대신 .fillEqually 권장
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        // 기존 아이템들을 모두 제거한 후 다시 추가 (중복 방지)
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        
        //addTabItem(imageName: "globe", title: "WORLD", isSelected: true) // 중앙 강조
        addTabItem(imageName: "globe", isSelected: true) // 중앙 강조
        addTabItem(imageName: "alarm", isSelected: false)
        addTabItem(imageName: "timer", isSelected: false)
        addTabItem(imageName: "stopwatch", isSelected: false)
    }
    
    // CustomTabBarView.swift 내의 메서드 수정
    private func addTabItem(imageName: String, title: String? = nil, isSelected: Bool) {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        // 아이콘 생성 및 설정
        let icon = UIImageView(image: UIImage(systemName: imageName))
        icon.tintColor = isSelected ? .black : .lightGray
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        if let title = title {
            // "WORLD"와 같이 텍스트가 있는 경우 (스크린샷 [cite: 13] 참고)
            let label = UILabel()
            label.text = title
            label.font = .systemFont(ofSize: 14, weight: .bold)
            label.textColor = isSelected ? .black : .lightGray
            label.translatesAutoresizingMaskIntoConstraints = false
            
            let hStack = UIStackView(arrangedSubviews: [icon, label])
            hStack.axis = .horizontal
            hStack.spacing = 8
            hStack.alignment = .center
            hStack.translatesAutoresizingMaskIntoConstraints = false
            
            container.addSubview(hStack)
            
            NSLayoutConstraint.activate([
                hStack.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                hStack.centerYAnchor.constraint(equalTo: container.centerYAnchor),
                icon.widthAnchor.constraint(equalToConstant: 24),
                icon.heightAnchor.constraint(equalToConstant: 24)
            ])
        } else {
            // 아이콘만 있는 경우
            container.addSubview(icon)
            
            NSLayoutConstraint.activate([
                icon.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                icon.centerYAnchor.constraint(equalTo: container.centerYAnchor),
                icon.widthAnchor.constraint(equalToConstant: 24),
                icon.heightAnchor.constraint(equalToConstant: 24)
            ])
        }
        
        // 스택뷰에 추가 (distribution이 .fillEqually면 균등하게 배분되어 겹치지 않음)
        stackView.addArrangedSubview(container)
    }
}
