# RecipeAPI

This is an API for a Recipes service using Flask. Users can register an account and login to create, edit, view and delete recipe categories and recipes in those categories.

Add link to Heroku here

| EndPoint                                          | Functionality                                    |
| ------------------------------------------------- | ------------------------------------------------ |
| [ POST /auth/login/ ](#)                          | Logs a user in                                   |
| [ POST /auth/register/ ](#)                       | Register a user                                  |
| [ DELETE /auth/logout/ ](#)                       | Logout a user                                    |
| [ POST /categories/ ](#)                          | Create a new category                            |
| [ GET /categories/ ](#)                           | Get all categories created by the logged in user |
| [ GET /categories/\<category_id>/ ](#)            | Get a category by it's id                        |
| [ PUT /categories/\<category_id>/ ](#)            | Update the category                              |
| [ DELETE /categories/\<category_id>/ ](#)         | Delete the category                              |
| [ POST /recipes/\<category_id>/ ](#)              | Create a recipe in the specified category        |
| [ GET /recipes/](#)                               | Get all recipes created by the logged in user    |
| [ GET /recipes/\<category_id>/](#)                | Get all recipes in the specified category id     |
| [ GET /recipes/\<category_id>/\<recipe_id>](#)    | Get a recipe in the specified category id        |
| [ PUT /recipes/\<category_id>/<recipe_id> ](#)    | Update the recipe in the specified category id   |
| [ DELETE /recipes/\<category_id>/<recipe_id> ](#) | Delete the recipe in the specified category id   |

## Technology Stack

- Python 3.6
- Flask
- Postgres 9.6

## Setup

To use the application, ensure that you have python 3.6+, clone the repository to your local machine. Open your git commandline and run

1. Clone the repository
   ```bash
    git clone https://Ssemaganda@bitbucket.org/Ssemaganda/recipes.git
   ```

2. Enter the project directory
   ```bash
   cd recipes
   ```
3. Create a virtual environment
   ```bash
   virtualenv venv
   ```
4. Activate the virtual environment
   ```bash
   source venv/bin/activate
   ```
5. Then install all the required dependencies:
   ```bash
   pip install -r requirements.txt
   ```
6. Install postgres if you don't already have it. Preferably Postgres 10.1.

7. Create the Databases

   #### For the test Database
   ```bash
   createdb test_db
   ```

   #### For the development Database
   ```bash
   createdb recipe_db
   ```

8. Set variables
   ```bash
   export SECRET_KEY='<a random character string>'
   export FLASK_CONFIG=development
   export DATABASE_URL='postgresql://localhost/recipe_db'
   ```

9.  Run Migrations using these commands, in that order:
      ```bash
      python manage.py db init
      python manage.py db migrate
      python manage.py db upgrade
      ```

10. To test the application, run the command:
      ```bash
      pytest --cov-report term --cov=app
      ```

11. To start the server, run the command:
      ```bash
      python manage.py runserver
      ```
