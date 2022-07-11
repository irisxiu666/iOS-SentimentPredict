//
//  ViewController.swift
//  sentimentPredict
//
//  Created by Admin on 6/24/22.
//

import UIKit
import CoreML
import SwiftyJSON
import SwifteriOS


class ViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!    
    @IBOutlet weak var sentimentLabel: UILabel!
    
    let sentimentClassifir = twitterTraining()
    let tweetCount = 100
    
    let swifter = Swifter(consumerKey: "m8lSuW86BuwjlJ38QRkuFG9hh", consumerSecret: "CZNb9ou7bGL11rilwNzed77HfJORcx4Qr78j8Hi1mZXKcWvhKA")

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func makePredict(_ sender: UIButton) {
        fetchTweets()
    }
    
    
    func fetchTweets(){
        if let searchText = textField.text{
                    
        //using: search tweets containing @apple,success and failuer: whether query sucess,repuired.tweetMode:.extended:tweets的内容不会被截断
            swifter.searchTweet(using: searchText,lang: "en", count: tweetCount, tweetMode:.extended, success: {(results,metadata) in
            
            var tweets = [twitterTrainingInput]()
            for i in 0..<100{
                if let tweet = results[i]["full_text"].string{
                    // convert tweet to twitterTrainingInput type
                    print("tweet: \(tweet)")
                    let tweetForClassification = twitterTrainingInput(text:tweet)
                    tweets.append(tweetForClassification)
                   
                }
            
            }
            self.predictionResult(with: tweets)
            
        }) {(error) in
            print("There is an error in requesting API\(error)")
        }
                
        }
    }
    
        func predictionResult(with tweets: [twitterTrainingInput]){
            do{
                let predictions = try self.sentimentClassifir.predictions(inputs: tweets)
                
                var sentimentScore = 0
                
                for prediction in predictions{
                    print("prediction.label: \(prediction.label)")
                    let sentiment = prediction.label
                    if sentiment == "Pos"{
                        sentimentScore+=1
                    }else if sentiment == "Neg"{
                        sentimentScore-=1
                    }
                }
                updataUI(with: sentimentScore)
                
            }catch{
                print("there is an error in predicating sentiment\(error)")
            }
                        
    }
    
    func updataUI(with sentimentScore:Int){
        print("sentimentScore: \(sentimentScore)")
        if sentimentScore > 20{
            self.sentimentLabel.text = "🥰"
        }else if sentimentScore > 10{
            self.sentimentLabel.text = "😊"
        }
        else if sentimentScore > 0{
            self.sentimentLabel.text = "🙂"
        }else if sentimentScore == 0{
            self.sentimentLabel.text = "😐"
        }
        else if sentimentScore > -10{
            self.sentimentLabel.text = "🙁"
        }else{
            self.sentimentLabel.text = "😡"
        }
                
    }
    

}

