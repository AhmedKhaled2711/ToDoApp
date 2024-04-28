//
//  NewTaskViewController.m
//  ToDoApp
//
//  Created by Ahmed Khaled on 21/04/2024.
//

#import "NewTaskViewController.h"
#import "TaskModel.h"
#import "HelperClass.h"

@interface NewTaskViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *descTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySegmentedControl;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@end

@implementation NewTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}


- (IBAction)addingNewTask:(id)sender {
    if (_titleTextField.text.length == 0) {
        [self showAlertWithTitle:@"Error" message:@"Title is mandatory"];
        return;
    }
    TaskModel *newTask = [[TaskModel alloc] init];
    newTask.taskName = _titleTextField.text;
    newTask.taskDescription = _descTextField.text;
    newTask.taskState = @"0";
    newTask.taskPriority = [NSString stringWithFormat:@"%ld", (long)_prioritySegmentedControl.selectedSegmentIndex];
    NSMutableArray<TaskModel *> *taskArray = [self retrieveTaskArray];
    [taskArray addObject:newTask];
    [self saveTaskArray:taskArray];
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSMutableArray<TaskModel *> *)retrieveTaskArray {
    NSArray<TaskModel *> *storedTasks = [HelperClass readArrayWithTaskObjFromUserDefaults:@"taskArray"];
    return [NSMutableArray arrayWithArray:storedTasks ?: @[]];
}

- (void)saveTaskArray:(NSMutableArray<TaskModel *> *)taskArray {
    [HelperClass saveTaskArrayToUserDefaults:@"taskArray" withArray:taskArray];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleDefault
                                                      handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
