//
//  MainViewController.swift
//  CanadianCovid19
//
//  Created by Tai Chin Huang on 2021/9/26.
//

import UIKit
import SDWebImage
import Charts

class MainViewController: UIViewController, Covid19ModelDelegate, HistoricalModelDelegate {
    
//    var todayCasesView: UIView = {
//        let todayCasesView = UIView()
//        todayCasesView.translatesAutoresizingMaskIntoConstraints = false
//        todayCasesView.topAnchor.constraint(equalTo: view, constant: 20).isActive = true
//        todayCasesView.leadingAnchor.constraint(equalTo:  UIView().leadingAnchor, constant: 20).isActive = true
//
//        let viewWidth = ((UIView().frame.size.width) - 60) / 2
//        todayCasesView.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
////        view.frame.size.width = ((view.frame.size.width) - 60) / 2
//        todayCasesView.heightAnchor.constraint(equalToConstant: viewWidth).isActive = true
//
//        todayCasesView.backgroundColor = .red
//        return todayCasesView
//    }()
    
    @IBOutlet weak var todayCasesView: ViewStyle!
    @IBOutlet weak var totalCasesView: ViewStyle!
    @IBOutlet weak var todayDeathsView: ViewStyle!
    @IBOutlet weak var totalDeathsView: ViewStyle!
    
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var caseTodayLabel: UILabel!
    @IBOutlet weak var caseTotalLabel: UILabel!
    @IBOutlet weak var deathTodayLabel: UILabel!
    @IBOutlet weak var deathTotalLabel: UILabel!
    @IBOutlet weak var lineChartView: LineChartView!
    
    var covidModel = Covid19Model()
    var historicalModel = HistoricalModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set navigation bar title to large
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "COVID-19"
        // add a right navigation bar button item
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchCountry))
        
//        view.addSubview(todayCasesView)
        setGradientBackground()
        viewStyle(lineChartView)
        
        flagImageView.isHidden = true
        countryLabel.isHidden = true
        
        covidModel.deldgate = self
        historicalModel.delegate = self
        
        lineChartView.backgroundColor = .white
    }
    // 建立漸層背景
    func setGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
//            UIColor(red: 255/255, green: 107/255, blue: 107/255, alpha: 1.0).cgColor,
//            UIColor(red: 72/255, green: 219/255, blue: 251/255, alpha: 1.0).cgColor
            UIColor(red: 227/255, green: 253/255, blue: 245/255, alpha: 1).cgColor,
            UIColor(red: 255/255, green: 230/255, blue: 250/255, alpha: 1).cgColor
        ]
//        gradientLayer.startPoint = CGPoint(x: 0.8, y: 0)
//        gradientLayer.endPoint = CGPoint(x: 0.2, y: 1)
        gradientLayer.startPoint = CGPoint(x: 0.3, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.7, y: 1)
        gradientLayer.locations = [0, 0.8]
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    // 搜尋按鍵
    @objc func searchCountry() {
        let alertController = UIAlertController(title: "Start search", message: "please enter a country", preferredStyle: .alert)
        alertController.addTextField()
        // 按下搜尋action的時候，將country回傳到model裡面讓他去抓資料並顯示在UI上
        let searchAction = UIAlertAction(title: "Search", style: .default) { [weak self, weak alertController] _ in
            guard let country = alertController?.textFields?.first!.text else { return }
            self!.covidModel.fetchData(country)
            self!.historicalModel.fetchData(country)
        }
        alertController.addAction(searchAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func viewStyle(_ view: UIView) {
        view.layer.cornerRadius = 10
        view.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.6
        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
    }
    
//    func setConstraint() {
//
//    }
    // MARK: - Covid19ModelDelegate
    func covid19DataRetrieved(_ caseData: Covid19Data) {
        todayCasesView.alpha = 0
        totalCasesView.alpha = 0
        todayDeathsView.alpha = 0
        totalDeathsView.alpha = 0
        
        countryLabel.text = String(caseData.country)
        countryLabel.isHidden = false
        flagImageView.sd_setImage(with: URL(string: caseData.countryInfo.flag!))
        flagImageView.isHidden = false
        caseTodayLabel.text = String(caseData.todayCases)
        caseTotalLabel.text = String(caseData.cases)
        deathTodayLabel.text = String(caseData.todayDeaths)
        deathTotalLabel.text = String(caseData.deaths)
        
        UIView.animate(withDuration: 1, delay: 0.2, options: []) {
//            Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
//            }
            self.todayCasesView.alpha = 1
            self.totalCasesView.alpha = 1
            self.todayDeathsView.alpha = 1
            self.totalDeathsView.alpha = 1
        }
    }
    // MARK: - HistoricalModelDelegate
    func turnGraph(_ newCases: NewCase) {
        // 存入資料用的，這裡是將新增個案存入y軸，x軸則代表天數
        var entries = [ChartDataEntry]()
        for i in 0..<newCases.newCase.count {
            let value = ChartDataEntry(x: Double(i+1), y: Double(newCases.newCase[i]))
            entries.append(value)
        }
        // 設定chart外觀參數，大小顏色...
        let set = LineChartDataSet(entries: entries, label: "Last 7 days")
        set.colors = [NSUIColor(_colorLiteralRed: 255/255, green: 107/255, blue: 107/255, alpha: 1)]
        set.drawCirclesEnabled = false
        set.mode = .cubicBezier
        set.lineWidth = 2
        //設定gradient參數
        let gradientColors = [
            NSUIColor.systemRed.cgColor,
            NSUIColor(red: 255/255, green: 230/255, blue: 250/255, alpha: 1).cgColor
        ] as CFArray
        let location: [CGFloat] = [1, 0]
        guard let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: location) else {
            fatalError("Gradient create fail")
        }
        set.fill = Fill.fillWithLinearGradient(gradient, angle: 90)
        // you need to add this .drawFilledEnabled in order to add your gradient
        set.drawFilledEnabled = true
        
        let data = LineChartData(dataSet: set)
        // here to customize your legend
        let legend = lineChartView.legend
        legend.horizontalAlignment = .center
        legend.verticalAlignment = .bottom
        legend.orientation = .horizontal
        // last, add your data to the chart!
        lineChartView.data = data
        // remove some default setting
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.rightAxis.enabled = false
        // add animation to the line chart!
        lineChartView.animate(xAxisDuration: 1)
    }
}
