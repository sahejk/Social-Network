#import "MyListViewController.h"
static int initialPage = 1; // paging start from 1, depends on your api


@implementation MyListViewController
Feed * feed;
@synthesize tableView = _tableView;

@synthesize currentPage = _currentPage;
@synthesize myList = _myList;

- (void)viewDidLoad
{
    [super viewDidLoad];

    feed = [[Feed alloc]init];
    // initialize
    _myList = [NSMutableArray array];
    _currentPage = initialPage;

    // init table list
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin| UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

    __weak typeof(self) weakSelf = self;
    // refresh new data when pull the table list
    [self.tableView addPullToRefreshWithActionHandler:^{
        weakSelf.currentPage = initialPage; // reset the page
        [weakSelf.myList removeAllObjects]; // remove all data
        [weakSelf.tableView reloadData]; // before load new content, clear the existing table list
        [weakSelf loadFromServer]; // load new data
        [weakSelf.tableView.pullToRefreshView stopAnimating]; // clear the animation

        // once refresh, allow the infinite scroll again
        weakSelf.tableView.showsInfiniteScrolling = YES;
    }];

    // load more content when scroll to the bottom most
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadFromServer];
    }];
}

- (void)loadFromServer
{
    Feed.page = _currentPage;
        _currentPage++; // increase the page number
        int currentRow = [_myList count]; // keep the the index of last row before add new items into the list
    _myList = [feed newPosts];

        [self reloadTableView:currentRow];

        // clear the pull to refresh & infinite scroll, this 2 lines very important
        [self.tableView.pullToRefreshView stopAnimating];
        [self.tableView.infiniteScrollingView stopAnimating];

}

- (void)reloadTableView:(int)startingRow;
{
    // the last row after added new items
    int endingRow = [_myList count];

    NSMutableArray *indexPaths = [NSMutableArray array];
    for (; startingRow < endingRow; startingRow++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:startingRow inSection:0]];
    }

    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item = [_myList objectAtIndex:indexPath.row];
    NSLog(@"Selected item %@", item);
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_myList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MyListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    // minus 1 because the first row is the search bar
    id item = [_myList objectAtIndex:indexPath.row];

    cell.textLabel.text = [item valueForKey:@"name"];
    
    return cell;
}

@end