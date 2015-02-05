//import UIKit
// var initialPage = 1
//
//class FeedsController :UIViewController , UITableViewDataSource , UITableViewDelegate  {
//
//    var feedsTable : UITableView! ;
//    var currentPage: Int!;
//    var myFeed : NSMutableArray!;
//    var scroller : UIScrollView
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        myFeed = NSMutableArray()
//        currentPage = initialPage
//        self.feedsTable = UITableView(frame: self.view.bounds)
//        self.feedsTable.autoresizingMask = UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleHeight
//       self.feedsTable.delegate = self;
//       self.feedsTable.dataSource = self;
//       self.view.addSubview(self.feedsTable)
//        self.feedsTable.addPullToRefreshWithActionHandler({() -> Void in
//            //code
//        })
//
//
//    }
//
//
//}
////#import <QuartzCore/QuartzCore.h>
////#import "MyListViewController.h"
////#import "AFNetworking.h"
////#import "UIScrollView+SVPullToRefresh.h"
////#import "UIScrollView+SVInfiniteScrolling.h"
////
//
////
////
////@implementation MyListViewController
//////
////    __weak typeof(self) weakSelf = self;
////    // refresh new data when pull the table list
////    [self.tableView addPullToRefreshWithActionHandler:^{
////    weakSelf.currentPage = initialPage; // reset the page
////    [weakSelf.myList removeAllObjects]; // remove all data
////    [weakSelf.tableView reloadData]; // before load new content, clear the existing table list
////    [weakSelf loadFromServer]; // load new data
////    [weakSelf.tableView.pullToRefreshView stopAnimating]; // clear the animation
////
////    // once refresh, allow the infinite scroll again
////    weakSelf.tableView.showsInfiniteScrolling = YES;
////    }];
////
////    // load more content when scroll to the bottom most
////    [self.tableView addInfiniteScrollingWithActionHandler:^{
////    [weakSelf loadFromServer];
////    }];
////    }
////
////    - (void)loadFromServer
////        {
////            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
////            [manager GET:[NSString stringWithFormat:@"http://api.example.com/list/%d", _currentPage] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
////
////                // if no more result
////                if ([[responseObject objectForKey:@"items"] count] == 0) {
////                self.tableView.showsInfiniteScrolling = NO; // stop the infinite scroll
////                return;
////                }
////
////                _currentPage++; // increase the page number
////                int currentRow = [_myList count]; // keep the the index of last row before add new items into the list
////
////                // store the items into the existing list
////                for (id obj in [responseObject valueForKey:@"items"]) {
////                [_myList addObject:obj];
////                }
////                [self reloadTableView:currentRow];
////
////                // clear the pull to refresh & infinite scroll, this 2 lines very important
////                [self.tableView.pullToRefreshView stopAnimating];
////                [self.tableView.infiniteScrollingView stopAnimating];
////
////                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
////                self.tableView.showsInfiniteScrolling = NO;
////                NSLog(@"error %@", error);
////                }];
////        }
////
////        - (void)reloadTableView:(int)startingRow;
////{
////    // the last row after added new items
////    int endingRow = [_myList count];
////
////    NSMutableArray *indexPaths = [NSMutableArray array];
////    for (; startingRow < endingRow; startingRow++) {
////        [indexPaths addObject:[NSIndexPath indexPathForRow:startingRow inSection:0]];
////    }
////
////    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
////}
////
////
////#pragma mark - UITableViewDelegate
////- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
////{
////    id item = [_myList objectAtIndex:indexPath.row];
////    NSLog(@"Selected item %@", item);
////}
////
////#pragma mark - UITableViewDataSource
////- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
////{
////    return [_myList count];
////    }
////
////    - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
////{
////    static NSString *cellIdentifier = @"MyListCell";
////    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
////    if (cell == nil) {
////        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
////    }
////    
////    // minus 1 because the first row is the search bar
////    id item = [_myList objectAtIndex:indexPath.row];
////    
////    cell.textLabel.text = [item valueForKey:@"name"];
////    
////    return cell;
////}
////
////@end
