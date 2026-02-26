import UIKit

class CityCardView: UIView {
    private let cityLabel = UILabel()
    private let timeLabel = UILabel()
    private let iconImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        self.backgroundColor = UIColor(white: 0.1, alpha: 1.0) // 매우 어두운 회색
        self.layer.cornerRadius = 20
        
        // 도시 이름 레이블
        cityLabel.textColor = .lightGray
        cityLabel.font = .systemFont(ofSize: 14, weight: .medium)
        
        // 시간 레이블 (크고 굵게)
        timeLabel.textColor = .white
        timeLabel.font = .systemFont(ofSize: 32, weight: .bold)
        
        // 아이콘 (오른쪽 배치)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .white

        // 레이아웃 구성 (Auto Layout)
        [cityLabel, timeLabel, iconImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }

        NSLayoutConstraint.activate([
            cityLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            cityLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            timeLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 5),
            timeLabel.leadingAnchor.constraint(equalTo: cityLabel.leadingAnchor),
            
            iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            iconImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    // 데이터를 뷰에 적용하는 함수
    func configure(with model: WorldClockModel) {
        cityLabel.text = "\(model.cityName), \(model.country)"
        timeLabel.text = formattedCurrentTime()
        iconImageView.image = UIImage(systemName: "clock") // 기본 아이콘 (model에 아이콘 정보가 없으므로 기본값 사용)
    }

    // 현재 시간을 포맷팅하여 문자열로 반환 (기본: 기기 시간대)
    private func formattedCurrentTime(timeZone: TimeZone? = nil) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        formatter.timeZone = timeZone ?? .current
        return formatter.string(from: Date())
    }
}
