//
//  EventCreateView.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/15/23.
//

import UIKit

final class EventCreateView : UIView {
    private let viewModel : EventCreateViewModel
    private let scrollView : UIScrollView = {
        let sv = UIScrollView(frame: UIScreen.main.bounds)
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.isPagingEnabled = true
       return sv
    }()
    
    private let submitBtn : UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(submit), for: .touchDown)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .red
        return btn
    }()
    
    private let nameTextField : UITextField = {
        let field = UITextField()
        field.placeholder = "Event Name"
        field.minimumFontSize = 100
        field.borderStyle = .roundedRect
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let desciptionTextField : UITextField = {
        let field = UITextField()
        field.placeholder = "Desc"
        field.borderStyle = .roundedRect
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let publicCheck : UISwitch = {
        let field = UISwitch()
        field.preferredStyle = .sliding
        field.translatesAutoresizingMaskIntoConstraints = false
        field.setOn(true, animated: true)
        field.offImage = UIImage(systemName: "lock.open")
        field.onImage = UIImage(systemName: "lock")
        return field
    }()
    
    private let codeTextField : UITextField = {
        let field = UITextField()
        field.placeholder = "Code"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let duration : UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Duration"
        field.keyboardType = .numberPad
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
        fields.addSubviews(nameTextField, desciptionTextField, publicCheck,codeTextField, duration, submitBtn)
        scrollView.addSubviews(mapCollectionView, fields)
        addSubviews(scrollView)
        addConstraint()
    }
    
    private func addConstraint() {
        guard let mapCollectionView = mapCollectionView else {return}
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: rightAnchor),
//            scrollView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height),
//            scrollView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            fields.topAnchor.constraint(equalTo: scrollView.topAnchor),
            fields.leftAnchor.constraint(equalTo: leftAnchor),
            fields.rightAnchor.constraint(equalTo: rightAnchor),
            fields.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.80),
            
            nameTextField.topAnchor.constraint(equalTo: fields.topAnchor, constant: 0),
            nameTextField.leadingAnchor.constraint(equalTo: fields.leadingAnchor, constant: 0),
            nameTextField.trailingAnchor.constraint(equalTo: fields.trailingAnchor, constant: 0),
//            nameTextField.widthAnchor.constraint(equalTo: fieldView.widthAnchor, multiplier: 0.65, constant : 20),

            
            desciptionTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 0),
            desciptionTextField.leadingAnchor.constraint(equalTo: fields.leadingAnchor, constant: 0),
            desciptionTextField.trailingAnchor.constraint(equalTo: fields.trailingAnchor, constant: 0),
//            desciptionTextField.heightAnchor.constraint(equalTo: fieldView.heightAnchor, multiplier: 0.30),
            
            publicCheck.topAnchor.constraint(equalTo: desciptionTextField.bottomAnchor, constant: 0),
            publicCheck.leftAnchor.constraint(equalTo: fields.leftAnchor, constant: 0),
            publicCheck.rightAnchor.constraint(equalTo: fields.rightAnchor, constant: 0),

            
            codeTextField.topAnchor.constraint(equalTo: publicCheck.bottomAnchor, constant: 0),
            codeTextField.trailingAnchor.constraint(equalTo: fields.trailingAnchor, constant: 0),
            codeTextField.leadingAnchor.constraint(equalTo: fields.leadingAnchor, constant: 0),
            
            duration.topAnchor.constraint(equalTo: codeTextField.bottomAnchor, constant: 0),
            
            submitBtn.topAnchor.constraint(equalTo: duration.bottomAnchor, constant: 0),
            submitBtn.trailingAnchor.constraint(equalTo: fields.trailingAnchor, constant: 0),
            submitBtn.leadingAnchor.constraint(equalTo: fields.leadingAnchor, constant: 0),
            
            mapCollectionView.topAnchor.constraint(equalTo: fields.bottomAnchor),
            mapCollectionView.leftAnchor.constraint(equalTo: leftAnchor),
            mapCollectionView.rightAnchor.constraint(equalTo: rightAnchor),
            mapCollectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            mapCollectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.70)
        ])
    }
    
    @objc
    private func submit() {
//        var isPublic = true
//        var code = ""
//        if publicCheck.value == 1 {
//            isPublic = false
//            guard let code = codeTextField.text else { return }
//        }
//        guard let duration = duration.text else {return}
//        guard let name = nameTextField.text, let duration = Int(duration), let desc = desciptionTextField.text else {return}
//        let event = EventPost(name: name, is_public: isPublic, code: code, description: desc, duration: duration, location_info: <#T##LocationInfo#>)
        
        
    }
}


extension EventCreateView : UIScrollViewDelegate {
 
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let currentPos = scrollView.contentOffset
        if currentPos.y < 100 && currentPos.y != 0 {
            scrollView.setContentOffset(CGPoint(x: 0, y: UIScreen.main.bounds.height), animated: true)
        } else {
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
}
