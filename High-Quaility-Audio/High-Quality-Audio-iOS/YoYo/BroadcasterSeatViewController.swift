//
//  MicSeatViewController.swift
//  YoYo
//
//  Created by CavanSu on 2018/6/7.
//  Copyright © 2018 CavanSu. All rights reserved.
//

import UIKit

protocol BroadcasterSeatVCDelegate: NSObjectProtocol {
    func broadcasterSeatVC(_ vc: BroadcasterSeatViewController, didSelected index: Int, seat: Seat)
}

class BroadcasterSeatViewController: UIViewController {
    @IBOutlet weak var buttonWidth: NSLayoutConstraint!
    @IBOutlet var buttonList: [SeatButton]!
    
    private var isDeviceAdapt: Bool = false {
        didSet {
            if isDeviceAdapt == true,
                (DeviceAdapt.currentType() != .classicFourPointSevenInch || DeviceAdapt.currentType() != .newFourPointSevenInch) {
                buttonWidth.constant = buttonWidth.constant * DeviceAdapt.getWidthCoefficient()
            }
        }
    }
    
    private lazy var aureolaViews: [AureolaView] = {
        var list = [AureolaView]()
        for _ in 0..<buttonList.count {
            let view = AureolaView(color: UIColor.init(hexString: "#09BDF4"))
            list.append(view)
        }
        return list
    }()
    
    private lazy var seatList = [Seat]()
    
    weak var delegate: BroadcasterSeatVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSeatList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isDeviceAdapt {
            isDeviceAdapt = true
        }
    }
    
    @IBAction func doSeatPressed(_ sender: SeatButton) {
        let index = sender.tag
        let seat = seatList[index]
        delegate?.broadcasterSeatVC(self, didSelected: index, seat: seat)
    }
}

extension BroadcasterSeatViewController {
    private func initSeatList() {
        for _ in 0..<buttonList.count {
            let item = Seat(type: .none)
            seatList.append(item)
        }
    }
    
    func updateSeat(_ seat: Seat, index: Int) {
        guard index < buttonList.count, index >= 0 else {
            return
        }
        
        seatList[index] = seat
        let button = buttonList[index]
        button.update(seat)
        
        if seat.type == .none {
            let aureola = aureolaViews[index]
            aureola.removeAnimation()
        }
    }
    
    func seat(with index: Int) -> Seat? {
        guard index < seatList.count else {
            return nil
        }
        return seatList[index]
    }
    
    func indexOfSeat(with broadcasterId: UInt) -> Int? {
        let index = seatList.firstIndex { (seat) -> Bool in
            return seat.broadcaster?.info.id == broadcasterId
        }
        return index
    }
    
    func firstIndexOfBlankSeat() -> Int? {
        let index = seatList.firstIndex { (seat) -> Bool in
            return seat.type == .none
        }
        return index
    }
    
    func startAureolaing(at index: Int) {
        let aureola = aureolaViews[index]
        let button = buttonList[index]
        aureola.startLayerAnimation(aboveView: button, layerWidth: 2)
    }
}
