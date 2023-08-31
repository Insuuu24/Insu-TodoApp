import UIKit
import Then
import SnapKit

class HomeViewController: UIViewController {
    
    // MARK: - Properties

    private let homeImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 150
        $0.clipsToBounds = true
        $0.image = UIImage(named: "placeholder")
    }
    
    private lazy var listButton = UIButton().then {
        $0.backgroundColor = .systemGray5
        $0.setTitle("List", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        $0.layer.cornerRadius = 10
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
        view.addSubviews(homeImageView, listButton)
        
        homeImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaInsets).offset(200)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(300)
        }
        
        listButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(homeImageView.snp.bottom).offset(200)
            $0.width.equalTo(300)
            $0.height.equalTo(65)
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
        
        let menu = UIMenu(title: "Todo List Menu", identifier: nil, options: .displayInline, children: [todoCompleteListAction, todoListAction])
        listButton.menu = menu
        listButton.showsMenuAsPrimaryAction = true
    }
    
}
