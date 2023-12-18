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
    INSERT INTO PasswortManager (Title, Email, Username, Password, Notes, Url, Tags, LoginId)
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
    $form.Size = New-Object System.Drawing.Size(350, 250)
    $form.StartPosition = "CenterScreen"
    $form.BackColor = [System.Drawing.Color]::FromArgb(255, 34, 35, 38)  

    $tabControl = New-Object System.Windows.Forms.TabControl
    $tabControl.Size = New-Object System.Drawing.Size(320, 180)
    $tabControl.Location = New-Object System.Drawing.Point(10, 10)
    $form.Controls.Add($tabControl)

    # Sign In Tab
    $tabSignIn = New-Object System.Windows.Forms.TabPage
    $tabSignIn.Text = "Sign In"
    $tabSignIn.BackColor = [System.Drawing.Color]::FromArgb(255, 29, 31, 33)  
    $tabSignIn.ForeColor = [System.Drawing.Color]::LightGray
    $tabControl.Controls.Add($tabSignIn)

    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10, 20)
    $label.Size = New-Object System.Drawing.Size(300, 20)
    $label.Text = "Username:"
    $label.ForeColor = [System.Drawing.Color]::LightGray
    $tabSignIn.Controls.Add($label)

    $textboxUsername = New-Object System.Windows.Forms.TextBox
    $textboxUsername.Location = New-Object System.Drawing.Point(10, 40)
    $textboxUsername.Size = New-Object System.Drawing.Size(300, 20)
    $textboxUsername.BackColor = [System.Drawing.Color]::FromArgb(255, 41, 44, 48)  
    $textboxUsername.ForeColor = [System.Drawing.Color]::LightGray
    $tabSignIn.Controls.Add($textboxUsername)

    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10, 70)
    $label.Size = New-Object System.Drawing.Size(300, 20)
    $label.Text = "Password:"
    $label.ForeColor = [System.Drawing.Color]::LightGray
    $tabSignIn.Controls.Add($label)

    $textboxPassword = New-Object System.Windows.Forms.MaskedTextBox
    $textboxPassword.Location = New-Object System.Drawing.Point(10, 90)
    $textboxPassword.Size = New-Object System.Drawing.Size(300, 20)
    $textboxPassword.PasswordChar = '*'
    $textboxPassword.BackColor = [System.Drawing.Color]::FromArgb(255, 41, 44, 48)  
    $textboxPassword.ForeColor = [System.Drawing.Color]::LightGray
    $tabSignIn.Controls.Add($textboxPassword)

    $buttonSignIn = New-Object System.Windows.Forms.Button
    $buttonSignIn.Location = New-Object System.Drawing.Point(120, 120)
    $buttonSignIn.Size = New-Object System.Drawing.Size(80, 30)
    $buttonSignIn.Text = "Sign In"
    $buttonSignIn.BackColor = [System.Drawing.Color]::FromArgb(255, 41, 128, 185)  
    $buttonSignIn.ForeColor = [System.Drawing.Color]::White
    $buttonSignIn.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $buttonSignIn.FlatAppearance.BorderSize = 0
    $buttonSignIn.Add_Click({
        $username = $textboxUsername.Text
        $password = $textboxPassword.Text
        Login -username $username -password $password

        if (-not $global:loggedInUserId) {
            [System.Windows.Forms.MessageBox]::Show("Login failed. Please retry.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
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
    $tabSignUp.BackColor = [System.Drawing.Color]::FromArgb(255, 29, 31, 33)  
    $tabSignUp.ForeColor = [System.Drawing.Color]::LightGray
    $tabControl.Controls.Add($tabSignUp)

    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10, 20)
    $label.Size = New-Object System.Drawing.Size(300, 20)
    $label.Text = "Username:"
    $label.ForeColor = [System.Drawing.Color]::LightGray
    $tabSignUp.Controls.Add($label)

    $textboxNewUsername = New-Object System.Windows.Forms.TextBox
    $textboxNewUsername.Location = New-Object System.Drawing.Point(10, 40)
    $textboxNewUsername.Size = New-Object System.Drawing.Size(300, 20)
    $textboxNewUsername.BackColor = [System.Drawing.Color]::FromArgb(255, 41, 44, 48)  
    $textboxNewUsername.ForeColor = [System.Drawing.Color]::LightGray
    $tabSignUp.Controls.Add($textboxNewUsername)

    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10, 70)
    $label.Size = New-Object System.Drawing.Size(300, 20)
    $label.Text = "Password:"
    $label.ForeColor = [System.Drawing.Color]::LightGray
    $tabSignUp.Controls.Add($label)

    $textboxNewPassword = New-Object System.Windows.Forms.MaskedTextBox
    $textboxNewPassword.Location = New-Object System.Drawing.Point(10, 90)
    $textboxNewPassword.Size = New-Object System.Drawing.Size(300, 20)
    $textboxNewPassword.PasswordChar = '*'
    $textboxNewPassword.BackColor = [System.Drawing.Color]::FromArgb(255, 41, 44, 48)  
    $textboxNewPassword.ForeColor = [System.Drawing.Color]::LightGray
    $tabSignUp.Controls.Add($textboxNewPassword)

    $buttonSignUp = New-Object System.Windows.Forms.Button
    $buttonSignUp.Location = New-Object System.Drawing.Point(120, 120)
    $buttonSignUp.Size = New-Object System.Drawing.Size(80, 30)
    $buttonSignUp.Text = "Sign Up"
    $buttonSignUp.BackColor = [System.Drawing.Color]::FromArgb(255, 26, 188, 156) 
    $buttonSignUp.ForeColor = [System.Drawing.Color]::White
    $buttonSignUp.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $buttonSignUp.FlatAppearance.BorderSize = 0
    $buttonSignUp.Add_Click({
        $newUsername = $textboxNewUsername.Text
        $newPassword = $textboxNewPassword.Text
        CreateLogin -username $newUsername -password $newPassword

        if (-not $global:loggedInUserId) {
            [System.Windows.Forms.MessageBox]::Show("Sign up failed. Please retry.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
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

# Function to view notes with tabs for each entry
function ViewNotes {
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $form = New-Object System.Windows.Forms.Form
    $form.Text = "View Notes"
    $form.Size = New-Object System.Drawing.Size(600, 500)
    $form.StartPosition = "CenterScreen"
    $form.BackColor = [System.Drawing.Color]::FromArgb(255, 34, 35, 38) 

    $tabControl = New-Object System.Windows.Forms.TabControl
    $tabControl.Size = New-Object System.Drawing.Size(580, 300)
    $tabControl.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right
    $tabControl.BackColor = [System.Drawing.Color]::FromArgb(255, 29, 31, 33) 
    $form.Controls.Add($tabControl)

    $deleteTextBox = New-Object System.Windows.Forms.TextBox
    $deleteTextBox.Location = New-Object System.Drawing.Point(20, 350)
    $deleteTextBox.Size = New-Object System.Drawing.Size(200, 30)
    $deleteTextBox.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Left
    $deleteTextBox.Text = "Enter ID to delete or edit"
    $deleteTextBox.ForeColor = [System.Drawing.Color]::White
    $deleteTextBox.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Italic)
    $deleteTextBox.BackColor = [System.Drawing.Color]::FromArgb(255, 29, 31, 33) 
    $deleteTextBox.Add_Enter({
        if ($deleteTextBox.Text -eq "Enter ID to delete or edit") {
            $deleteTextBox.Text = ""
            $deleteTextBox.ForeColor = [System.Drawing.Color]::White
        }
    })
    $form.Controls.Add($deleteTextBox)

    $buttonDelete = New-Object System.Windows.Forms.Button
    $buttonDelete.Location = New-Object System.Drawing.Point(230, 390)
    $buttonDelete.Size = New-Object System.Drawing.Size(100, 30)
    $buttonDelete.Text = "Delete"
    $buttonDelete.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Left
    $buttonDelete.BackColor = [System.Drawing.Color]::FromArgb(255, 192, 57, 43)  
    $buttonDelete.ForeColor = [System.Drawing.Color]::White
    $buttonDelete.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Bold)
    $buttonDelete.Add_Click({
        $deleteId = $deleteTextBox.Text
        foreach ($entry in $entriesResult) {
            if ($deleteId -eq $entry.ID) {
                # Delete the entire row from the database using the ID
                $deleteQuery = "DELETE FROM PasswortManager WHERE Id = '$deleteId'"
                Invoke-SqliteQuery -DataSource $db -Query $deleteQuery

                # Remove the tab from the window
                $tabControl.TabPages.RemoveByKey("$deleteId")
                return
            }
        }
        Write-Host "Invalid ID. Deletion canceled."
    })
    $form.Controls.Add($buttonDelete)

    # New button for editing notes
    $buttonEdit = New-Object System.Windows.Forms.Button
    $buttonEdit.Location = New-Object System.Drawing.Point(230, 350)
    $buttonEdit.Size = New-Object System.Drawing.Size(100, 30)
    $buttonEdit.Text = "Edit"
    $buttonEdit.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Left
    $buttonEdit.BackColor = [System.Drawing.Color]::FromArgb(255, 41, 128, 185)  
    $buttonEdit.ForeColor = [System.Drawing.Color]::White
    $buttonEdit.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Bold)
    $buttonEdit.Add_Click({
        $editId = $deleteTextBox.Text
        foreach ($entry in $entriesResult) {
            if ($editId -eq $entry.ID) {
                # Open a new form for editing the selected note
                EditNoteForm $entry

                # Close the current form
                $form.Close()

                # Re-open the form to refresh entries
                ViewNotes

                return
            }
        }
        Write-Host "Invalid ID. Editing canceled."
    })
    $form.Controls.Add($buttonEdit)

    # Fetch entries associated with the user's loginId
    $entriesQuery = "SELECT * FROM PasswortManager WHERE LoginId = '$global:loggedInUserId'"
    $entriesResult = Invoke-SqliteQuery -DataSource $db -Query $entriesQuery

    foreach ($entry in $entriesResult) {
        $tabPage = New-Object System.Windows.Forms.TabPage
        $tabPage.Name = "$($entry.ID)"
        $tabPage.Text = "$($entry.Title)"
        $tabPage.BackColor = [System.Drawing.Color]::FromArgb(255, 41, 128, 185) 
        $tabPage.ForeColor = [System.Drawing.Color]::White
        $tabPage.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Bold)
        $tabControl.Controls.Add($tabPage)

        $textboxNotes = New-Object System.Windows.Forms.TextBox
        $textboxNotes.Location = New-Object System.Drawing.Point(10, 20)
        $textboxNotes.Size = New-Object System.Drawing.Size(560, 250)
        $textboxNotes.Multiline = $true
        $textboxNotes.ReadOnly = $true
        $textboxNotes.BackColor = [System.Drawing.Color]::FromArgb(255, 52, 73, 94) 
        $textboxNotes.ForeColor = [System.Drawing.Color]::White
        $textboxNotes.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Regular)
        $tabPage.Controls.Add($textboxNotes)

        # Display details of the entry
        $textboxNotes.Text = @"
Title: $($entry.Title)
Email: $($entry.Email)
Username: $($entry.Username)
Password: $($entry.Password)
Notes: $($entry.Notes)
URL: $($entry.Url)
Tags: $($entry.Tags)
ID: $($entry.ID)
"@
    }

    $buttonClose = New-Object System.Windows.Forms.Button
    $buttonClose.Location = New-Object System.Drawing.Point(350, 350)
    $buttonClose.Size = New-Object System.Drawing.Size(100, 30)
    $buttonClose.Text = "Close"
    $buttonClose.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right
    $buttonClose.BackColor = [System.Drawing.Color]::FromArgb(255, 41, 128, 185)  
    $buttonClose.ForeColor = [System.Drawing.Color]::White
    $buttonClose.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Bold)
    $buttonClose.Add_Click({
        $form.Close()
    })
    $form.Controls.Add($buttonClose)

    $form.ShowDialog() | Out-Null
}

# Function to create a form for editing notes
function EditNoteForm {
    param (
        [Object]$entry
    )

    $editForm = New-Object System.Windows.Forms.Form
    $editForm.Text = "Edit Note"
    $editForm.Size = New-Object System.Drawing.Size(400, 400)
    $editForm.StartPosition = "CenterScreen"
    $editForm.BackColor = [System.Drawing.Color]::FromArgb(255, 34, 35, 38) 

    # Add controls (textboxes, labels, buttons, etc.) for editing notes

    $labelTitle = New-Object System.Windows.Forms.Label
    $labelTitle.Text = "Title:"
    $labelTitle.Location = New-Object System.Drawing.Point(20, 20)
    $labelTitle.Size = New-Object System.Drawing.Size(100, 20)
    $labelTitle.ForeColor = [System.Drawing.Color]::White
    $editForm.Controls.Add($labelTitle)

    $textboxTitle = New-Object System.Windows.Forms.TextBox
    $textboxTitle.Location = New-Object System.Drawing.Point(150, 20)
    $textboxTitle.Size = New-Object System.Drawing.Size(200, 20)
    $textboxTitle.Text = $entry.Title
    $editForm.Controls.Add($textboxTitle)

    $labelEmail = New-Object System.Windows.Forms.Label
    $labelEmail.Text = "Email:"
    $labelEmail.Location = New-Object System.Drawing.Point(20, 60)
    $labelEmail.Size = New-Object System.Drawing.Size(100, 20)
    $labelEmail.ForeColor = [System.Drawing.Color]::White
    $editForm.Controls.Add($labelEmail)

    $textboxEmail = New-Object System.Windows.Forms.TextBox
    $textboxEmail.Location = New-Object System.Drawing.Point(150, 60)
    $textboxEmail.Size = New-Object System.Drawing.Size(200, 20)
    $textboxEmail.Text = $entry.Email
    $editForm.Controls.Add($textboxEmail)

    $labelUsername = New-Object System.Windows.Forms.Label
    $labelUsername.Text = "Username:"
    $labelUsername.Location = New-Object System.Drawing.Point(20, 100)
    $labelUsername.Size = New-Object System.Drawing.Size(100, 20)
    $labelUsername.ForeColor = [System.Drawing.Color]::White
    $editForm.Controls.Add($labelUsername)

    $textboxUsername = New-Object System.Windows.Forms.TextBox
    $textboxUsername.Location = New-Object System.Drawing.Point(150, 100)
    $textboxUsername.Size = New-Object System.Drawing.Size(200, 20)
    $textboxUsername.Text = $entry.Username
    $editForm.Controls.Add($textboxUsername)

    $labelPassword = New-Object System.Windows.Forms.Label
    $labelPassword.Text = "Password:"
    $labelPassword.Location = New-Object System.Drawing.Point(20, 140)
    $labelPassword.Size = New-Object System.Drawing.Size(100, 20)
    $labelPassword.ForeColor = [System.Drawing.Color]::White
    $editForm.Controls.Add($labelPassword)

    $textboxPassword = New-Object System.Windows.Forms.TextBox
    $textboxPassword.Location = New-Object System.Drawing.Point(150, 140)
    $textboxPassword.Size = New-Object System.Drawing.Size(200, 20)
    $textboxPassword.Text = $entry.Password
    $editForm.Controls.Add($textboxPassword)

    $labelNotes = New-Object System.Windows.Forms.Label
    $labelNotes.Text = "Notes:"
    $labelNotes.Location = New-Object System.Drawing.Point(20, 180)
    $labelNotes.Size = New-Object System.Drawing.Size(100, 20)
    $labelNotes.ForeColor = [System.Drawing.Color]::White
    $editForm.Controls.Add($labelNotes)

    $textboxNotes = New-Object System.Windows.Forms.TextBox
    $textboxNotes.Location = New-Object System.Drawing.Point(150, 180)
    $textboxNotes.Size = New-Object System.Drawing.Size(200, 80)
    $textboxNotes.Multiline = $true
    $textboxNotes.Text = $entry.Notes
    $editForm.Controls.Add($textboxNotes)

    $labelURL = New-Object System.Windows.Forms.Label
    $labelURL.Text = "URL:"
    $labelURL.Location = New-Object System.Drawing.Point(20, 280)
    $labelURL.Size = New-Object System.Drawing.Size(100, 20)
    $labelURL.ForeColor = [System.Drawing.Color]::White
    $editForm.Controls.Add($labelURL)

    $textboxURL = New-Object System.Windows.Forms.TextBox
    $textboxURL.Location = New-Object System.Drawing.Point(150, 280)
    $textboxURL.Size = New-Object System.Drawing.Size(200, 20)
    $textboxURL.Text = $entry.URL
    $editForm.Controls.Add($textboxURL)

    $labelTags = New-Object System.Windows.Forms.Label
    $labelTags.Text = "Tags:"
    $labelTags.Location = New-Object System.Drawing.Point(20, 320)
    $labelTags.Size = New-Object System.Drawing.Size(100, 20)
    $labelTags.ForeColor = [System.Drawing.Color]::White
    $editForm.Controls.Add($labelTags)

    $textboxTags = New-Object System.Windows.Forms.TextBox
    $textboxTags.Location = New-Object System.Drawing.Point(150, 320)
    $textboxTags.Size = New-Object System.Drawing.Size(200, 20)
    $textboxTags.Text = $entry.Tags
    $editForm.Controls.Add($textboxTags)

    $buttonSave = New-Object System.Windows.Forms.Button
    $buttonSave.Location = New-Object System.Drawing.Point(150, 360)
    $buttonSave.Size = New-Object System.Drawing.Size(100, 30)
    $buttonSave.Text = "Save"
    $buttonSave.BackColor = [System.Drawing.Color]::FromArgb(255, 41, 128, 185)  
    $buttonSave.ForeColor = [System.Drawing.Color]::White
    $buttonSave.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Bold)
    $buttonSave.Add_Click({
        # Save the edited note to the database
        $editedEntry = @{
            'Title'    = $textboxTitle.Text
            'Email'    = $textboxEmail.Text
            'Username' = $textboxUsername.Text
            'Password' = $textboxPassword.Text
            'Notes'    = $textboxNotes.Text
            'URL'      = $textboxURL.Text
            'Tags'     = $textboxTags.Text
        }

        $updateQuery = "UPDATE PasswortManager SET Title = '$($editedEntry.Title)', Email = '$($editedEntry.Email)', Username = '$($editedEntry.Username)', Password = '$($editedEntry.Password)', Notes = '$($editedEntry.Notes)', URL = '$($editedEntry.URL)', Tags = '$($editedEntry.Tags)' WHERE Id = '$($entry.ID)'"

        Invoke-SqliteQuery -DataSource $db -Query $updateQuery

        $editForm.Close()
    })
    $editForm.Controls.Add($buttonSave)

    $editForm.ShowDialog() | Out-Null
}


# Function to show the password manager GUI
function ShowPasswordManagerGui {
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Password Manager"
    $form.Size = New-Object System.Drawing.Size(400, 350)
    $form.StartPosition = "CenterScreen"
    $form.BackColor = [System.Drawing.Color]::FromArgb(255, 34, 35, 38) 

    $labelTitle = New-Object System.Windows.Forms.Label
    $labelTitle.Location = New-Object System.Drawing.Point(10, 20)
    $labelTitle.Size = New-Object System.Drawing.Size(120, 20)
    $labelTitle.Text = "Title:"
    $labelTitle.ForeColor = [System.Drawing.Color]::White
    $form.Controls.Add($labelTitle)

    $textboxTitle = New-Object System.Windows.Forms.TextBox
    $textboxTitle.Location = New-Object System.Drawing.Point(140, 20)
    $textboxTitle.Size = New-Object System.Drawing.Size(200, 20)
    $form.Controls.Add($textboxTitle)

    $labelEmail = New-Object System.Windows.Forms.Label
    $labelEmail.Location = New-Object System.Drawing.Point(10, 50)
    $labelEmail.Size = New-Object System.Drawing.Size(120, 20)
    $labelEmail.Text = "Email:"
    $labelEmail.ForeColor = [System.Drawing.Color]::White
    $form.Controls.Add($labelEmail)

    $textboxEmail = New-Object System.Windows.Forms.TextBox
    $textboxEmail.Location = New-Object System.Drawing.Point(140, 50)
    $textboxEmail.Size = New-Object System.Drawing.Size(200, 20)
    $form.Controls.Add($textboxEmail)

    $labelUsername = New-Object System.Windows.Forms.Label
    $labelUsername.Location = New-Object System.Drawing.Point(10, 80)
    $labelUsername.Size = New-Object System.Drawing.Size(120, 20)
    $labelUsername.Text = "Username:"
    $labelUsername.ForeColor = [System.Drawing.Color]::White
    $form.Controls.Add($labelUsername)

    $textboxUsername = New-Object System.Windows.Forms.TextBox
    $textboxUsername.Location = New-Object System.Drawing.Point(140, 80)
    $textboxUsername.Size = New-Object System.Drawing.Size(200, 20)
    $form.Controls.Add($textboxUsername)

    $labelPassword = New-Object System.Windows.Forms.Label
    $labelPassword.Location = New-Object System.Drawing.Point(10, 110)
    $labelPassword.Size = New-Object System.Drawing.Size(120, 20)
    $labelPassword.Text = "Password:"
    $labelPassword.ForeColor = [System.Drawing.Color]::White
    $form.Controls.Add($labelPassword)

    $textboxPassword = New-Object System.Windows.Forms.TextBox
    $textboxPassword.Location = New-Object System.Drawing.Point(140, 110)
    $textboxPassword.Size = New-Object System.Drawing.Size(200, 20)
    $form.Controls.Add($textboxPassword)

    $labelNotes = New-Object System.Windows.Forms.Label
    $labelNotes.Location = New-Object System.Drawing.Point(10, 140)
    $labelNotes.Size = New-Object System.Drawing.Size(120, 20)
    $labelNotes.Text = "Notes:"
    $labelNotes.ForeColor = [System.Drawing.Color]::White
    $form.Controls.Add($labelNotes)

    $textboxNotes = New-Object System.Windows.Forms.TextBox
    $textboxNotes.Location = New-Object System.Drawing.Point(140, 140)
    $textboxNotes.Size = New-Object System.Drawing.Size(200, 20)
    $form.Controls.Add($textboxNotes)

    $labelUrl = New-Object System.Windows.Forms.Label
    $labelUrl.Location = New-Object System.Drawing.Point(10, 170)
    $labelUrl.Size = New-Object System.Drawing.Size(120, 20)
    $labelUrl.Text = "URL:"
    $labelUrl.ForeColor = [System.Drawing.Color]::White
    $form.Controls.Add($labelUrl)

    $textboxUrl = New-Object System.Windows.Forms.TextBox
    $textboxUrl.Location = New-Object System.Drawing.Point(140, 170)
    $textboxUrl.Size = New-Object System.Drawing.Size(200, 20)
    $form.Controls.Add($textboxUrl)

    $labelTags = New-Object System.Windows.Forms.Label
    $labelTags.Location = New-Object System.Drawing.Point(10, 200)
    $labelTags.Size = New-Object System.Drawing.Size(120, 20)
    $labelTags.Text = "Tags:"
    $labelTags.ForeColor = [System.Drawing.Color]::White
    $form.Controls.Add($labelTags)

    $textboxTags = New-Object System.Windows.Forms.TextBox
    $textboxTags.Location = New-Object System.Drawing.Point(140, 200)
    $textboxTags.Size = New-Object System.Drawing.Size(200, 20)
    $form.Controls.Add($textboxTags)

    # View Notes button
    $buttonViewNotes = New-Object System.Windows.Forms.Button
    $buttonViewNotes.Location = New-Object System.Drawing.Point(20, 240)
    $buttonViewNotes.Size = New-Object System.Drawing.Size(100, 30)
    $buttonViewNotes.Text = "View Notes"
    $buttonViewNotes.BackColor = [System.Drawing.Color]::FromArgb(255, 41, 128, 185)  
    $buttonViewNotes.ForeColor = [System.Drawing.Color]::White
    $buttonViewNotes.Add_Click({
        ViewNotes
    })
    $form.Controls.Add($buttonViewNotes)

    $buttonAddEntry = New-Object System.Windows.Forms.Button
    $buttonAddEntry.Location = New-Object System.Drawing.Point(150, 240)
    $buttonAddEntry.Size = New-Object System.Drawing.Size(100, 30)
    $buttonAddEntry.Text = "Add Entry"
    $buttonAddEntry.BackColor = [System.Drawing.Color]::FromArgb(255, 41, 128, 185)  
    $buttonAddEntry.ForeColor = [System.Drawing.Color]::White
    $buttonAddEntry.Add_Click({
        $title = $textboxTitle.Text
        $email = $textboxEmail.Text
        $username = $textboxUsername.Text
        $password = $textboxPassword.Text  
        $notes = $textboxNotes.Text
        $url = $textboxUrl.Text
        $tags = $textboxTags.Text
        AddEntry -title $title -email $email -username $username -password $password -notes $notes -url $url -tags $tags

        # Clear the input fields
        $textboxTitle.Text = ""
        $textboxEmail.Text = ""
        $textboxUsername.Text = ""
        $textboxPassword.Text = ""  
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
    $buttonLogout.BackColor = [System.Drawing.Color]::FromArgb(255, 41, 128, 185)  
    $buttonLogout.ForeColor = [System.Drawing.Color]::White
    $buttonLogout.Add_Click({
        $form.DialogResult = 'OK'
    })
    $form.Controls.Add($buttonLogout)

    $result = $form.ShowDialog()

    if ($result -eq 'OK') {
        $form.Close()
        ShowLoginGui   
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
