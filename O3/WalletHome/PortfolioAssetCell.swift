//
//  PortfolioAssetCell.swift
//  O3
//
//  Created by Andrei Terentiev on 2/6/18.
//  Copyright © 2018 drei. All rights reserved.
//

import Foundation
import UIKit

class PortfolioAssetCell: ThemedTableCell {
    @IBOutlet weak var assetTitleLabel: UILabel!
    @IBOutlet weak var assetAmountLabel: UILabel!
    @IBOutlet weak var assetFiatPriceLabel: UILabel!
    @IBOutlet weak var assetFiatAmountLabel: UILabel!
    @IBOutlet weak var assetPercentChangeLabel: UILabel!

    struct Data {
        var assetName: String
        var amount: Double
        var referenceCurrency: Currency
        var latestPrice: PriceData
        var firstPrice: PriceData
    }

    override func awakeFromNib() {
        titleLabels = [assetTitleLabel, assetAmountLabel, assetFiatAmountLabel]
        subtitleLabels = [assetFiatPriceLabel]
        super.awakeFromNib()
    }

    var data: PortfolioAssetCell.Data? {
        didSet {
            applyTheme()
            guard let assetName = data?.assetName,
                let amount = data?.amount,
                let referenceCurrency = data?.referenceCurrency,
                let latestPrice = data?.latestPrice,
                let firstPrice = data?.firstPrice else {
                    fatalError("undefined data set")
            }
            assetTitleLabel.text = assetName
            assetAmountLabel.text = amount.description

            let precision = referenceCurrency == .btc ? Precision.btc : Precision.usd
            let referencePrice = referenceCurrency == .btc ? latestPrice.averageBTC : latestPrice.averageUSD
            let referenceFirstPrice = referenceCurrency == .btc ? firstPrice.averageBTC : firstPrice.averageUSD

            assetFiatPriceLabel.text = referencePrice.string(precision)
            assetFiatAmountLabel.text = (referencePrice * Double(amount)).string(precision)
            //format USD properly
            if referenceCurrency == .usd {
                assetFiatPriceLabel.text = USD(amount: Float(referencePrice)).formattedString()
            }

            assetPercentChangeLabel.text = String.percentChangeStringShort(latestPrice: latestPrice, previousPrice: firstPrice,
                                                                           referenceCurrency: referenceCurrency)
            assetPercentChangeLabel.textColor = referencePrice >= referenceFirstPrice ? UserDefaultsManager.theme.positiveGainColor : UserDefaultsManager.theme.negativeLossColor
        }
    }
}
