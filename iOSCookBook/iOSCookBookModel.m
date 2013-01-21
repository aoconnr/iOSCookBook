//
//  iOSCookBookModel.m
//  iOSCookBook
//
//  Created by Natalie on 11/01/2013.
//  Copyright (c) 2013 Andrew O'Connor. All rights reserved.
//

#import "iOSCookBookModel.h"


@implementation iOSCookBookModel

@synthesize databaseName, databasePath;

-(id)init{
    self = [super init];
    self.databaseName = @"cookbook.sql";
    
    //gets the path for the documents folder on the device
    NSArray *documenPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documenPaths objectAtIndex:0];
    documentsDir = @"/Users/andrew/Desktop/"; //remove later - currently in for database testing purposes
    self.databasePath = [documentsDir stringByAppendingPathComponent:self.databaseName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //if the database doesn't already exist in the documents folder on the device, copy it there.
    if (![fileManager fileExistsAtPath:self.databasePath]){
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:self.databaseName];
        [fileManager copyItemAtPath:databasePathFromApp toPath:self.databasePath error:nil];
    }
    return self;
}

//takes a Recipe object and adds its details to the database
-(void)addRecipe:(Recipe *)r{
    
    sqlite3 *database;
    if (sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK){

      UIImage *image1 = r.photo;
      NSData *imgData = UIImagePNGRepresentation(image1);
        // Add to the recipe table
        const char *addsqlStatement = "INSERT INTO recipes (name, quantity, photo, favourite, rating, prep_time, cook_time) VALUES (?,?,?,?,?,?,?)";
        sqlite3_stmt *compiledStatement;
        int row;
        if (sqlite3_prepare_v2(database, addsqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_text(compiledStatement, 1, [r.name UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(compiledStatement, 2, r.quantity);
            //sqlite3_bind_text(compiledStatement, 3, [r.photo UTF8String], -1, SQLITE_TRANSIENT);
            if(imgData != nil){
              NSLog(@"added");
              sqlite3_bind_blob(compiledStatement, 3, [imgData bytes], [imgData length], NULL);
            }
            else{
              NSLog(@"NOT");
              sqlite3_bind_blob(compiledStatement, 4, nil, -1, NULL);
            }
            sqlite3_bind_int(compiledStatement, 4, r.favourite);
            sqlite3_bind_int(compiledStatement, 5, r.rating);
            sqlite3_bind_int(compiledStatement, 6, r.prepTime);
            sqlite3_bind_int(compiledStatement, 7, r.cookTime);
            sqlite3_step(compiledStatement);
            sqlite3_reset(compiledStatement);
            //get r_id for the recipe
            row = sqlite3_last_insert_rowid(database);
        }
        
        //add to the ingredient table
        sqlite3_clear_bindings(compiledStatement);
        addsqlStatement = "INSERT INTO ingredients (ingredient, ordering, r_id) VALUES (?,?,?)";
        if (sqlite3_prepare_v2(database, addsqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
            
            for (ingredient *i in r.ingredients){
                //add name
                sqlite3_bind_text(compiledStatement, 1, [i.name UTF8String], -1, SQLITE_TRANSIENT);
                //add ordering
                sqlite3_bind_int(compiledStatement, 2, i.order);
                //add r_id
                sqlite3_bind_int(compiledStatement, 3, row);
                sqlite3_step(compiledStatement);
                sqlite3_reset(compiledStatement);
             }
        }

        //add to the instruction table
        sqlite3_clear_bindings(compiledStatement);
        addsqlStatement = "INSERT INTO instructions (instruction, ordering, r_id, timer) VALUES (?,?,?,?)";
        if (sqlite3_prepare_v2(database, addsqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
            
            for (instruction *i in r.instructions){
                //add name
                sqlite3_bind_text(compiledStatement, 1, [i.name UTF8String], -1, SQLITE_TRANSIENT);
                //add ordering
                sqlite3_bind_int(compiledStatement, 2, i.order);
                //add r_id
                sqlite3_bind_int(compiledStatement, 3, row);
                //add timer
                sqlite3_bind_int(compiledStatement, 4, i.timer);

                sqlite3_step(compiledStatement);
                sqlite3_reset(compiledStatement);
            }
        }
        sqlite3_clear_bindings(compiledStatement);
        addsqlStatement = "INSERT INTO categories (name, r_id) VALUES (?,?)";
        if (sqlite3_prepare_v2(database, addsqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
            for (NSString *c in r.categories){
                //add name
                sqlite3_bind_text(compiledStatement, 1, [c UTF8String], -1, SQLITE_TRANSIENT);
                //add r_id
                sqlite3_bind_int(compiledStatement, 2, row);
                sqlite3_step(compiledStatement);
                sqlite3_reset(compiledStatement);
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
}

// takes the recipe id (as an integer) and returns a Recipe object populated with the stored details of the recipe
-(Recipe*)getRecipe:(int)n{
    sqlite3 *database;
    NSMutableArray *ingredients = [NSMutableArray new];
    NSMutableArray *instructions = [NSMutableArray new];
    NSMutableArray *categories = [NSMutableArray new];

    Recipe *r = [Recipe alloc];
    if (sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK){
        
        //get ingredients
        const char *sqlStatement = "SELECT ingredient, ordering FROM ingredients WHERE r_id = ? ORDER BY ordering";
        sqlite3_stmt *compiledStatement;
        if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
            sqlite3_bind_int(compiledStatement, 1, n);
            while (sqlite3_step(compiledStatement) == SQLITE_ROW){
                
                NSString *i = [NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatement, 0)];
                int o = sqlite3_column_int(compiledStatement, 1);               
                ingredient *ing = [[ingredient alloc] initWithIngredient:i order:o];
                [ingredients addObject:ing];
            }
        }
        sqlite3_reset(compiledStatement);
        sqlite3_finalize(compiledStatement);
        
        //get instructions
        sqlStatement = "SELECT instruction, ordering, timer FROM instructions WHERE r_id = ? ORDER BY ordering";
        if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
            sqlite3_bind_int(compiledStatement, 1, n);
            while (sqlite3_step(compiledStatement) == SQLITE_ROW){
                
                NSString *i = [NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatement, 0)];
                int o = sqlite3_column_int(compiledStatement, 1);
                int t = sqlite3_column_int(compiledStatement, 2);
                instruction *ins = [[instruction alloc] initWithInstruction:i order:o timer:t];
                [instructions addObject:ins];
            }
        }
        sqlite3_reset(compiledStatement);
        sqlite3_finalize(compiledStatement);
        
        //get categories
        sqlStatement = "SELECT name FROM categories WHERE r_id = ?";
        if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
            sqlite3_bind_int(compiledStatement, 1, n);
            while (sqlite3_step(compiledStatement) == SQLITE_ROW){
                
                NSString *c = [NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatement, 0)];
                [categories addObject:c];
            }
        }
        sqlite3_reset(compiledStatement);
        sqlite3_finalize(compiledStatement);
        
        //get Recipe details
        sqlStatement = "SELECT * FROM recipes WHERE r_id = ?";
        if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
            sqlite3_bind_int(compiledStatement, 1, n);
            while (sqlite3_step(compiledStatement) == SQLITE_ROW){
                
                // gets recipe details and creates a recipe
                NSString *name = [NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatement, 1)];
                int quantity = sqlite3_column_int(compiledStatement, 2);
                //NSString *photo = [NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatement, 3)];
              NSData *data = [[NSData alloc] initWithBytes:sqlite3_column_blob(compiledStatement, 3) length:sqlite3_column_bytes(compiledStatement, 3)];
              UIImage *photo;
              if(data == nil){
                NSLog(@"No image found.");
              photo = [UIImage imageNamed:@"DefaultRecipePic.gif"];
              }
              else{
                photo = [UIImage imageWithData:data];
              }
                int favourite = sqlite3_column_int(compiledStatement, 4);
                int rating = sqlite3_column_int(compiledStatement, 5);
                int prep = sqlite3_column_int(compiledStatement, 6);
                int cook = sqlite3_column_int(compiledStatement, 7);
                r = [r initWithrId:n name:name categories:categories quantity:quantity photo:photo favourite:favourite rating:rating prep:prep cook:cook instructions:instructions ingredients:ingredients];
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    return r;
}


-(NSMutableArray*)getFavourites{
    NSMutableArray *recipes = [NSMutableArray new];
    sqlite3 *database;
    if (sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK){
        
        //get all recipes from db which have been set as a favourite
        const char *sqlStatement = "SELECT name, r_id, photo FROM recipes WHERE favourite=1 ORDER BY name";
        sqlite3_stmt *compiledStatement;
        if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
            
            while (sqlite3_step(compiledStatement) == SQLITE_ROW){
                //get recipe name
                NSString *name = [NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatement, 0)];
                //get r_id
                NSInteger r_id = sqlite3_column_int(compiledStatement, 1);
                //get photo name
                //NSString *photo = [NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatement, 2)];
              NSData *data = [[NSData alloc] initWithBytes:sqlite3_column_blob(compiledStatement, 3) length:sqlite3_column_bytes(compiledStatement, 3)];
              UIImage *photo;
              if(data == nil){
                NSLog(@"No image found.");
                photo = [UIImage imageNamed:@"DefaultRecipePic.gif"];
              }
              else{
                photo = [UIImage imageWithData:data];
              }
                //fill array with recipe info
                NSArray *a = [NSArray arrayWithObjects:name, [NSNumber numberWithInt:r_id], photo, nil];
                //add array to array to be returned
                [recipes addObject:a];
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    return recipes;
}

//takes the category name and returns a NSMutableArray of NSArray objects containing the recipe name, id and photo string of all recipes in that category. 
-(NSMutableArray*)getRecipesByCategory:(NSString*)c{
    NSMutableArray *recipes = [NSMutableArray new];
    sqlite3 *database;
    if (sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK){
        
        // find recipes in given category
        const char *sqlStatement = "SELECT recipes.name, recipes.r_id, photo FROM recipes JOIN categories ON recipes.r_id=categories.r_id WHERE categories.name = ?";
        sqlite3_stmt *compiledStatement;
        if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
            sqlite3_bind_text(compiledStatement, 1, [c UTF8String], -1, SQLITE_TRANSIENT);

            while (sqlite3_step(compiledStatement) == SQLITE_ROW){
                //get recipe name
                NSString *name = [NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatement, 0)];
                //get r_id                
                int r_id = sqlite3_column_int(compiledStatement, 1);
                //get photo name
                NSString *photo = [NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatement, 2)];
                NSArray *a = [NSArray arrayWithObjects:name, [NSNumber numberWithInt:r_id], photo, nil];
                [recipes addObject:a];
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    return recipes;
}

//takes a photo url/name/string and a recipe id and adds the photo to the recipe in the database
-(void)addPhoto:(NSString*)s toRecipe:(int)r{
    
    sqlite3 *database;
    if (sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK){
        // Add to the recipe table
        const char *addsqlStatement = "UPDATE recipes SET photo=? WHERE r_id=?";
        sqlite3_stmt *compiledStatement;
        if (sqlite3_prepare_v2(database, addsqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_text(compiledStatement, 1, [s UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(compiledStatement, 2, r);
            sqlite3_step(compiledStatement);
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
}


//returns a list of all the category names in the db
-(NSMutableArray*)getCategories{
    NSMutableArray *categories = [NSMutableArray new];
    sqlite3 *database;
    if (sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK){
        const char *sqlStatement = "SELECT DISTINCT name FROM categories ORDER BY name";
        sqlite3_stmt *compiledStatement;
        
        if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
            while (sqlite3_step(compiledStatement) == SQLITE_ROW){

                //get category name
                NSString *name = [NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatement, 0)];
                [categories addObject:name];
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    return categories;
}

//takes a recipe id and removes all references of the recipe with that id from the database.
-(void)deleteRecipe:(int)r{
    sqlite3 *database;
    if (sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK){
        // Delete from the recipe table
        const char *addsqlStatement = "DELETE FROM recipes WHERE r_id=?";
        sqlite3_stmt *compiledStatement;
        if (sqlite3_prepare_v2(database, addsqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_int(compiledStatement, 1, r);
            sqlite3_step(compiledStatement);
            sqlite3_reset(compiledStatement);
        }
        
        //Delete from the ingredient table
        sqlite3_clear_bindings(compiledStatement);
        addsqlStatement = "DELETE FROM ingredients WHERE r_id=?";
        if (sqlite3_prepare_v2(database, addsqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){

            sqlite3_bind_int(compiledStatement, 1, r);
            sqlite3_step(compiledStatement);
            sqlite3_reset(compiledStatement);
        }
        
        //Delete from the instruction table
        sqlite3_clear_bindings(compiledStatement);
        addsqlStatement = "DELETE FROM instructions WHERE r_id=?";
        if (sqlite3_prepare_v2(database, addsqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
            sqlite3_bind_int(compiledStatement, 1, r);
            sqlite3_step(compiledStatement);
            sqlite3_reset(compiledStatement);
        }
        //delet from tge categories table
        sqlite3_clear_bindings(compiledStatement);
        addsqlStatement = "DELETE FROM categories WHERE r_id=?";
        if (sqlite3_prepare_v2(database, addsqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
            sqlite3_bind_int(compiledStatement, 1, r);
            sqlite3_step(compiledStatement);
            sqlite3_reset(compiledStatement);
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
}

//takes a recipe id and a boolean value and sets the favourite attribute in the database of the recipe to the boolean value
-(void)setFavouriteForRecipeID:(int)rid to:(Boolean)b{
    sqlite3 *database;
    if (sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK){
        const char *sqlStatement = "UPDATE recipes SET favourite=? WHERE r_id=?";
        sqlite3_stmt *compiledStatement;
        
        if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
            sqlite3_bind_int(compiledStatement, 1, b);
            sqlite3_bind_int(compiledStatement, 2, rid);
            sqlite3_step(compiledStatement);
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);    
}

//takes a recipe id and a rating integer from 0-5 and sets the rating attribute in the database of the recipe to given value
-(void)setRatingForRecipeID:(int)rid to:(int)r{
    sqlite3 *database;
    if (sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK){
        const char *sqlStatement = "UPDATE recipes SET rating=? WHERE r_id=?";
        sqlite3_stmt *compiledStatement;
        
        if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
            sqlite3_bind_int(compiledStatement, 1, r);
            sqlite3_bind_int(compiledStatement, 2, rid);
            sqlite3_step(compiledStatement);
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
}
@end
