//
//  CounterViewController.swift
//  ECE564project
//
//  Created by 杨越 on 11/9/20.
//  Copyright © 2020 杨越. All rights reserved.
//

import UIKit

class CounterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var circlePath: UIBezierPath!
    let shapeLayer = CAShapeLayer()
    var pulsatingLayer = CAShapeLayer()
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var startImage: UIImageView!
    var selectPickerIndex = 0
    
    var timer = Timer()
    var time:Int = 0
    var timerMode: TimerMode = .initial
    let availableMinutes = Array(1...60)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCirclePath()
        createBackgroundLayer()
        createShapeLayer()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func controlTimer(_ sender: Any) {
        if(timerMode == .initial){
            if(time != 0){
                startTimer()
                timerMode = .running
                startButton.setTitle("pause", for: .normal)
                pickerView.isHidden = true
            }
        }
        else{
            timer.invalidate()
            timerMode = .initial
            startButton.setTitle("start", for: .normal)
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        timer.invalidate()
        timerMode = .initial
        time = 0
        timeLabel.text = "00:00"
        startButton.setTitle("start", for: .normal)
        pickerView.isHidden = false
    }
    
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer(){
        if(time == 0){
            timer.invalidate()
            time = 0
            timerMode = .initial
            timeLabel.text = "0"
            startButton.setTitle("start", for: .normal)
        }
        time -= 1
        timeLabel.text = formatTime(time: time)
    }
    
    func formatTime(time: Int)->String{
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    func setCirclePath(){
        circlePath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
    }
    
    func createBackgroundLayer(){
        let backgroundLayer = CAShapeLayer()
        
        backgroundLayer.path = circlePath.cgPath
        backgroundLayer.strokeColor = UIColor.trackStrokeColor.cgColor
        backgroundLayer.lineWidth = 20
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.lineCap = .round
        backgroundLayer.position = view.center
        
        view.layer.addSublayer(backgroundLayer)
    }
        
    func createShapeLayer() {
        shapeLayer.path = circlePath.cgPath
        shapeLayer.strokeColor = UIColor.outlineStrokeColor.cgColor
        shapeLayer.lineWidth = 20
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = .round
        shapeLayer.position = view.center
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi/2, 0, 0, 1)
        
        shapeLayer.strokeEnd = 0
        
        view.layer.addSublayer(shapeLayer)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(process)))
    }
    
    func beginCounter(){
        print("trying to count down")
        shapeLayer.strokeEnd = 0

    }
    
    @objc private func process(){
        print("try to animate stroke")
        beginCounter()
        animateCircle()
    }
    
    func animateCircle() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 2
        
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

     // MARK: - set up pickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        let res: String = "\(availableMinutes[row]) min"
//        time = availableMinutes[row] * 60
//        return res
//    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let res: String = "\(availableMinutes[row]) min"
        time = availableMinutes[row] * 60
        return NSAttributedString(string: res, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return availableMinutes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        timeLabel.text = formatTime(time: availableMinutes[row] * 60)
    }
}
