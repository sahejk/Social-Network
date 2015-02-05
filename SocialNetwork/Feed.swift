
import Foundation
 public class Feed : NSObject {

    private struct CurrentPage { static var pageNo: Int = 0 }

  public  class var page :Int {

        get { return CurrentPage.pageNo }
        set { CurrentPage.pageNo = newValue }
    }
    


  public  func newPosts()-> NSMutableArray {
        Feed.page = Feed.page + 1
        var posts = NSMutableArray()

        let httpHelper = HTTPHelper()

        let httpRequest = httpHelper.buildRequest("microposts?page=\(Feed.page)", method: "GET",
            authType: HTTPRequestAuthType.HTTPTokenAuth)

        httpHelper.sendRequest(httpRequest, completion: {(data:NSData!, error:NSError!) in
            // Display error
            if error != nil {
                return
            }

            var jsonerror:NSError?
            let responseDict = NSJSONSerialization.JSONObjectWithData(data,
                options: NSJSONReadingOptions.AllowFragments, error:&jsonerror) as NSArray
            var stopBool : Bool

            for (index,post) in enumerate(responseDict){
                posts.addObject(post["content"] as String);
            }

            })


        return posts
    }

     override init(){
        super.init()
        var posts = NSMutableArray()

    }
    deinit {
    }
}
