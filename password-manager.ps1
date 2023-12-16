# Modul 129 LB2 - Password Manager Script

# Description:
# PowerShell Password Manager is a simple yet secure password management tool developed in PowerShell. 
# This project provides a command-line interface (CLI) for users to add and retrieve passwords securely stored in an SQLite database. 
# The tool includes features for initializing the database, adding new passwords, and retrieving passwords for specific services.

# Author:
# hpa134085@stud.gibb.ch
# sth134864@stud.gibb.ch

# Date:
# 22. December 2023

# Version
# 1.0.1

# To-Do: 
# Plan the project
# Ablaufdiagramm
# Write the code
# Test the code
# Publish the code

Clear-Host

# Function to create a database connection
function CreateDatabaseConnection {
    Import-Module PSSQLite
    $db = "C:\Users\parwa\Documents\dev\password-manager\password-manager.db"

    $conn = New-SQliteConnection -DataSource $db

    if ($conn.State -eq 'Open') {
        Write-Host "Connection to database established" -ForegroundColor Green
    } else {
        Write-Host "Connection to database failed" -ForegroundColor Red
    } 
}

# Function to create a new login
function CreateLogin {
    param (
        [string]$username,
        [string]$password
    )

    $query = "INSERT INTO Login (username, password) VALUES ('$username', '$password' )"
    Write-Host "Creating login..." -ForegroundColor Green

    Invoke-SqliteQuery -DataSource $db -Query $query

    Write-Host "Login created" -ForegroundColor Green
}

# Function to login
function Login {
    param (
        [string]$username,
        [string]$password
    )
    Write-Host "Logging in..." -ForegroundColor Green
    $query = "SELECT * FROM Login WHERE Username = '$username' AND Password = '$password'"

    if (Invoke-SqliteQuery -DataSource $db -Query $query) {
        Write-Host "Login successful" -ForegroundColor Green
    } else {
        Write-Host "Login failed" -ForegroundColor Red

        $create = Read-Host "Create new login? (y/n)"
        if ($create -eq "y") {
            CreateLogin -username $username -password $password
        } else {
            Write-Host "Login aborted" -ForegroundColor Red
        }
    }
}

# Function to query the database
function QueryDatabase {
    $query = "SELECT * FROM Login"
    Write-Host "Querying database..." -ForegroundColor Green

    $result = Invoke-SqliteQuery -DataSource $db -Query $query

    Write-Host "Query complete" -ForegroundColor Green
    Write-Host "Result:" -ForegroundColor Green
    $result
}

# Function to toggle between tabs
function ToggleTabs {
    if ($activeTab -eq "SignIn") {
        $activeTab = "SignUp"
    } else {
        $activeTab = "SignIn"
    }
}

# Function to show the login GUI
function ShowLoginGui {
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Login"
    $form.Size = New-Object System.Drawing.Size(290,250)
    $form.StartPosition = "CenterScreen"

    $tabControl = New-Object System.Windows.Forms.TabControl
    $tabControl.Size = New-Object System.Drawing.Size(260, 180)
    $form.Controls.Add($tabControl)

    # Sign In Tab
    $tabSignIn = New-Object System.Windows.Forms.TabPage
    $tabSignIn.Text = "Sign In"
    $tabControl.Controls.Add($tabSignIn)

    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10, 20)
    $label.Size = New-Object System.Drawing.Size(260, 20)
    $label.Text = "Username:"
    $tabSignIn.Controls.Add($label)

    $textboxUsername = New-Object System.Windows.Forms.TextBox
    $textboxUsername.Location = New-Object System.Drawing.Point(10, 40)
    $textboxUsername.Size = New-Object System.Drawing.Size(240, 20)
    $tabSignIn.Controls.Add($textboxUsername)

    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10, 70)
    $label.Size = New-Object System.Drawing.Size(260, 20)
    $label.Text = "Password:"
    $tabSignIn.Controls.Add($label)

    $textboxPassword = New-Object System.Windows.Forms.MaskedTextBox
    $textboxPassword.Location = New-Object System.Drawing.Point(10, 90)
    $textboxPassword.Size = New-Object System.Drawing.Size(240, 20)
    $textboxPassword.PasswordChar = '*'
    $tabSignIn.Controls.Add($textboxPassword)

    $buttonSignIn = New-Object System.Windows.Forms.Button
    $buttonSignIn.Location = New-Object System.Drawing.Point(75, 120)
    $buttonSignIn.Size = New-Object System.Drawing.Size(75,23)
    $buttonSignIn.Text = "Sign In"
    $buttonSignIn.Add_Click({
        $username = $textboxUsername.Text
        $password = $textboxPassword.Text
        Login -username $username -password $password
        $form.DialogResult = [System.Windows.Forms.DialogResult]::OK
        $form.Close()
    })
    $tabSignIn.Controls.Add($buttonSignIn)

    # Sign Up Tab
    $tabSignUp = New-Object System.Windows.Forms.TabPage
    $tabSignUp.Text = "Sign Up"
    $tabControl.Controls.Add($tabSignUp)

    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10, 20)
    $label.Size = New-Object System.Drawing.Size(260, 20)
    $label.Text = "New Username:"
    $tabSignUp.Controls.Add($label)

    $textboxNewUsername = New-Object System.Windows.Forms.TextBox
    $textboxNewUsername.Location = New-Object System.Drawing.Point(10, 40)
    $textboxNewUsername.Size = New-Object System.Drawing.Size(240, 20)
    $tabSignUp.Controls.Add($textboxNewUsername)

    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10, 70)
    $label.Size = New-Object System.Drawing.Size(260, 20)
    $label.Text = "New Password:"
    $tabSignUp.Controls.Add($label)

    $textboxNewPassword = New-Object System.Windows.Forms.MaskedTextBox
    $textboxNewPassword.Location = New-Object System.Drawing.Point(10, 90)
    $textboxNewPassword.Size = New-Object System.Drawing.Size(240, 20)
    $textboxNewPassword.PasswordChar = '*'
    $tabSignUp.Controls.Add($textboxNewPassword)

    $buttonSignUp = New-Object System.Windows.Forms.Button
    $buttonSignUp.Location = New-Object System.Drawing.Point(75, 120)
    $buttonSignUp.Size = New-Object System.Drawing.Size(75,23)
    $buttonSignUp.Text = "Sign Up"
    $buttonSignUp.Add_Click({
        $newUsername = $textboxNewUsername.Text
        $newPassword = $textboxNewPassword.Text
        CreateLogin -username $newUsername -password $newPassword
        $form.DialogResult = [System.Windows.Forms.DialogResult]::OK
        $form.Close()
    })
    $tabSignUp.Controls.Add($buttonSignUp)

    $form.Add_Shown({$textboxUsername.Select()})
    $result = $form.ShowDialog()

    if ($result -eq [System.Windows.Forms.DialogResult]::OK)
    {
        # Handle any post-login actions if needed
    }
}

# Main script execution
try {
    # Initialize the database connection
    CreateDatabaseConnection

    # Show the login GUI
    ShowLoginGui
}
catch {
    # Handle exceptions
    Write-Host "An error occurred" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
}
