import Cocoa
import CreateML
import Foundation

print("haha")
let data = try MLDataTable(contentsOf:URL(fileURLWithPath: "/Users/admin/Desktop/project/sentimentPredict/twitter-sanders-apple3.csv"))
print("xixi")
let (trainingData,testingData) = data.randomSplit(by: 0.8,seed: 5)// seed设置为同一个数可以获得同样的数据

let sentimentClassifier = try MLTextClassifier(trainingData: trainingData, textColumn: "text", labelColumn: "class")

let evaulationMetrics = sentimentClassifier.evaluation(on: testingData, textColumn: "text", labelColumn: "class")

let evaAccuarcy = (1.0 - evaulationMetrics.classificationError)*100

let metaData = MLModelMetadata.init(author: "iris", shortDescription: "a model to classift sentiments on twitter", version: "1.0")

try sentimentClassifier.write(to: URL(fileURLWithPath: "/Users/admin/Desktop/project/sentimentPredict/twitterTraining.mlmodel"))

try sentimentClassifier.prediction(from: "@apple is terrible")

try sentimentClassifier.prediction(from: "I found the best restaurant, due to rick")
try sentimentClassifier.prediction(from: "CocoCola is just so so")




