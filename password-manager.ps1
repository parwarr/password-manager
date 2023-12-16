<# 
   Modul 129 LB2 - Password Manager Script


   Description:
   PowerShell Password Manager is a simple yet secure password management tool developed in PowerShell. 
   This project provides a command-line interface (CLI) for users to add and retrieve passwords securely stored in an SQLite database. 
   The tool includes features for initializing the database, adding new passwords, and retrieving passwords for specific services.
    

   Author:
   hpa134085@stud.gibb.ch
   sth134864@stud.gibb.ch

   Date:
   22. December 2023

   Version
   1.0.1

   To-Do: 
   Plan the project
   Ablaufdiagramm
   Write the code
   Test the code
   Publish the code

   #>

   Clear-Host



   function CreateConnection {
   Import-Module PSSQLite
   $db = "C:\Users\parwa\Documents\dev\password-manager\password-manager.db"

   $conn = New-SQliteConnection -DataSource $db

   if ($conn.State -eq 'Open') {
      Write-Host "Connection to database established" -ForegroundColor Green
   } else {
      Write-Host "Connection to database failed" -ForegroundColor Red
   }
      
   }

   function QueryDatabase {
   $query = "SELECT * FROM Login"
   Write-Host "Querying database..." -ForegroundColor Green

   $result = Invoke-SqliteQuery -DataSource $db -Query $query

   Write-Host "Query complete" -ForegroundColor Green
   Write-Host "Result:" -ForegroundColor Green
   $result
   }

   CreateConnection
   QueryDatabase


