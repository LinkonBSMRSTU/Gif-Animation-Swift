//
//  ViewController.swift
//  GIF-Swift
//
//  Created by Fazle Rabbi Linkon on 29/06/20.
//  Copyright ©Fazle Rabbi Linkon. All rights reserved.
//

import UIKit
import ImageIO


enum CastState {
    case connected
    case disconnected
}

class ViewController: UIViewController {

    private var castState = CastState.disconnected

    @IBOutlet weak var chromecastImageView: UIImageView!

    @IBOutlet weak var connectButton: UIButton!

    let imArr = ViewController.gifImageWithName("btn_cheer")

    override func viewDidLoad() {
        super.viewDidLoad()

        setupImageViewAnimation()

    }

    func setupImageViewAnimation() {
        chromecastImageView.animationImages = imArr
        chromecastImageView.animationDuration = 1
    }

    @IBAction func onConnectButton(_ sender: Any) {
        switch castState {
        case .connected:
            disconnect()

        case .disconnected:
            connect()
        }

    }


    private func connect() {
        // Disables the button to avoid user interaction when the animation is running
        connectButton.isEnabled = false

        chromecastImageView.startAnimating()

        // Simulates a connection with a delay of 1 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.chromecastImageView.stopAnimating()

            // Enables the button to allow user interaction
            self.connectButton.isEnabled = true
            // Updates UI
            self.toggleCastState()
        }
    }

    private func disconnect() {
        // Updates UI
        toggleCastState()
    }


    private func toggleCastState() {
        // Updates current Chromecast state
        //castState = castState == .connected ? .disconnected : .connected

        // Updates button title
        //let buttonTitle = castState == .connected ? "Disconnect" : "Connect"
        //connectButton.setTitle(buttonTitle, for: .normal)

        // Updates `UIImageView` default image
        //let image = castState == .connected ? imArr![3] : imArr![4]
        chromecastImageView.image = imArr![3]
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    public class func gifImageWithName(_ name: String) -> [UIImage]? {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }

        return gifImageWithData(imageData)
    }

    public class func gifImageWithData(_ data: Data) -> [UIImage]? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("image doesn't exist")
            return nil
        }

        return ViewController.animatedImageWithSource(source)
    }


    class func animatedImageWithSource(_ source: CGImageSource) -> [UIImage]? {
        let count = CGImageSourceGetCount(source)
        print("Count: \(count)")
        var images = [CGImage]()

        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
        }

        print(images.count)
        var frames = [UIImage]()

        var frame: UIImage

        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frames.append(frame)
        }

        return frames
    }
}

