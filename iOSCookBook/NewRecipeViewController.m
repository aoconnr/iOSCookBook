//
//  NewRecipeViewController.m
//  iOSCookBook
//
//  Created by Andrew O'Connor on 11/01/2013.
//  Copyright (c) 2013 Andrew O'Connor. All rights reserved.
//

#import "NewRecipeViewController.h"
#import "ViewController.h"
#import "iOSCookBookModel.h"
#import "Recipe.h"
#import "ingredient.h"
#import "instruction.h"

@interface NewRecipeViewController ()

-(void)defaultTextFieldValues:(UITextField*) textField;
@end

@implementation NewRecipeViewController

iOSCookBookModel *model;
UITextField *name, *servings, *prepTime, *cookTime, *ingredInput, *instrInput, *catInput, *timerInput;
UITextView *ingredList, *instrList, *catList;
UILabel *ingredLabel, *instrLabel, *catLabel;
UIButton *addIngredButton, *addInstrButton, *catButton, *saveButton, *addPhotoButton, *takePhotoButton, *undoIngredButton, *undoInstrButton, *undoCatButton;
UIImageView *imageView;

NSMutableArray *ingredients;
NSMutableArray *instructions;
NSMutableArray *categories;

int ingCounter = 0;
int instrCounter = 0;
int yShiftAfterIngredients = 20;
int yShiftAfterInstructions = 20;
int yShiftAfterCategories = 20;


//generic values used for all text fields on the page
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
      ingCounter++;
    ingredient *i = [[ingredient alloc] initWithIngredient:ingredInput.text order:ingCounter];
    [ingredients addObject:i];
      ingredInput.text = @"";
  }
}

//adds new instruction and updates positions
- (IBAction)addInstruction{
  if ([instrInput.text length] > 0) {
    instrCounter++;
    NSString *newInstruction = [[NSString stringWithFormat:@"%i: ",instrCounter] stringByAppendingString: instrInput.text];
    if([timerInput.text length] > 0){
      newInstruction = [[newInstruction stringByAppendingString:@". Timer:"] stringByAppendingString:timerInput.text];
        instruction *i = [[instruction alloc] initWithInstruction:instrInput.text order:instrCounter timer:timerInput.text];
        [instructions addObject:i];
    }

    instrList.text = [[instrList.text stringByAppendingString:newInstruction] stringByAppendingString:@"\n"];
    yShiftAfterInstructions += 15;
    
    [self updatePositions];
      instrInput.text = @"";
      timerInput.text = @"";
  }
  
}

//adds new Category and updates positions
- (IBAction)addCategory{
  if ([catInput.text length] > 0) {
    catList.text = [[catList.text stringByAppendingString:catInput.text] stringByAppendingString:@"\n"];
    yShiftAfterCategories += 15;
    [categories addObject:catInput.text];
  
    [self updatePositions];
      catInput.text = @"";
  }
}

//brings up options to add image from album
- (IBAction)addPhoto{
  
  UIImagePickerController *picker =  [[UIImagePickerController alloc] init] ;
	picker.delegate = self;
  picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
  
  [self presentViewController:picker animated:TRUE completion:nil];
}

//brings up options to add image through camera
- (IBAction)takePhoto{
  UIImagePickerController *picker =  [[UIImagePickerController alloc] init];
	picker.delegate = self;
  picker.sourceType = UIImagePickerControllerSourceTypeCamera;
  
  [self presentViewController:picker animated:TRUE completion:nil];
}

//Used to place image on page and save
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  [picker dismissViewControllerAnimated:TRUE completion:nil];
	imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
}

//Attempts to save, if valid then directs to the page of the newly created recipe
-(IBAction)savePressed{

    Recipe *recipe = [[Recipe alloc] initWithName:name.text categories:categories quantity:[servings.text intValue] photo:@"" favourite:0 rating:0 prep: [prepTime.text intValue] cook:[cookTime.text intValue] instructions:instructions ingredients:ingredients] ;
    [model addRecipe:recipe];
    instrCounter = 0;
    ingCounter = 0;
  //ViewController *next = [[ViewController alloc] initWithNibName:nil bundle:nil];
  [self.navigationController popViewControllerAnimated:TRUE];
    //TODO: sort out the times and photo filename
    
}

//removes last item for ingredient list and updates positions
-(void)undoIngredList{
  NSArray *splitString = [ingredList.text componentsSeparatedByString:@"\n"];
  NSString *newString = @"";
  if ([splitString count] > 1) {
    for (int i=0; i<([splitString count]-2); i++) {
      newString = [[newString stringByAppendingString:[splitString objectAtIndex:i]] stringByAppendingString:@"\n"];
    }
    [ingredients removeLastObject];
    ingCounter--;
    ingredList.text = newString;
    yShiftAfterIngredients -= 15;
    [self updatePositions];
  }
}

//removes last item from instruction list and updates positions
-(void)undoInstrList{
  NSArray *splitString = [instrList.text componentsSeparatedByString:@"\n"];
  NSString *newString = @"";
  if ([splitString count] > 1) {
    for (int i=0; i<([splitString count]-2); i++) {
      newString = [[newString stringByAppendingString:[splitString objectAtIndex:i]] stringByAppendingString:@"\n"];
    }
    [instructions removeLastObject];
    instrList.text = newString;
    instrCounter --;
    yShiftAfterInstructions -= 15;
    [self updatePositions];
  }
}

//removes last item from category list and updates positions
-(void)undoCatList{
  NSArray *splitString = [catList.text componentsSeparatedByString:@"\n"];
  NSString *newString = @"";
  if ([splitString count] > 1) {
    for (int i=0; i<([splitString count]-2); i++) {
      newString = [[newString stringByAppendingString:[splitString objectAtIndex:i]] stringByAppendingString:@"\n"];
    }
    [categories removeLastObject];
    catList.text = newString;
    yShiftAfterCategories -= 15;
    [self updatePositions];
  }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        instructions = [NSMutableArray new];
        ingredients = [NSMutableArray new];
        categories = [NSMutableArray new];
        model = [iOSCookBookModel new];
    }
    return self;
}

//shifts positions keep page format with longer lists
-(void)updatePositions{
  ingredList.frame = CGRectMake(5, 215, 300, yShiftAfterIngredients);
  ingredInput.frame = CGRectMake(5, (250+yShiftAfterIngredients), 120, 30);
  addIngredButton.frame = CGRectMake(150, (250+yShiftAfterIngredients), 30, 30);
  undoIngredButton.frame = CGRectMake(200, (250+yShiftAfterIngredients), 50, 30);
  instrLabel.frame = CGRectMake(5, (290+yShiftAfterIngredients), 150, 30);
  instrList.frame = CGRectMake(5, (330+yShiftAfterIngredients), 250, yShiftAfterInstructions);
  
  int combinedYShift = yShiftAfterIngredients + yShiftAfterInstructions;
  instrInput.frame = CGRectMake(5, (370+combinedYShift), 120, 30);
  timerInput.frame = CGRectMake(130, (370+combinedYShift), 75, 30);
  addInstrButton.frame = CGRectMake(210, (370+combinedYShift), 30, 30);
  undoInstrButton.frame = CGRectMake(250, (370+combinedYShift), 50, 30);
  catLabel.frame = CGRectMake(5, (410+combinedYShift), 150, 30);
  catList.frame = CGRectMake(5, (450+combinedYShift), 250, yShiftAfterCategories);
  
  combinedYShift = combinedYShift + yShiftAfterCategories;
  catInput.frame = CGRectMake(5, (480+combinedYShift), 120, 30);
  catButton.frame = CGRectMake(150, (480+combinedYShift), 30, 30);
  undoCatButton.frame = CGRectMake(200, (480+combinedYShift), 50, 30);
  addPhotoButton.frame = CGRectMake(5, (520+combinedYShift), 100, 30);
  takePhotoButton.frame = CGRectMake(4, (560+combinedYShift), 100, 30);
  saveButton.frame = CGRectMake(210, (560+combinedYShift), 100, 30);
  
  //increases the size of the max scroll height based off list items
  self.scroller.contentSize = CGSizeMake(320, (600+combinedYShift));
}

//hide keyboard when background tapped
- (void) hideKeyboard {
  [cookTime resignFirstResponder];
  [name resignFirstResponder];
  [prepTime resignFirstResponder];
  [servings resignFirstResponder];
  [ingredInput resignFirstResponder];
  [instrInput resignFirstResponder];
  [timerInput resignFirstResponder];
  [catInput resignFirstResponder];
}

//hide keyboard when return key used
-(void)textFieldShouldReturn:(UITextField *)textField{
  [textField resignFirstResponder];
}

//builds UI on UIScrollView
- (void)viewDidLoad
{
  self.title = @"New Recipe";
  [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  
  [self.scroller setScrollEnabled:TRUE];
  self.scroller.backgroundColor = [UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1.0f];
  
  name = [[UITextField alloc] initWithFrame:CGRectMake(100, 5, 110, 30)];
  [self defaultTextFieldValues:name];
  name.placeholder = @"Recipe Name";
  [self.scroller addSubview:name];
  
  imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 40, 100, 100)];
  imageView.backgroundColor = [UIColor orangeColor];
  imageView.image = [UIImage imageNamed:@"DefaultRecipePic.gif"];
  [self.scroller addSubview:imageView];
  
  servings = [[UITextField alloc] initWithFrame:CGRectMake(5, 150, 97, 30)];
  [self defaultTextFieldValues:servings];
  servings.placeholder = @"Servings";
  servings.keyboardType = UIKeyboardTypeDecimalPad;
  [self.scroller addSubview:servings];
  
  prepTime = [[UITextField alloc] initWithFrame:CGRectMake(110, 150, 97, 30)];
  [self defaultTextFieldValues:prepTime];
  prepTime.placeholder = @"Prep Time";
  prepTime.keyboardType = UIKeyboardTypeDecimalPad;
  [self.scroller addSubview:prepTime];

  cookTime = [[UITextField alloc] initWithFrame:CGRectMake(210, 150, 97, 30)];
  [self defaultTextFieldValues:cookTime];
  cookTime.placeholder = @"Cook Time";
  cookTime.keyboardType = UIKeyboardTypeDecimalPad;
  [self.scroller addSubview:cookTime];
  
  ingredLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 185, 150, 30)];
  ingredLabel.font = [UIFont systemFontOfSize:20];
  ingredLabel.backgroundColor = [UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1.0f];
  ingredLabel.text = @"Ingredients";
  [self.scroller addSubview:ingredLabel];
  
  ingredList = [[UITextView alloc] initWithFrame:CGRectMake(5, 215, 300, 30)];
  ingredList.editable = FALSE;
  ingredList.scrollEnabled = FALSE;
  ingredList.backgroundColor = [UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1.0f];
  [self.scroller addSubview:ingredList];
  
  ingredInput = [[UITextField alloc] initWithFrame:CGRectMake(5, 250, 120, 30)];
  [self defaultTextFieldValues:ingredInput];
  ingredInput.placeholder = @"Ingredient";
  [self.scroller addSubview:ingredInput];
  
  addIngredButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [addIngredButton addTarget:self action:@selector(addIngredient) forControlEvents:UIControlEventTouchDown];
  [addIngredButton setTitle:@"+" forState:UIControlStateNormal];
  [addIngredButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  addIngredButton.frame = CGRectMake(150, 250, 30, 30);
  [self.scroller addSubview:addIngredButton];
  
  undoIngredButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [undoIngredButton addTarget:self action:@selector(undoIngredList) forControlEvents:UIControlEventTouchDown];
  [undoIngredButton setTitle:@"Undo" forState:UIControlStateNormal];
  [undoIngredButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  undoIngredButton.frame = CGRectMake(200, 250, 50, 30);
  [self.scroller addSubview:undoIngredButton];
  
  
  instrLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 290, 150, 30)];
  instrLabel.font = [UIFont systemFontOfSize:20];
  instrLabel.text = @"Instructions";
  instrLabel.backgroundColor = [UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1.0f];
  [self.scroller addSubview:instrLabel];
  
  //TODO: add timer button to each line
  instrList = [[UITextView alloc] initWithFrame:CGRectMake(5, 330, 250, 30)];
  instrList.editable = FALSE;
  instrList.scrollEnabled = FALSE;
  instrList.backgroundColor = [UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1.0f];
  [self.scroller addSubview:instrList];
  
  instrInput = [[UITextField alloc] initWithFrame:CGRectMake(5, 370, 120, 30)];
  [self defaultTextFieldValues:instrInput];
  instrInput.placeholder = @"Instruction";
  [self.scroller addSubview:instrInput];
  
  timerInput = [[UITextField alloc] initWithFrame:CGRectMake(130, 370, 75, 30)];
  [self defaultTextFieldValues:timerInput];
  timerInput.placeholder = @"minutes";
  timerInput.keyboardType = UIKeyboardTypeDecimalPad;
  [self.scroller addSubview:timerInput];
  
  addInstrButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [addInstrButton addTarget:self action:@selector(addInstruction) forControlEvents:UIControlEventTouchDown];
  [addInstrButton setTitle:@"+" forState:UIControlStateNormal];
  [addInstrButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  addInstrButton.frame = CGRectMake(210, 370, 30, 30);
  [self.scroller addSubview:addInstrButton];
  
  undoInstrButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [undoInstrButton addTarget:self action:@selector(undoInstrList) forControlEvents:UIControlEventTouchDown];
  [undoInstrButton setTitle:@"Undo" forState:UIControlStateNormal];
  [undoInstrButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  undoInstrButton.frame = CGRectMake(250, 370, 50, 30);
  [self.scroller addSubview:undoInstrButton];
  
  catLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 410, 150, 30)];
  catLabel.font = [UIFont systemFontOfSize:20];
  catLabel.text = @"Categories";
  catLabel.backgroundColor = [UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1.0f];
  [self.scroller addSubview:catLabel];
  
  catList = [[UITextView alloc] initWithFrame:CGRectMake(5, 450, 250, 30)];
  catList.editable = FALSE;
  catList.scrollEnabled = FALSE;
  catList.backgroundColor = [UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1.0f];
  [self.scroller addSubview:catList];
  
  catInput = [[UITextField alloc] initWithFrame:CGRectMake(5, 480, 120, 30)];
  [self defaultTextFieldValues:catInput];
  catInput.placeholder = @"Category";
  [self.scroller addSubview:catInput];
  
  catButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [catButton addTarget:self action:@selector(addCategory) forControlEvents:UIControlEventTouchDown];
  [catButton setTitle:@"+" forState:UIControlStateNormal];
  catButton.frame = CGRectMake(150, 480, 30, 30);
  [catButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [self.scroller addSubview:catButton];
  
  undoCatButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [undoCatButton addTarget:self action:@selector(undoCatList) forControlEvents:UIControlEventTouchDown];
  [undoCatButton setTitle:@"Undo" forState:UIControlStateNormal];
  [undoCatButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  undoCatButton.frame = CGRectMake(200, 480, 50, 30);
  [self.scroller addSubview:undoCatButton];
  
  addPhotoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [addPhotoButton addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchDown];
  [addPhotoButton setTitle:@"Add Photo" forState:UIControlStateNormal];
  addPhotoButton.frame = CGRectMake(5, 520, 100, 30);
  [addPhotoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [self.scroller addSubview:addPhotoButton];
  
  takePhotoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [takePhotoButton addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchDown];
  [takePhotoButton setTitle:@"Take Photo" forState:UIControlStateNormal];
  takePhotoButton.frame = CGRectMake(5, 560, 100, 30);
  [takePhotoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [self.scroller addSubview:takePhotoButton];
  
  saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [saveButton addTarget:self action:@selector(savePressed) forControlEvents:UIControlEventTouchDown];
  [saveButton setTitle:@"Save Recipe" forState:UIControlStateNormal];
  [saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  saveButton.frame = CGRectMake(210, 560, 100, 30);
  [self.scroller addSubview:saveButton];
  
  [self.scroller setContentSize:CGSizeMake(320, 600)];
  
  UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
  [self.scroller addGestureRecognizer:gestureRecognizer];
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
