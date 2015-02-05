
import Foundation

class Photo  {
    var name :String!;
    var title :String!;
    var image_url :String!
    var imageData :String!

    init(photoDict :NSDictionary!){
        title = photoDict["title"] as String
        name  = photoDict["name"] as String
        image_url = photoDict["image_url"] as String

    }

    class func newPhoto(dataDictionary:Dictionary<String,String>) -> Photo {
        return Photo(photoDict: dataDictionary)
    }

}