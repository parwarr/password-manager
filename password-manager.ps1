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

Clear-Host

# Import the PSSQLite module
Import-Module PSSQLite

# Set Database Path
$db = "C:\Users\parwa\Documents\dev\password-manager\password-manager.db"

# Global variable to store the logged-in user ID
$global:loggedInUserId = $null

$conn = New-SQliteConnection -DataSource $db

# Function to create a database connection
function CreateDatabaseConnection {
    if ($conn.State -eq 'Open') {
        Write-Host "Connection to database established" -ForegroundColor Green
    } else {
        Write-Host "Connection to database failed" -ForegroundColor Red
    } 
}

# Function to create a new login
# TODO: fix the create login function
function CreateLogin {
    param (
        [string]$username,
        [string]$password
    )
    
    Write-Host "Creating user..." -ForegroundColor Green

    # Check if the user already exists
    $checkUserQuery = "SELECT * FROM Login WHERE Username = '$username'"
    $existingUser = Invoke-SqliteQuery -DataSource $db -Query $checkUserQuery

    if ($existingUser) {
        Write-Host "User already exists. Choose a different username." -ForegroundColor Red
        return
    }

    # If the user doesn't exist, create a new user
    $createUserQuery = "INSERT INTO Login (Username, Password) VALUES ('$username', '$password')"
    $createdUser = Invoke-SqliteNonQuery -DataSource $db -Query $createUserQuery

    if ($createdUser -eq 1) {
        Write-Host "User creation successful" -ForegroundColor Green
    } else {
        Write-Host "User creation failed" -ForegroundColor Red
    }
}


# Function to login
function Login {
    param (
        [string]$username,
        [string]$password
    )
        Write-Host "Logging in..." -ForegroundColor Green
        $query = "SELECT * FROM Login WHERE Username = '$username' AND Password = '$password'"
        $result = Invoke-SqliteQuery -DataSource $db -Query $query

        if ($result) {
            $global:loggedInUserId = $result.Id
            Write-Host "Login successful" -ForegroundColor Green
            return
        } else {
            Write-Host "Login failed" -ForegroundColor Red
        }

}

# Function to add an entry
function AddEntry {
    param (
        [string]$title,
        [string]$email,
        [string]$username,
        [string]$password,
        [string]$notes,
        [string]$url,
        [string]$tags
    )

    if (-not $global:loggedInUserId) {
        Write-Host "Error: User not logged in. Please log in first." -ForegroundColor Red
        return
    }

    $query = @"
    INSERT INTO PasswortManager (Titel, Email, Username, Password, Notes, Url, Tags, LoginId)
    VALUES ('$title', '$email', '$username', '$password', '$notes', '$url', '$tags', '$global:loggedInUserId')
"@

    try {
        Invoke-SqliteQuery -DataSource $db -Query $query
        Write-Host "Entry added" -ForegroundColor Green
    } catch {
        Write-Host "Error: $_" -ForegroundColor Red
    }
}

# Function to show the login GUI
function ShowLoginGui {
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Login"
    $form.Size = New-Object System.Drawing.Size(290, 250)
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
    $buttonSignIn.Size = New-Object System.Drawing.Size(75, 23)
    $buttonSignIn.Text = "Sign In"
    $buttonSignIn.Add_Click({
        $username = $textboxUsername.Text
        $password = $textboxPassword.Text
        Login -username $username -password $password

        if (-not $global:loggedInUserId) {
            $retry = [System.Windows.Forms.MessageBox]::Show("Login failed. Retry?", "Retry", [System.Windows.Forms.MessageBoxButtons]::RetryCancel, [System.Windows.Forms.MessageBoxIcon]::Error)

            if ($retry -eq [System.Windows.Forms.DialogResult]::Cancel) {
                $form.Close()
                exit 1
            }
        } else {
            $form.DialogResult = [System.Windows.Forms.DialogResult]::OK
            $form.Close()
            ShowPasswordManagerGui
        }
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
    $buttonSignUp.Size = New-Object System.Drawing.Size(75, 23)
    $buttonSignUp.Text = "Sign Up"
    $buttonSignUp.Add_Click({
        $newUsername = $textboxNewUsername.Text
        $newPassword = $textboxNewPassword.Text
        CreateLogin -username $newUsername -password $newPassword

        if (-not $global:loggedInUserId) {
            $retry = [System.Windows.Forms.MessageBox]::Show("Login failed. Retry?", "Retry", [System.Windows.Forms.MessageBoxButtons]::RetryCancel, [System.Windows.Forms.MessageBoxIcon]::Error)

            if ($retry -eq [System.Windows.Forms.DialogResult]::Cancel) {
                $form.Close()
                exit 1
            }
        } else {
            $form.DialogResult = [System.Windows.Forms.DialogResult]::OK
            $form.Close()
            ShowPasswordManagerGui
        }
    })
    $tabSignUp.Controls.Add($buttonSignUp)

    $form.Add_Shown({$textboxUsername.Select()})
    $result = $form.ShowDialog()

    if ($result -eq [System.Windows.Forms.DialogResult]::OK -and -not $global:loggedInUserId) {
        # Show the login window only if login was unsuccessful
        ShowLoginGui
    }
}


# Function to show the password manager GUI
function ShowPasswordManagerGui {
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Password Manager"
    $form.Size = New-Object System.Drawing.Size(400, 300)
    $form.StartPosition = "CenterScreen"

    $labelTitle = New-Object System.Windows.Forms.Label
    $labelTitle.Location = New-Object System.Drawing.Point(10, 20)
    $labelTitle.Size = New-Object System.Drawing.Size(120, 20)
    $labelTitle.Text = "Title:"
    $form.Controls.Add($labelTitle)

    $textboxTitle = New-Object System.Windows.Forms.TextBox
    $textboxTitle.Location = New-Object System.Drawing.Point(140, 20)
    $textboxTitle.Size = New-Object System.Drawing.Size(200, 20)
    $form.Controls.Add($textboxTitle)

    $labelEmail = New-Object System.Windows.Forms.Label
    $labelEmail.Location = New-Object System.Drawing.Point(10, 50)
    $labelEmail.Size = New-Object System.Drawing.Size(120, 20)
    $labelEmail.Text = "Email:"
    $form.Controls.Add($labelEmail)

    $textboxEmail = New-Object System.Windows.Forms.TextBox
    $textboxEmail.Location = New-Object System.Drawing.Point(140, 50)
    $textboxEmail.Size = New-Object System.Drawing.Size(200, 20)
    $form.Controls.Add($textboxEmail)

    $labelUsername = New-Object System.Windows.Forms.Label
    $labelUsername.Location = New-Object System.Drawing.Point(10, 80)
    $labelUsername.Size = New-Object System.Drawing.Size(120, 20)
    $labelUsername.Text = "Username:"
    $form.Controls.Add($labelUsername)

    $textboxUsername = New-Object System.Windows.Forms.TextBox
    $textboxUsername.Location = New-Object System.Drawing.Point(140, 80)
    $textboxUsername.Size = New-Object System.Drawing.Size(200, 20)
    $form.Controls.Add($textboxUsername)

    $labelPassword = New-Object System.Windows.Forms.Label
    $labelPassword.Location = New-Object System.Drawing.Point(10, 110)
    $labelPassword.Size = New-Object System.Drawing.Size(120, 20)
    $labelPassword.Text = "Password:"
    $form.Controls.Add($labelPassword)

    $textboxPassword = New-Object System.Windows.Forms.TextBox
    $textboxPassword.Location = New-Object System.Drawing.Point(140, 110)
    $textboxPassword.Size = New-Object System.Drawing.Size(200, 20)
    $form.Controls.Add($textboxPassword)

    $labelNotes = New-Object System.Windows.Forms.Label
    $labelNotes.Location = New-Object System.Drawing.Point(10, 140)
    $labelNotes.Size = New-Object System.Drawing.Size(120, 20)
    $labelNotes.Text = "Notes:"
    $form.Controls.Add($labelNotes)

    $textboxNotes = New-Object System.Windows.Forms.TextBox
    $textboxNotes.Location = New-Object System.Drawing.Point(140, 140)
    $textboxNotes.Size = New-Object System.Drawing.Size(200, 20)
    $form.Controls.Add($textboxNotes)

    $labelUrl = New-Object System.Windows.Forms.Label
    $labelUrl.Location = New-Object System.Drawing.Point(10, 170)
    $labelUrl.Size = New-Object System.Drawing.Size(120, 20)
    $labelUrl.Text = "URL:"
    $form.Controls.Add($labelUrl)

    $textboxUrl = New-Object System.Windows.Forms.TextBox
    $textboxUrl.Location = New-Object System.Drawing.Point(140, 170)
    $textboxUrl.Size = New-Object System.Drawing.Size(200, 20)
    $form.Controls.Add($textboxUrl)

    $labelTags = New-Object System.Windows.Forms.Label
    $labelTags.Location = New-Object System.Drawing.Point(10, 200)
    $labelTags.Size = New-Object System.Drawing.Size(120, 20)
    $labelTags.Text = "Tags:"
    $form.Controls.Add($labelTags)

    $textboxTags = New-Object System.Windows.Forms.TextBox
    $textboxTags.Location = New-Object System.Drawing.Point(140, 200)
    $textboxTags.Size = New-Object System.Drawing.Size(200, 20)
    $form.Controls.Add($textboxTags)

    $buttonAddEntry = New-Object System.Windows.Forms.Button
    $buttonAddEntry.Location = New-Object System.Drawing.Point(150, 240)
    $buttonAddEntry.Size = New-Object System.Drawing.Size(100, 30)
    $buttonAddEntry.Text = "Add Entry"
    $buttonAddEntry.Add_Click({
        $title = $textboxTitle.Text
        $email = $textboxEmail.Text
        $username = $textboxUsername.Text
        $password = $textboxPassword.Text  # Get the password value
        $notes = $textboxNotes.Text
        $url = $textboxUrl.Text
        $tags = $textboxTags.Text
        AddEntry -title $title -email $email -username $username -password $password -notes $notes -url $url -tags $tags

        # Clear the input fields
        $textboxTitle.Text = ""
        $textboxEmail.Text = ""
        $textboxUsername.Text = ""
        $textboxPassword.Text = ""  # Clear the password field
        $textboxNotes.Text = ""
        $textboxUrl.Text = ""
        $textboxTags.Text = ""
    })
    $form.Controls.Add($buttonAddEntry)

    # Logout button
    $buttonLogout = New-Object System.Windows.Forms.Button
    $buttonLogout.Location = New-Object System.Drawing.Point(270, 240)
    $buttonLogout.Size = New-Object System.Drawing.Size(100, 30)
    $buttonLogout.Text = "Logout"
    $buttonLogout.Add_Click({
        $form.DialogResult = 'OK'
    })
    $form.Controls.Add($buttonLogout)

    $result = $form.ShowDialog()

    if ($result -eq 'OK') {
        $form.Close()
        ShowLoginGui   # Show the login window
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
