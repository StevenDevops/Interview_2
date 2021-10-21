# RecipeAPI

This is an API for a Recipes service using Flask. Users can register an account and login to create, edit, view and delete recipe categories and recipes in those categories.
Clone from:
   ```bash
    git clone https://Ssemaganda@bitbucket.org/Ssemaganda/recipes.git
   ```

# Cobblestone Energy Test
1. Dockerise the app.
   #### Idea  
   Docker-compose is the recommended tool to manage multi-container deployments.
   #### Requirement
   * Docker, docker-compose need tobe installed
   ### How to run the test
   * Run docker-compose: 
       ``` bash
        ❯ docker-compose build
        ❯ docker-compose up -d --force-recreate
        Starting recipes_postgres_1 ... done
        Recreating recipes_api_1    ... done
       ```      
   * Verify the configuration:
   ```bash
   ❯ docker ps                
   CONTAINER ID   IMAGE                    COMMAND                  CREATED             STATUS         PORTS                                       NAMES
   f4bb80291ddd   recipes_api              "/bin/bash entrypoin…"   7 minutes ago       Up 7 minutes   0.0.0.0:5000->5000/tcp, :::5000->5000/tcp   recipes_api_1
   9801d2623105   postgres:10.1            "docker-entrypoint.s…"   About an hour ago   Up 7 minutes   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   recipes_postgres_1
   ```
  * Test API
  ```bash
  ❯ curl -XPOST 127.0.0.1:5000/api/v1/auth/register/ -d '{"username": "steven_test", "password":"testing", "email":"tuanphan@testmail.com"}' -H "Content-Type: application/json"  
  {
      "message": "Account was successfully created"
  }
  ```
  * Check docker log
  ```bash
   ❯ docker logs recipes_api_1
   * Running on http://0.0.0.0:5000/ (Press CTRL+C to quit)
   * Restarting with stat
   * Debugger is active!
   * Debugger PIN: 331-522-421
  172.18.0.1 - - [20/Oct/2021 11:39:19] "POST /api/v1/auth/register/ HTTP/1.1" 201 -
  ```
