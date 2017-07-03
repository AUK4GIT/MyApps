//
//  WMHomeViewController.m
//  MySideMenu
//
//  Created by Uday Kiran Ailapaka on 16/05/17.
//  Copyright © 2017 Kiran Reddy. All rights reserved.
//

#import "WMHomeViewController.h"
#import "WMAssignCell.h"
#import "WMLocationSearchViewController.h"
#import "WMWebservicesHelper.h"
#import "WMDataHelper.h"
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>
#import "WMCampaignDetailsViewController.h"

@interface WMHomeViewController () <WMLocationSearchSelectionProtocol, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *assignFilterButton;
@property (weak, nonatomic) IBOutlet UIButton *applyFilterButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *assignmentsLabel;
@property (strong, nonatomic) NSMutableArray *assignmentsArray;
@property (assign, nonatomic) BOOL selfAssign;
@property (assign, nonatomic) BOOL apply;
@property (strong, nonatomic) NSString *locationName;
@property(nonatomic, strong) IBOutlet UIView *mapBGView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIImageView *noImageView;
@property (weak, nonatomic) IBOutlet UILabel *noImageLabel;
@end

@implementation WMHomeViewController
{
    GMSMapView *mapView;
    GMSPlacesClient *placesClient;
    CLLocation *currentLocation;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.noImageView.hidden = true;
    self.noImageLabel.hidden = true;
    
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_action_search"] style:UIBarButtonItemStylePlain target:self action:@selector(assignmentsSearchTapped:)];
    
    self.assignmentsLabel.text = @"";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WMAssignCell" bundle:nil] forCellReuseIdentifier:@"WMAssignCell"];
    self.tableView.rowHeight = 136;
    
    [self addTitleView:@"Please tap here to select a location"];
    
    self.selfAssign = false;
    self.apply = false;
    
//    [self getCurrentPosition];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:28.4595 longitude:77.0266];
   [self showCurrentPositionOnMap:location];
}

//- (void)getCurrentPosition {
//    self.locationManager = [[CLLocationManager alloc] init];
//    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
//        [self.locationManager requestWhenInUseAuthorization];
//    }
//    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    self.locationManager.distanceFilter = kCLDistanceFilterNone;
//    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
//    self.locationManager.delegate = self;
//    [self.locationManager startUpdatingLocation];
//}

- (void)showCurrentPositionOnMap:(CLLocation*)location{
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:location.coordinate.latitude
                                                            longitude:location.coordinate.longitude
                                                                 zoom:6];
    mapView = [GMSMapView mapWithFrame:self.mapBGView.bounds camera:camera];
    mapView.myLocationEnabled = YES;
    [self.mapBGView addSubview:mapView];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    marker.title = @"Gurgoan";
    marker.snippet = @"Delhi";
    marker.map = mapView;
}

#pragma mark - CLLocationManagerDelegate
- (void)didUpdateLocations:(NSArray<CLLocation *> *)locations  {
    currentLocation = [locations firstObject];
    [self showCurrentPositionOnMap:currentLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
        NSLog(@"Error: %@",error);
}


- (void)addTitleView:(NSString *)title {
    
    UIImageView *caratImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_arrow_drop_down_white"]];
    caratImgView.backgroundColor = [UIColor clearColor];
    caratImgView.contentMode = UIViewContentModeScaleAspectFit;
    caratImgView.userInteractionEnabled = true;
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleLabel.text = title;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.frame = CGRectMake(0, 0, self.view.bounds.size.width-150, 44);
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width-100, 44)];
    titleView.backgroundColor = [UIColor clearColor];
    [titleView addSubview:self.titleLabel];
    [titleView addSubview:caratImgView];
    self.titleLabel.center = CGPointMake(titleView.bounds.size.width/2, titleView.bounds.size.height/2);
//    CGSize labelSize = [self.titleLabel sizeThatFits:CGSizeMake(self.view.bounds.size.width-150, 44)];
    [caratImgView setFrame:CGRectMake(self.titleLabel.frame.size.width+8, 4, 35, 35)];

    [self.navigationItem setTitleView:titleView];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locationSearchTapped:)];
    titleView.userInteractionEnabled = true;
    [titleView addGestureRecognizer:tapGes];
}

- (void)locationSearchTapped:(id)sender {
    [self performSegueWithIdentifier:@"locationsearch" sender:nil];
}

- (void)assignmentsSearchTapped:(id)sender {
    [self performSegueWithIdentifier:@"SearchAssignment" sender:nil];
}

- (IBAction)assignmentFilterAction:(UIButton *)sender {
    [sender setSelected:!sender.isSelected];
    if (self.assignFilterButton == sender) {
        self.selfAssign = !self.selfAssign;
    } else {
        self.apply = !self.apply;
    }
    if (self.locationName) {
        [self getAssignmentsByLocationName:self.locationName forSelfAssign:[NSString stringWithFormat:@"%d",self.selfAssign] forApply:[NSString stringWithFormat:@"%d",self.apply]];
    } else {
//        [self getAssignmentsByLocationid:self.locationId forSelfAssign:[NSString stringWithFormat:@"%d",self.selfAssign] forApply:[NSString stringWithFormat:@"%d",self.apply]];
    }
}

- (void)getAssignmentsByLocationName:(NSString *)locationName forSelfAssign:(NSString *)selfAssign forApply:(NSString *)apply{
    
    NSString *authKey = [[WMDataHelper sharedInstance] getAuthKey];
    [[WMWebservicesHelper sharedInstance] getAssignments:authKey byLocationName:locationName forSelfAssign:selfAssign forApply:apply completionBlock:^(BOOL result, id responseDict, NSError *error) {
        NSLog(@"result:-> %@",result ? @"success" : @"Failed");
        if (result) {
            self.assignmentsArray = [NSMutableArray arrayWithArray:[[WMDataHelper sharedInstance] saveAssignments:responseDict]];
        } else {
            NSDictionary *resDict = responseDict;
            if ([resDict[@"code"] integerValue] == 409) {
                NSLog(@"Error responseDict:->  %@",resDict[@"message"]);
            } else {
                NSLog(@"Error:->  %@",error.localizedDescription);
            }
        }
        //add UI related code here like stopping activity indicator
        dispatch_async(dispatch_get_main_queue(), ^{
            //            [activityView stopAnimating];
            self.assignmentsLabel.text = [NSString stringWithFormat:@"%lu Assignments found in your location ",(unsigned long)self.assignmentsArray.count];
            if (self.assignmentsArray.count == 0) {
                self.noImageView.hidden = false;
                self.noImageLabel.hidden = false;
            } else {
                self.noImageView.hidden = true;
                self.noImageLabel.hidden = true;
            }
            [self.tableView reloadData];
        });
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"locationsearch"]) {
        WMLocationSearchViewController *lsVC = [segue destinationViewController];
        lsVC.delegate = self;
    }
}


#pragma mark - UITbleView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.assignmentsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WMAssignCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WMAssignCell"];
    
    id assignObj = self.assignmentsArray[indexPath.row];
    cell.moneyLabel.text = [NSString stringWithFormat:@"₹ %@",[assignObj valueForKey:@"campaignbudget"]];
    cell.assignStatus.text = [assignObj valueForKey:@"assignmentstatus"];
    cell.calData.text = [NSString stringWithFormat:@"%@ - %@",[assignObj valueForKey:@"assignmentduedate"],[assignObj valueForKey:@"assignmentduedate"]];
//    cell.distanceLabel.text = [assignObj valueForKey:@""];//todo
    [cell setClientImageWithURL:[assignObj valueForKey:@"logoURL"]];
    cell.titleLabel.text = [assignObj valueForKey:@"campaigntitle"];
    return cell;
}

#pragma mark - UITbleView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id assignObj = self.assignmentsArray[indexPath.row];
    WMCampaignDetailsViewController *cVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WMCampaignDetailsViewController"];
    cVC.campaignid = [assignObj valueForKey:@"campaignid"];
    cVC.clientid = [assignObj valueForKey:@"clientid"];

    [self.navigationController pushViewController:cVC animated:true];
    }

#pragma mark - Location Search Selection delegate
- (void)didSelectLocation:(id)locationobj {
    self.locationName = [locationobj valueForKey:@"clientlocationid"];
    self.titleLabel.text = [locationobj valueForKey:@"city"];
    [self getAssignmentsByLocationName:[locationobj valueForKey:@"clientlocationid"] forSelfAssign:@"1" forApply:@"1"];
    
    [self.assignFilterButton setSelected:true];
    [self.applyFilterButton setSelected:true];
}

@end
