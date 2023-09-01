import UIKit
import Then
import SnapKit

final class HomeViewController: UIViewController {
    
    // MARK: - Properties

    private let introLabelImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "clickMe")
    }
    
    private let homeImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 150
        $0.clipsToBounds = true
        $0.image = UIImage(named: "placeholder")
    }
    
    private lazy var listButton = UIButton().then {
        $0.backgroundColor = UIColor.clear
        $0.layer.cornerRadius = 100
        $0.addTarget(self, action: #selector(listButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadImage(from: "https://avatars.githubusercontent.com/u/117909631?v=4&h=150&w=150")
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubviews(introLabelImageView, homeImageView, listButton)
        
        introLabelImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(homeImageView.snp.top).offset(-40)
            $0.width.equalTo(200)
            $0.height.equalTo(100)
        }
        
        homeImageView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaInsets).inset(250)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(300)
        }
        
        listButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaInsets).inset(200)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(200)
        }
    }
    
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.homeImageView.image = image
                }
            }
        }.resume()
    }
    
    // MARK: - Action
    
    @objc private func listButtonTapped() {
        let todoListAction = UIAction(title: "Todo List", image: UIImage(systemName: "list.bullet"), identifier: nil, discoverabilityTitle: nil) { [weak self] _ in
            guard let self = self else { return }
            let todoListVC = TodoListViewController()
            self.navigationController?.pushViewController(todoListVC, animated: true)
        }
        
        let todoCompleteListAction = UIAction(title: "완료한 Todo", image: UIImage(systemName: "checkmark.square"), identifier: nil, discoverabilityTitle: nil) { [weak self] _ in
            guard let self = self else { return }
            let todoCompleteVC = TodoCompleteViewController()
            self.navigationController?.pushViewController(todoCompleteVC, animated: true)
        }
        
        let randomCatAction = UIAction(title: "고양이 사진 보러가기", image: UIImage(systemName: "photo"), identifier: nil, discoverabilityTitle: nil) { [weak self] _ in
            guard let self = self else { return }
            let petVC = PetViewController()
            self.navigationController?.pushViewController(petVC, animated: true)
        }
        
        let menu = UIMenu(title: "Todo List Menu", identifier: nil, options: .displayInline, children: [randomCatAction, todoCompleteListAction, todoListAction])
        listButton.menu = menu
        listButton.showsMenuAsPrimaryAction = true
    }
    
}
