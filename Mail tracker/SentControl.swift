//
//  SentControl.swift
//  Mail tracker
//
//  Created by Antonia Schmidt-Lademann on 06/11/2016.
//  Copyright © 2016 Antonia Schmidt-Lademann. All rights reserved.
//

import UIKit

@IBDesignable class SentControl: UIView {
    
    // MARK: Properties
    @IBInspectable var messageStatus:Int = 0 {
        didSet {
            setupButtons()
        }
    }
    var buttons = [UIButton]()
    
    // MARK: Initialisation
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButtons()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    
    
    private func setupButtons(){
        let sentImage = UIImage(named: "sent")
        let receivedImage = UIImage(named: "received")
        
        for button in buttons {
            willRemoveSubview(button)
            button.removeFromSuperview()
        }
    
        buttons.removeAll()
        
        let buttonSize = Int(frame.size.height)
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize))
        //button.backgroundColor = UIColor.red
        button.setImage(sentImage, for: .normal)
        button.setImage(receivedImage, for: .highlighted)
        button.addTarget(self, action: #selector(SentControl.messageButtonTapped(_:)), for: .touchDown)
        buttons += [button]
        if(messageStatus == 1){
            addSubview(button)
        }
        
        let buttonG = UIButton()          //frame: CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize))
        //buttonG.backgroundColor = UIColor.green
        buttonG.setImage(receivedImage, for: .normal)
        buttonG.setImage(sentImage, for: .highlighted)
        buttonG.addTarget(self, action: #selector(SentControl.messageButtonTapped(_:)), for: .touchDown)
        buttons += [buttonG]
        if(messageStatus == 0){
            addSubview(buttonG)
            buttonG.frame = CGRect(x:(buttonSize + 5), y:0, width:buttonSize, height:buttonSize)
        }
        
        

    }
    
    override var intrinsicContentSize : CGSize {
        let buttonSize = Int(frame.size.height)
        let width = buttonSize * 2 + 5
        return CGSize(width: width, height: buttonSize)
    }
    
    // MARK: Button Action
    func messageButtonTapped(_ button: UIButton){
        guard let index = buttons.index(of: button) else {
            fatalError("The button \(button) is not in the buttons array: \(buttons)")
        }
        messageStatus = index
    }

}
