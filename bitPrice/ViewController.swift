//
//  ViewController.swift
//  bitPrice
//
//  Created by Antônio Guimarães  on 04/09/17.
//  Copyright © 2017 EliteDEV. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	var timer: Timer!
	
	@IBOutlet weak var preco: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		ChecaPreco()
		timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(ChecaPreco), userInfo: nil, repeats: true)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func ChecaPreco()
	{
		let urlString = "https://poloniex.com/public?command=returnTicker"
		
		let url = URL(string: urlString)
		URLSession.shared.dataTask(with:url!) { (data, response, error) in
			if error != nil {
    print(error ?? "")
			} else {
    do {
		
		let parsedData = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
		
		let usdt_btc = parsedData["USDT_BTC"] as! [String:Any]
		
		let casted = (usdt_btc["last"] as! NSString).doubleValue
		
		//print(casted.rounded(toPlaces: 2))
		DispatchQueue.main.async(execute: {
			
		self.preco.text = String(casted.rounded(toPlaces: 2)) + " - $USD$"
		})
		
	} catch let error as NSError {
		print(error)
    }
			}
			
			}.resume()
	}
	
	
}

extension Double {
	/// Rounds the double to decimal places value
	func rounded(toPlaces places:Int) -> Double {
		let divisor = pow(10.0, Double(places))
		return (self * divisor).rounded() / divisor
	}
}

