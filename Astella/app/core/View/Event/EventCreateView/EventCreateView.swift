//
//  EventCreateView.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/15/23.
//

import UIKit

final class EventCreateView : UIView {
    private let viewModel : EventCreateViewModel
    public weak var delegate : EventCreateViewDelegate?
    private let scrollView : UIScrollView = {
        let sv = UIScrollView(frame: UIScreen.main.bounds)
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.isPagingEnabled = true
       return sv
    }()
    
    private let submitBtn : UIButton = {
        let btn = UIButton()
        btn.configuration?.title = "Create Event"
        btn.addTarget(self, action: #selector(submit), for: .touchDown)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .green
        btn.setTitle("create", for: .normal)
        btn.alpha = 0.6
        btn.layer.borderWidth = 2
        
        return btn
    }()
    
    private let nameLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Event Name"
        return label
    }()
    
    private let descLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Description"
        return label
    }()
    
    private let codeLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Code"
        label.isHidden = true
        return label
    }()
    
    private let durationLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Duration"
        return label
    }()
    
    private let publicLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Public"
        return label
    }()
    
    private let nameTextField : UITextField = {
        let field = UITextField()
        field.layer.borderColor = UIColor.gray.cgColor
        field.layer.borderWidth = 1
        field.layer.cornerRadius = 5
        field.translatesAutoresizingMaskIntoConstraints = false
        field.keyboardType = .twitter
        return field
    }()
    
    private let desciptionTextField : UITextView = {
        let field = UITextView()
        field.layer.borderWidth = 1
        field.translatesAutoresizingMaskIntoConstraints = false
        field.layer.cornerRadius = 10
        field.font = .systemFont(ofSize: 12)
        return field
    }()
    
    private let publicCheck : UISwitch = {
        let field = UISwitch()
        field.preferredStyle = .sliding
        field.translatesAutoresizingMaskIntoConstraints = false
        field.setOn(true, animated: true)
        field.addTarget(self, action: #selector(publicSwitch), for: .valueChanged)
        field.offImage = UIImage(systemName: "lock.open")
        field.onImage = UIImage(systemName: "lock")
        return field
    }()
    
    private let codeTextField : UITextField = {
        let field = UITextField()
        field.layer.borderColor = UIColor.gray.cgColor
        field.layer.borderWidth = 1
        field.layer.cornerRadius = 5
        field.isHidden = true
        field.translatesAutoresizingMaskIntoConstraints = false
        field.keyboardType = .twitter
        return field
    }()
    
    private let errorCodeLabel : UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .black)
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.text = "Need code for private event"
        return label
    }()
    
    private let errorDurationLabel : UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .black)
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.text = "Duration needs to be a number"
        return label
    }()
    
    private let duration : UITextField = {
        let field = UITextField()
        field.layer.borderColor = UIColor.gray.cgColor
        field.layer.borderWidth = 1
        field.layer.cornerRadius = 5
        field.translatesAutoresizingMaskIntoConstraints = false
        field.keyboardType = .twitter
        return field
    }()
    
    private let fields : UIView = {
       let field = UIView()
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    public var mapCollectionView : UICollectionView?
    
    required init?(coder : NSCoder) {
        fatalError("Not Supported")
    }
    
    init(frame: CGRect, viewModel : EventCreateViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        self.scrollView.delegate = self
        viewModel.setupSections()
        let mapCollectionView = viewModel.createCollectionView()
        self.mapCollectionView = mapCollectionView
        translatesAutoresizingMaskIntoConstraints = false
        fields.addSubviews(nameLabel, descLabel, codeLabel, durationLabel, nameTextField, desciptionTextField, publicCheck,codeTextField, duration, submitBtn, publicLabel, errorCodeLabel, errorDurationLabel)
        scrollView.addSubviews(mapCollectionView, fields)
        addSubviews(scrollView)
        addConstraint()
    }
    
    //MARK: - Constraints
    private func addConstraint() {
        guard let mapCollectionView = mapCollectionView else {return}
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            fields.topAnchor.constraint(equalTo: scrollView.topAnchor),
            fields.leftAnchor.constraint(equalTo: leftAnchor),
            fields.rightAnchor.constraint(equalTo: rightAnchor),
            fields.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.80),
            
            nameLabel.topAnchor.constraint(equalTo: fields.topAnchor, constant: 20),
            nameLabel.leftAnchor.constraint(equalTo: fields.leftAnchor, constant: 10),
            nameLabel.rightAnchor.constraint(equalTo: fields.rightAnchor),
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            nameTextField.leadingAnchor.constraint(equalTo: fields.leadingAnchor, constant: 10),
            nameTextField.trailingAnchor.constraint(equalTo: fields.trailingAnchor, constant: -10),
            nameTextField.heightAnchor.constraint(equalTo: fields.heightAnchor, multiplier: 0.04),

            descLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10),
            descLabel.leftAnchor.constraint(equalTo: fields.leftAnchor, constant: 10),
            descLabel.rightAnchor.constraint(equalTo: fields.rightAnchor),
            desciptionTextField.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 5),
            desciptionTextField.leadingAnchor.constraint(equalTo: fields.leadingAnchor, constant: 10),
            desciptionTextField.trailingAnchor.constraint(equalTo: fields.trailingAnchor, constant: -10),
            desciptionTextField.heightAnchor.constraint(equalTo: fields.heightAnchor, multiplier: 0.25),
            
            publicLabel.topAnchor.constraint(equalTo: desciptionTextField.bottomAnchor,constant: 10),
            publicLabel.bottomAnchor.constraint(equalTo: codeLabel.topAnchor),
            publicLabel.leftAnchor.constraint(equalTo: fields.leftAnchor, constant: 10),
            
            publicCheck.topAnchor.constraint(equalTo: desciptionTextField.bottomAnchor, constant: 10),
            publicCheck.rightAnchor.constraint(equalTo: fields.rightAnchor, constant: -10),

            codeLabel.topAnchor.constraint(equalTo: publicCheck.bottomAnchor, constant: 10),
            codeLabel.leftAnchor.constraint(equalTo: fields.leftAnchor, constant: 10),
            codeLabel.rightAnchor.constraint(equalTo: fields.rightAnchor),
            codeTextField.topAnchor.constraint(equalTo: codeLabel.bottomAnchor, constant: 5),
            codeTextField.trailingAnchor.constraint(equalTo: fields.trailingAnchor, constant: -10),
            codeTextField.leadingAnchor.constraint(equalTo: fields.leadingAnchor, constant: 10),
            codeTextField.heightAnchor.constraint(equalTo: fields.heightAnchor, multiplier: 0.04),

            errorCodeLabel.topAnchor.constraint(equalTo: codeTextField.bottomAnchor, constant: 5),
            errorCodeLabel.leftAnchor.constraint(equalTo: fields.leftAnchor, constant: 10),
            
            
            durationLabel.topAnchor.constraint(equalTo: errorCodeLabel.bottomAnchor,constant: 10),
            durationLabel.leftAnchor.constraint(equalTo: fields.leftAnchor, constant: 10),
            durationLabel.rightAnchor.constraint(equalTo: fields.rightAnchor),
            duration.topAnchor.constraint(equalTo: durationLabel.bottomAnchor, constant: 5),
            duration.leftAnchor.constraint(equalTo: fields.leftAnchor, constant: 10),
            duration.heightAnchor.constraint(equalTo: fields.heightAnchor, multiplier: 0.04),
            duration.widthAnchor.constraint(equalTo: fields.widthAnchor, multiplier: 0.30),
            errorDurationLabel.topAnchor.constraint(equalTo: duration.bottomAnchor, constant: 5),
            errorDurationLabel.leftAnchor.constraint(equalTo: fields.leftAnchor),
            
            submitBtn.topAnchor.constraint(equalTo: duration.bottomAnchor, constant: 50),
            submitBtn.trailingAnchor.constraint(equalTo: fields.trailingAnchor, constant: -10),
            submitBtn.leadingAnchor.constraint(equalTo: fields.leadingAnchor, constant: 10),
            
            mapCollectionView.topAnchor.constraint(equalTo: fields.bottomAnchor),
            mapCollectionView.leftAnchor.constraint(equalTo: leftAnchor),
            mapCollectionView.rightAnchor.constraint(equalTo: rightAnchor),
            mapCollectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            mapCollectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.70)
        ])
    }
    
    //MARK: - Create Event
    @objc
    private func submit(sender : UIButton) {
        var isPublic = true
        let code = ""
        renderErrorLabels()
        guard let duration = duration.text, let duration = Int(duration) else {return}
        guard let name = nameTextField.text, let desc = desciptionTextField.text else {return}
        if !publicCheck.isOn {
            isPublic = false
            guard let code = codeTextField.text else {return}
            createEvent(name: name, desc: desc, isPublic: isPublic, code: code, duration: duration)
        } else {
            createEvent(name: name, desc: desc, isPublic: isPublic, code: code, duration: duration)
        }
    }
    
    func renderErrorLabels() {
        renderDurationErrorLabels()
        renderCodeErrorLabel()
    }
    
    func renderDurationErrorLabels() {
        guard let duration = duration.text, let _ = Int(duration) else {
            errorDurationLabel.isHidden = false
            return
        }
    }
    
    func renderCodeErrorLabel() {
        if !publicCheck.isOn {
            guard let code = codeTextField.text, code != "" else {
                errorCodeLabel.isHidden = false
                return
            }
        }
    }
    
    //MARK: - Create Event + Add User
    func createEvent(name : String, desc : String, isPublic : Bool, code : String, duration : Int) {
        viewModel.postCreateEvent(name: name, desc: desc, isPublic: isPublic, code: code, duration: duration) {[weak self] result in
            switch result {
            case .success(let data):
                self?.addUserToEvent(data: data, code: code)
            case .failure(let err):
                print(String(describing: err))
            }
        }
    }
    
    func addUserToEvent(data : EventListResponse, code : String) {
        viewModel.addUserToEvent(eventId: data.data[0].id, code: code) {[weak self] result in
        switch result {
        case .success(let resp):
            if resp.message {
                DispatchQueue.main.async {
                    self?.createSuccessful(result: data)
                }
            }
        case .failure(let err):
            print(String(describing: err))
        }
    }
    }
    
    func createSuccessful(result : EventListResponse) {
        nameTextField.text = nil
        desciptionTextField.text = nil
        codeTextField.text = nil
        duration.text = nil
        errorCodeLabel.isHidden = true
        errorDurationLabel.isHidden = true
        delegate?.pushToMessageViewController(event: result.data[0])
    }
    
    
    @objc
    private func publicSwitch(_ : UISlider) {
        if publicCheck.isOn {
            codeLabel.isHidden = true
            codeTextField.isHidden = true
            errorCodeLabel.isHidden = true
        } else {
            codeLabel.isHidden = false
            codeTextField.isHidden = false
        }
    }

}

//MARK: - Delegate
extension EventCreateView : UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let currentPos = scrollView.contentOffset
        if currentPos.y < 100 && currentPos.y != 0 {
            scrollView.setContentOffset(CGPoint(x: 0, y: UIScreen.main.bounds.height), animated: true)
        } else {
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
}

protocol EventCreateViewDelegate : AnyObject {
    func pushToMessageViewController(event : Event)
}

