//
//  DoneViewController.m
//  ToDoApp
//
//  Created by Ahmed Khaled on 21/04/2024.
//

#import "DoneViewController.h"
#import "TaskModel.h"
#import "HelperClass.h"
#import "DetailsViewController.h"

@interface DoneViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySegmentedControl;

@property (strong, nonatomic) NSMutableArray<TaskModel *> *allDoneTasksArray;
@property (strong, nonatomic) NSArray<TaskModel *> *loadedTasks;
@property (strong, nonatomic) NSArray<TaskModel *> *filteredDataArray;

@end

@implementation DoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)segmentedAction:(id)sender {
    NSInteger selectedIndex = self.prioritySegmentedControl.selectedSegmentIndex;
    NSArray<TaskModel *> *filteredTasks = [HelperClass filterTasksFromArray:self.loadedTasks withFilter:@"2"];
    
    switch (selectedIndex) {
        case 0:
            self.allDoneTasksArray = [filteredTasks mutableCopy];
            break;
        case 1:
            self.allDoneTasksArray = [[HelperClass filterTasksByPriority:filteredTasks withPriority:@"0"] mutableCopy];
            break;
        case 2:
            self.allDoneTasksArray = [[HelperClass filterTasksByPriority:filteredTasks withPriority:@"1"] mutableCopy];
            break;
        case 3:
            self.allDoneTasksArray = [[HelperClass filterTasksByPriority:filteredTasks withPriority:@"2"] mutableCopy];
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.loadedTasks = [HelperClass readArrayWithTaskObjFromUserDefaults:@"taskArray"];
    NSArray<TaskModel *> *filteredTasks = [HelperClass filterTasksFromArray:self.loadedTasks withFilter:@"2"];
    self.allDoneTasksArray = [filteredTasks mutableCopy];
    [self.tableView reloadData];
    
    if (self.allDoneTasksArray.count == 0) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"empty"]];
        imageView.contentMode = UIViewContentModeCenter;
        self.tableView.backgroundView = imageView;
    } else {
        self.tableView.backgroundView = nil;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"doneCell" forIndexPath:indexPath];
    TaskModel *taskModel = self.allDoneTasksArray[indexPath.row];
    cell.textLabel.text = taskModel.taskName;
    
    UIImage *priorityImage = nil;
    switch ([taskModel.taskPriority intValue]) {
        case 0:
            priorityImage = [UIImage imageNamed:@"low"];
            break;
        case 1:
            priorityImage = [UIImage imageNamed:@"medium"];
            break;
        case 2:
            priorityImage = [UIImage imageNamed:@"high"];
            break;
        default:
            break;
    }
    
    CGFloat imageSize = 50.0;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageSize, imageSize)];
    imageView.image = priorityImage;
    cell.accessoryView = imageView;
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allDoneTasksArray.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TaskModel *selectedTask = self.allDoneTasksArray[indexPath.row];
    DetailsViewController *detailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
    [detailsViewController setDetailsTaskModel:selectedTask];
    NSMutableArray<TaskModel *> *mutableLoadedTasks = [self.loadedTasks mutableCopy];
    [detailsViewController setDetailsArray:mutableLoadedTasks];
    [self.navigationController pushViewController:detailsViewController animated:YES];
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Done List";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete" message:@"Are You Sure Want to Delete ?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *yesButton = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                TaskModel *removedTask = self.allDoneTasksArray[indexPath.row];
                NSMutableArray<TaskModel *> *originalList = [self.loadedTasks mutableCopy];
                [self.allDoneTasksArray removeObjectAtIndex:indexPath.row];
                [originalList removeObject:removedTask];
                [HelperClass removeArrayFromUserDefaults:@"taskArray"];
                [HelperClass saveTaskArrayToUserDefaults:@"taskArray" withArray:originalList];
                [tableView reloadData];
            }];
            UIAlertAction *noButton = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:yesButton];
            [alert addAction:noButton];
            [self presentViewController:alert animated:YES completion:nil];
        }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
@end
