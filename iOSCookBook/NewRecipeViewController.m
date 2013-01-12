//
//  NewRecipeViewController.m
//  iOSCookBook
//
//  Created by Andrew O'Connor on 11/01/2013.
//  Copyright (c) 2013 Andrew O'Connor. All rights reserved.
//

#import "NewRecipeViewController.h"
#import "ViewController.h"

@interface NewRecipeViewController ()

-(void)defaultTextFieldValues:(UITextField*) textField;
@end

@implementation NewRecipeViewController

UITextField *name, *servings, *prepTime, *cookTime, *ingredInput, *instrInput, *catInput;
UITextView *ingredList, *instrList, *catList;
UILabel *ingredLabel, *instrLabel, *catLabel;
UIButton *addIngredButton, *addInstrButton, *catButton, *saveButton, *addPhotoButton;

int instrCounter = 0;
int yShiftAfterIngredients = 20;
int yShiftAfterInstructions = 20;
int yShiftAfterCategories = 20;

-(void)defaultTextFieldValues:(UITextField *)textField{
  textField.borderStyle = UITextBorderStyleRoundedRect;
  textField.font = [UIFont systemFontOfSize:15];
  textField.autocorrectionType = UITextAutocorrectionTypeNo;
  textField.returnKeyType = UIReturnKeyDone;
  textField.clearButtonMode = UITextFieldViewModeWhileEditing;
  textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
  textField.delegate = self;
}

//adds new ingredient and updates positions
- (IBAction)addIngredient{
  if ([ingredInput.text length] > 0) {
    ingredList.text = [[ingredList.text stringByAppendingString:ingredInput.text] stringByAppendingString:@"\n"];
    yShiftAfterIngredients += 15;
    [self updatePositions];
  }
}

//adds new instruction and updates positions
- (IBAction)addInstruction{
  if ([instrInput.text length] > 0) {
    instrCounter++;
    NSString *newInstruction = [[NSString stringWithFormat:@"%i: ",instrCounter] stringByAppendingString: instrInput.text];
    instrList.text = [[instrList.text stringByAppendingString:newInstruction] stringByAppendingString:@"\n"];
    yShiftAfterInstructions += 15;
  
    [self updatePositions];
  }
  
}

//adds new Category and updates positions
- (IBAction)addCategory{
  if ([catInput.text length] > 0) {
    catList.text = [[catList.text stringByAppendingString:catInput.text] stringByAppendingString:@"\n"];
    yShiftAfterCategories += 15;
  
    [self updatePositions];
  }
}

//brings up options to add image
- (IBAction)addPhoto{
  
}

//Attempts to save, if valid then directs to the page of the newly created recipe
-(IBAction)savePressed{
  ViewController *next = [[ViewController alloc] initWithNibName:nil bundle:nil];
  [self presentViewController:next animated:TRUE completion:nil];
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return NO;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)updatePositions{
  ingredList.frame = CGRectMake(5, 105, 300, yShiftAfterIngredients);
  ingredInput.frame = CGRectMake(5, (140+yShiftAfterIngredients), 120, 30);
  addIngredButton.frame = CGRectMake(150, (140+yShiftAfterIngredients), 30, 30);;
  instrLabel.frame = CGRectMake(5, (180+yShiftAfterIngredients), 150, 30);
  instrList.frame = CGRectMake(5, (220+yShiftAfterIngredients), 250, yShiftAfterInstructions);
  
  int combinedYShift = yShiftAfterIngredients + yShiftAfterInstructions;
  instrInput.frame = CGRectMake(5, (260+combinedYShift), 120, 30);
  addInstrButton.frame = CGRectMake(150, (260+combinedYShift), 30, 30);
  catLabel.frame = CGRectMake(5, (300+combinedYShift), 150, 30);
  catList.frame = CGRectMake(5, (340+combinedYShift), 250, yShiftAfterCategories);
  
  combinedYShift = combinedYShift + yShiftAfterCategories;
  catInput.frame = CGRectMake(5, (370+combinedYShift), 120, 30);
  catButton.frame = CGRectMake(150, (370+combinedYShift), 30, 30);
  addPhotoButton.frame = CGRectMake(5, (410+combinedYShift), 100, 30);
  saveButton.frame = CGRectMake(210, (410+combinedYShift), 100, 30);
  
  self.scroller.contentSize = CGSizeMake(320, (500+combinedYShift));
}
- (void)viewDidLoad
{
  [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  
  [self.scroller setScrollEnabled:TRUE];
  
  
  name = [[UITextField alloc] initWithFrame:CGRectMake(100, 5, 110, 30)];
  [self defaultTextFieldValues:name];
  name.placeholder = @"Recipe Name";
  [self.scroller addSubview:name];
  
  servings = [[UITextField alloc] initWithFrame:CGRectMake(5, 40, 97, 30)];
  [self defaultTextFieldValues:servings];
  servings.placeholder = @"Servings";
  [self.scroller addSubview:servings];
  
  prepTime = [[UITextField alloc] initWithFrame:CGRectMake(110, 40, 97, 30)];
  [self defaultTextFieldValues:prepTime];
  prepTime.placeholder = @"Prep Time";
  [self.scroller addSubview:prepTime];

  cookTime = [[UITextField alloc] initWithFrame:CGRectMake(210, 40, 97, 30)];
  [self defaultTextFieldValues:cookTime];
  cookTime.placeholder = @"Cook Time";
  [self.scroller addSubview:cookTime];
  
  ingredLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 75, 150, 30)];
  ingredLabel.font = [UIFont systemFontOfSize:20];
  ingredLabel.text = @"Ingredients";
  [self.scroller addSubview:ingredLabel];
  
  //TODO: Expand when text added
  ingredList = [[UITextView alloc] initWithFrame:CGRectMake(5, 105, 300, 30)];
  ingredList.editable = FALSE;
  ingredList.scrollEnabled = FALSE;
  [self.scroller addSubview:ingredList];
  
  ingredInput = [[UITextField alloc] initWithFrame:CGRectMake(5, 140, 120, 30)];
  [self defaultTextFieldValues:ingredInput];
  ingredInput.placeholder = @"Ingredient";
  [self.scroller addSubview:ingredInput];
  
  addIngredButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [addIngredButton addTarget:self action:@selector(addIngredient) forControlEvents:UIControlEventTouchDown];
  [addIngredButton setTitle:@"+" forState:UIControlStateNormal];
  addIngredButton.frame = CGRectMake(150, 140, 30, 30);
  [self.scroller addSubview:addIngredButton];
  
  instrLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 180, 150, 30)];
  instrLabel.font = [UIFont systemFontOfSize:20];
  instrLabel.text = @"Instructions";
  [self.scroller addSubview:instrLabel];
  
  //TODO: add timer button to each line
  instrList = [[UITextView alloc] initWithFrame:CGRectMake(5, 220, 250, 30)];
  instrList.editable = FALSE;
  instrList.scrollEnabled = FALSE;
  [self.scroller addSubview:instrList];
  
  instrInput = [[UITextField alloc] initWithFrame:CGRectMake(5, 260, 120, 30)];
  [self defaultTextFieldValues:instrInput];
  instrInput.placeholder = @"Instruction";
  [self.scroller addSubview:instrInput];
  
  addInstrButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [addInstrButton addTarget:self action:@selector(addInstruction) forControlEvents:UIControlEventTouchDown];
  [addInstrButton setTitle:@"+" forState:UIControlStateNormal];
  addInstrButton.frame = CGRectMake(150, 260, 30, 30);
  [self.scroller addSubview:addInstrButton];
  
  catLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 300, 150, 30)];
  catLabel.font = [UIFont systemFontOfSize:20];
  catLabel.text = @"Categories";
  [self.scroller addSubview:catLabel];
  
  catList = [[UITextView alloc] initWithFrame:CGRectMake(5, 340, 250, 30)];
  catList.editable = FALSE;
  catList.scrollEnabled = FALSE;
  [self.scroller addSubview:catList];
  
  catInput = [[UITextField alloc] initWithFrame:CGRectMake(5, 370, 120, 30)];
  [self defaultTextFieldValues:catInput];
  catInput.placeholder = @"Category";
  [self.scroller addSubview:catInput];
  
  catButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [catButton addTarget:self action:@selector(addCategory) forControlEvents:UIControlEventTouchDown];
  [catButton setTitle:@"+" forState:UIControlStateNormal];
  catButton.frame = CGRectMake(150, 370, 30, 30);
  [self.scroller addSubview:catButton];
  
  addPhotoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [addPhotoButton addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchDown];
  [addPhotoButton setTitle:@"Add Photo" forState:UIControlStateNormal];
  addPhotoButton.frame = CGRectMake(5, 410, 100, 30);
  [self.scroller addSubview:addPhotoButton];
  
  saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [saveButton addTarget:self action:@selector(savePressed) forControlEvents:UIControlEventTouchDown];
  [saveButton setTitle:@"Save Recipe" forState:UIControlStateNormal];
  saveButton.frame = CGRectMake(210, 410, 100, 30);
  [self.scroller addSubview:saveButton];
  
  [self.scroller setContentSize:CGSizeMake(320, 500)];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
