#import "PrimesViewController.h"

BOOL isPrime(NSUInteger number)
{
    if (number < 2) return NO;
    
    for (int i = 2;  i < number; i++) // i * i <= number
    {
        if (number % i == 0)
        {
            return NO;
        }
    }
    
    return YES;
}

NSUInteger nthPrime(NSUInteger n)
{
    if (n == 0)
    {
        return 3;
    }
    
    NSUInteger primesFound = 0;
    NSUInteger prime = 3;
    
    while(primesFound < n)
    {
        prime += 2;
        if (isPrime(prime))
        {
            primesFound++;
        }
    }
    
    return prime;
}

@interface PrimesViewController ()

@end

@implementation PrimesViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2000;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PrimeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"[%d] = %d", indexPath.row, nthPrime(indexPath.row)];
    
    return cell;
}

@end
