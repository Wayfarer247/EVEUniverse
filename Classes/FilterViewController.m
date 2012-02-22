//
//  FilterViewController.m
//  EVEUniverse
//
//  Created by Mr. Depth on 9/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FilterViewController.h"
#import "TagCellView.h"
#import "NibTableViewCell.h"

@implementation FilterViewController
@synthesize tableView;
@synthesize delegate;
@synthesize filter;
@synthesize values;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"Filter";
	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
		[self.navigationItem setLeftBarButtonItem:[[[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleBordered target:self action:@selector(onCancel:)] autorelease]];
		[self.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDone:)] autorelease]];
	}
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
	self.tableView = nil;
	self.values = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.values = [NSMutableArray array];
	for (EUFilterItem *item in filter.filters)
		[values addObject:[item.values sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]]]];
	
	[tableView reloadData];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		return UIInterfaceOrientationIsLandscape(interfaceOrientation);
	else
		return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) dealloc {
	[tableView release];
	[filter release];
	[values release];
	[super dealloc];
}

- (IBAction) onDone:(id)sender {
	[delegate filterViewController:self didApplyFilter:filter];
}

- (IBAction) onCancel:(id)sender {
	[delegate filterViewControllerDidCancel:self];
}

- (void) setFilter:(EUFilter *)value {
	EUFilter *oldValue = filter;
	filter = [value retain];
	if (value != oldValue && self.navigationController.visibleViewController != self)
		[self.navigationController popViewControllerAnimated:NO];
	[oldValue release];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return values.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[values objectAtIndex:section] count] + 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [[filter.filters objectAtIndex:section] name];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSString *cellIdentifier = @"TagCellView";
	
	TagCellView *cell = (TagCellView*) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [TagCellView cellWithNibName:@"TagCellView" bundle:nil reuseIdentifier:cellIdentifier];
	}
	EUFilterItem *filterItem = [filter.filters objectAtIndex:indexPath.section];
	if (indexPath.row == 0) {
		cell.titleLabel.text = filterItem.allValue;
		//cell.checkmarkImageView.image = [[filterItem selectedValues] count] == 0 ? [UIImage imageNamed:@"checkmark.png"] : nil;
		cell.checkmarkImageView.image = [[filterItem selectedValues] count] == 0 ? [UIImage imageNamed:@"checkmark.png"] : nil;
	}
	else {
		EUFilterItemValue *value = [[values objectAtIndex:indexPath.section] objectAtIndex:indexPath.row - 1];
		cell.titleLabel.text = value.title;
		//cell.checkmarkImageView.image = value.enabled ? [UIImage imageNamed:@"checkmark.png"] : nil;
		cell.checkmarkImageView.image = value.enabled ? [UIImage imageNamed:@"checkmark.png"] : nil;
	}
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 36;
}

- (UIView *)tableView:(UITableView *)aTableView viewForHeaderInSection:(NSInteger)section {
	UIView *header = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 22)] autorelease];
	header.opaque = NO;
	header.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.9];
	
	UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 22)] autorelease];
	label.opaque = NO;
	label.backgroundColor = [UIColor clearColor];
	label.text = [self tableView:aTableView titleForHeaderInSection:section];
	label.textColor = [UIColor whiteColor];
	label.font = [label.font fontWithSize:12];
	label.shadowColor = [UIColor blackColor];
	label.shadowOffset = CGSizeMake(1, 1);
	[header addSubview:label];
	return header;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[aTableView deselectRowAtIndexPath:indexPath animated:YES];
	EUFilterItem *filterItem = [filter.filters objectAtIndex:indexPath.section];
	if (indexPath.row == 0) {
		NSInteger row = 1;
		for (EUFilterItemValue *value in [values objectAtIndex:indexPath.section]) {
			if (value.enabled) {
				value.enabled = NO;
				TagCellView *cell = (TagCellView*) [aTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:indexPath.section]];
				cell.checkmarkImageView.image = nil;
			}
			row++;
		}
		TagCellView *cell = (TagCellView*) [aTableView cellForRowAtIndexPath:indexPath];
		cell.checkmarkImageView.image = [UIImage imageNamed:@"checkmark.png"];
	}
	else {
		EUFilterItemValue *value = [[values objectAtIndex:indexPath.section] objectAtIndex:indexPath.row - 1];
		TagCellView *cell = (TagCellView*) [aTableView cellForRowAtIndexPath:indexPath];
		value.enabled = !value.enabled;
		cell.checkmarkImageView.image = value.enabled ? [UIImage imageNamed:@"checkmark.png"] : nil;
		
		cell = (TagCellView*) [aTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
		cell.checkmarkImageView.image = [[filterItem selectedValues] count] == 0 ? [UIImage imageNamed:@"checkmark.png"] : nil;
	}
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		[delegate filterViewController:self didApplyFilter:filter];
	return;
}

#pragma mark UIPopoverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
	popoverController.popoverContentSize = CGSizeMake(320, 1100);
}

@end
