//
//  MarketGroupsViewController.h
//  EVEUniverse
//
//  Created by Artem Shimanski on 9/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVEDBAPI.h"

@interface MarketGroupsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate> {
	UITableView *itemsTable;
	UISearchBar *searchBar;
	EVEDBInvMarketGroup *parentGroup;
	NSMutableArray *subGroups;
	NSMutableArray *groupItems;
	NSMutableArray *filteredValues;
}
@property (nonatomic, retain) IBOutlet UITableView *itemsTable;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) EVEDBInvMarketGroup *parentGroup;
@property (nonatomic, retain) NSMutableArray *subGroups;
@property (nonatomic, retain) NSMutableArray *groupItems;
@property (nonatomic, retain) NSMutableArray *filteredValues;

@end
