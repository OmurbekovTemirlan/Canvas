import UIKit

class ViewController: UIViewController {

    private lazy var button: UIButton = {
        let view = UIButton(type: .system)
        
        view.setTitle("Show Canvas", for: .normal)
        view.addTarget(self, action: #selector(showEditor), for: .touchUpInside)

        view.layout.size.equal(to: .init(width: 200, height: 50))
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    
    private func setupViews() {
        view.addSubview(button)
        button.layout.center.equal(to: view)
    }
    
    @objc private func showEditor() {
        let controller = EditorController()
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true)
    }
}

