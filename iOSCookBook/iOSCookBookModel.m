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
    NSArray *documenPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documenPaths objectAtIndex:0];
    documentsDir = @"/Users/natalie/Desktop/"; //remove later
    self.databasePath = [documentsDir stringByAppendingPathComponent:self.databaseName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //NSLog(databasePath);

    if (![fileManager fileExistsAtPath:self.databasePath]){
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:self.databaseName];
        [fileManager copyItemAtPath:databasePathFromApp toPath:self.databasePath error:nil];
    }
    return self;
}
//SET name=?, quantity=?, photo=?, favourite=?, rating=?, prep_time=?, cook_time=?"

-(void)addRecipe:(Recipe *)r{
    
    sqlite3 *database;
    if (sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK){
        // Add to the recipe table
        const char *addsqlStatement = "INSERT INTO recipes (name, quantity, photo, favourite, rating, prep_time, cook_time) VALUES (?,?,?,?,?,?,?)";
        sqlite3_stmt *compiledStatement;
        int row;
        if (sqlite3_prepare_v2(database, addsqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_text(compiledStatement, 1, [r.name UTF8String], -1, SQLITE_TRANSIENT);
            //sqlite3_bind_text(compiledStatement, 2, [r.category UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(compiledStatement, 2, r.quantity);
            sqlite3_bind_text(compiledStatement, 3, [r.photo UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(compiledStatement, 4, r.favourite);
            sqlite3_bind_int(compiledStatement, 5, r.rating);
            sqlite3_bind_int(compiledStatement, 6, r.prepTime);
            sqlite3_bind_int(compiledStatement, 7, r.cookTime);
            sqlite3_step(compiledStatement);
            sqlite3_reset(compiledStatement);
            
            row = sqlite3_last_insert_rowid(database);
        }
        
        //add to the ingredient table
        sqlite3_reset(compiledStatement);
        sqlite3_clear_bindings(compiledStatement);
        addsqlStatement = "INSERT INTO ingredients (ingredient, ordering, r_id) VALUES (?,?,?)";
        if (sqlite3_prepare_v2(database, addsqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
            for (ingredient *i in r.ingredients){
                sqlite3_bind_text(compiledStatement, 1, [i.name UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_int(compiledStatement, 2, i.order);
                sqlite3_bind_int(compiledStatement, 3, row);
                sqlite3_step(compiledStatement);
                sqlite3_reset(compiledStatement);
             }
        }

        //add to the instruction table
        sqlite3_reset(compiledStatement);
        sqlite3_clear_bindings(compiledStatement);
        addsqlStatement = "INSERT INTO instructions (instruction, ordering, r_id) VALUES (?,?,?)";
        if (sqlite3_prepare_v2(database, addsqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
            for (instruction *i in r.instructions){
                sqlite3_bind_text(compiledStatement, 1, [i.name UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_int(compiledStatement, 2, i.order);
                sqlite3_bind_int(compiledStatement, 3, row);
                sqlite3_step(compiledStatement);
                sqlite3_reset(compiledStatement);
            }
        }
        sqlite3_reset(compiledStatement);
        sqlite3_clear_bindings(compiledStatement);
        addsqlStatement = "INSERT INTO categories (name, r_id) VALUES (?,?)";
        if (sqlite3_prepare_v2(database, addsqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
            for (NSString *c in r.categories){
                sqlite3_bind_text(compiledStatement, 1, [c UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_int(compiledStatement, 2, row);
                sqlite3_step(compiledStatement);
                sqlite3_reset(compiledStatement);
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
}


-(Recipe*)getRecipe:(NSInteger)n{
    sqlite3 *database;
    NSMutableArray *ingredients = [NSMutableArray new];
    NSMutableArray *instructions = [NSMutableArray new];
    NSMutableArray *categories = [NSMutableArray new];
    
    Recipe *r = [Recipe alloc];
    if (sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK){
        const char *sqlStatement = "SELECT ingredient, ordering FROM ingredients WHERE r_id = ?";
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
        sqlStatement = "SELECT instruction, ordering FROM instructions WHERE r_id = ?";
        if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
            sqlite3_bind_int(compiledStatement, 1, n);
            while (sqlite3_step(compiledStatement) == SQLITE_ROW){
                
                NSString *i = [NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatement, 0)];
                int o = sqlite3_column_int(compiledStatement, 1);
                instruction *ins = [[instruction alloc] initWithInstruction:i order:o];
                [instructions addObject:ins];
            }
        }
        sqlite3_reset(compiledStatement);
        sqlite3_finalize(compiledStatement);
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
        sqlStatement = "SELECT * FROM recipes WHERE r_id = ?";
        if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
            sqlite3_bind_int(compiledStatement, 1, n);
            while (sqlite3_step(compiledStatement) == SQLITE_ROW){
                
                NSString *name = [NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatement, 1)];
                //NSString *category = [NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatement, 2)];
                int quantity = sqlite3_column_int(compiledStatement, 2);
                NSString *photo = [NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatement, 3)];
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

-(NSMutableArray*)getRecipes{
    NSMutableArray *recipes = [NSMutableArray new];
    return recipes;
}
-(NSMutableArray*)getFavourites{
    NSMutableArray *recipes = [NSMutableArray new];
    return recipes;
}
-(NSMutableArray*)getCategories{
    NSMutableArray *recipes = [NSMutableArray new];
    return recipes;
}

//takes the category name and returns a NSMutableArray of NSArray objects containing the recipe name, id and photo string of all recipes in that category. 
-(NSMutableArray*)getRecipesByCategory:(NSString*)c{
    NSMutableArray *recipes = [NSMutableArray new];
    sqlite3 *database;
    if (sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK){
        const char *sqlStatement = "SELECT recipes.name, recipes.r_id, photo FROM recipes JOIN categories ON recipes.r_id=categories.r_id WHERE categories.name = ?";
        sqlite3_stmt *compiledStatement;
        if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
            sqlite3_bind_text(compiledStatement, 1, [c UTF8String], -1, SQLITE_TRANSIENT);
            while (sqlite3_step(compiledStatement) == SQLITE_ROW){
                NSString *name = [NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatement, 0)];
                
                NSInteger r_id = sqlite3_column_int(compiledStatement, 1);
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
-(void)addPhoto:(NSString*)s{
    
}



@end
