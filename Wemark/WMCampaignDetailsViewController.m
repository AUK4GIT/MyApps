//
//  WMCampaignDetailsViewController.m
//  Wemark
//
//  Created by Uday Kiran Ailapaka on 05/06/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import "WMCampaignDetailsViewController.h"
#import "HMSegmentedControl.h"
#import "WMAllAssignmentsClientIdViewController.h"

@interface WMCampaignDetailsViewController ()
@property (nonatomic, strong) IBOutlet UILabel *expLbl;
@property (nonatomic, strong) IBOutlet UIView *segmentBGView;
@end

@implementation WMCampaignDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_action_search"] style:UIBarButtonItemStylePlain target:self action:@selector(allAssignmentsTapped:)];

    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"APPLIED", @"ASSIGNED", @"ACCEPTED",@"REJECTED"]];
    segmentedControl.frame = CGRectMake(0, 0, self.view.bounds.size.width, 54);
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.segmentBGView addSubview:segmentedControl];
    segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    segmentedControl.selectedSegmentIndex = 1;
    segmentedControl.backgroundColor = [UIColor colorWithRed:260/255.0 green:0.0 blue:60.0/255.0 alpha:1];
    segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:0.8]};
    segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    segmentedControl.selectionIndicatorColor = [UIColor colorWithRed:1.0 green:247.0/255.0 blue:86.0/255.0 alpha:1];
    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl.tag = 3;
}
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    
}

- (void)allAssignmentsTapped:(id)sender {
    [self performSegueWithIdentifier:@"AllAssignments" sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"AllAssignments"]) {
        WMAllAssignmentsClientIdViewController *vc = segue.destinationViewController;
        vc.clientid = self.clientid;
    }
}


@end