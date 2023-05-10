//
//  EventPasswordInputView.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/6/23.
//

import UIKit

final class EventPasswordInputView : UIView {
    
    private let viewModel : EventPasswordInputViewModel
    public weak var delegate : EventPasswordInputViewDelegate?
    private var isLoading : Bool = false

    
    let label : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        label.contentMode = .scaleAspectFit
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let invalidPassword : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = .red
        label.text = "Wrong Password"
        label.isHidden = true
        label.contentMode = .scaleAspectFit
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let input : UITextField = {
        let input = UITextField()
        input.placeholder = "Password"
        input.translatesAutoresizingMaskIntoConstraints = false
        input.keyboardType = .twitter
        return input
    }()
    
    let submitBtn : UIButton = {
        let submitBtn = UIButton(configuration: .bordered())
        submitBtn.translatesAutoresizingMaskIntoConstraints = false
        submitBtn.frame = CGRect(x: 150, y: 150, width: 150, height: 150)
        submitBtn.addTarget(self, action: #selector(submit),for: .touchDown)
        submitBtn.setTitle("Join", for: .normal)
        return submitBtn
    }()
    
    let container : UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        return container
    }()
    
    init(frame : CGRect, viewModel : EventPasswordInputViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        label.text = viewModel.event.name
        addSubviews(container)
        container.addSubviews(label, input, invalidPassword, submitBtn)
        addConstraints()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
    }
    
    @objc
    private func submit(_ sender:UIButton!) {
        isLoading = false
        sendPassword()
    }
    
    @objc
    private func hideKeyboard(_ sender:UIButton!) {
        input.endEditing(true)
    }
    
    private func sendPassword() {
        print("Call to submit")
        if isLoading {
            print("Loading")
            return
        }
        isLoading = true
        guard let password = input.text else {return}
        viewModel.submitPassword(password: password) {[weak self] result in
            switch result {
            case .success(let resp):
                if resp.message{
                    DispatchQueue.main.async {
                        guard let event = self?.viewModel.event else {return}
                        self?.delegate?.pushIntoMessages(event: event)
                        self?.delegate?.setAlreadyMemberToTrue()
                    }
                    //want to redirect to event page
                } else {
                    DispatchQueue.main.async {
                        self?.invalidPassword.isHidden = false
                    }
                    print("Not able to log in")
                }
            case .failure(let err):
                print(String(describing: err))
                                            
        }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareForReuse() {
        label.text = nil
        input.text = nil
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.centerYAnchor.constraint(equalTo: centerYAnchor),
            container.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.60),
            container.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.40),
            label.topAnchor.constraint(equalTo: container.topAnchor),
            input.widthAnchor.constraint(equalTo: container.widthAnchor),
            input.heightAnchor.constraint(equalToConstant: 40),
            input.topAnchor.constraint(equalTo: label.bottomAnchor),
            input.leftAnchor.constraint(equalTo: container.leftAnchor),
            input.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.70),
            input.rightAnchor.constraint(equalTo: container.rightAnchor),
            invalidPassword.topAnchor.constraint(equalTo: input.bottomAnchor),
            invalidPassword.rightAnchor.constraint(equalTo: container.rightAnchor),
            invalidPassword.leftAnchor.constraint(equalTo: container.leftAnchor),
            invalidPassword.heightAnchor.constraint(equalToConstant: 30),

            submitBtn.topAnchor.constraint(equalTo: invalidPassword.bottomAnchor),
            submitBtn.leftAnchor.constraint(equalTo: container.leftAnchor),
            submitBtn.rightAnchor.constraint(equalTo: container.rightAnchor),

//            submitBtn.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            submitBtn.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.40),
        ])
    }
    
}


//MARK: - Protocol
protocol EventPasswordInputViewDelegate : AnyObject {
    func pushIntoMessages(event : Event)
    func setAlreadyMemberToTrue()
}

