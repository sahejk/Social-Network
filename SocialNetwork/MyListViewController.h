
#ifndef SocialNetwork_MyListViewController_h
#define SocialNetwork_MyListViewController_h


#endif
#import "SocialNetwork-swift.h"
#import <QuartzCore/QuartzCore.h>
#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "SocialNetwork-swift.h"
#import "MyListViewController.h"

@interface MyListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

// to keep track of what is the next page to load
@property (nonatomic, assign) int currentPage;
// to keep the objects GET from server
@property (nonatomic, strong) NSMutableArray *myList;
@end

