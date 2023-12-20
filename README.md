# password-manager

## Overview

The password manager is a project developed for a school module, LB2, as part of an exam. This PowerShell script allows users to store their passwords easy and safe. The Entries will be saved on a SQlite Database that i sstored locally on the device.

## Goal of this Code

The Goal of this project is, to create a user-friendly passwort manager with the language powershell.
The GUI will be simple and easy to handle.
The entered passwords will be encrypted and saved on a sqlite database that we will create.

**S - Specific (Spezifisch)**:

The goal is to develop a PowerShell script for a password manager that utilizes SQLite for data storage. The script should include functionalities such as password encryption, adding, editing, and deleting passwords. Additional information, including username, email, notes, and tags, should be stored alongside the password (fields: Title, Username, Password, Urls, Tags, Notes). The script should create a graphical user interface (GUI). User needs to set a main password to enter the password manager.

**M - Measurable (Messbar)**:

The script's success depends on how well it handles passwords, including encryption, adding, editing, and deleting them. Additional points for success include providing extra information and creating a user-friendly interface. Setting a main password to enter the password manager and use the abilitiys of the manager is necessary.

**A - Achievable (Erreichbar)**:

The goal is achievable given the specified functionalities and the tools (PowerShell and SQLite) selected for implementation. The encryption, database management, and GUI development are capable with PowerShell scripting. The inclusion of user prompts for password setting improves the achievable aspect by ensuring a user-friendly experience.

**R - Relevant (Relevant)**:

The goal is relevant in the context of secure password management, as it addresses encryption, user interface, and the storage of additional information. The script aims to provide a complete solution for effective and easy password management, in line with the importance of safeguarding sensitive information.

**T - Time-bound (Zeitgebunden)**:

The goal should be completed within the time frame of 8 weeks, aiming for a reasonable planning and development period. A milestone could be set to complete the script and conduct testing within a specific timeframe, ensuring timely delivery and implementation. This helps maintain focus and prioritize tasks within a defined schedule.

## Before you start

1. Install SQlite https://www.sqlite.org/download.html

2. Create new folder C:\sqlite

3. Extract content of the downloaded folder and move it in the created folder

4. Open command line (CMD)

5. Navigate to C:\sqlite

6. Once you navigated to the folder enter "sqlite3"

## Getting Started

Clone the repo:

1. **Clone the repo**:

```bash
$ git clone git@github.com:parwarr/password-manager.git
```

2. **Move to the project**:

```bash
$ cd ...
```

To run the password manager, follow these steps:

1. **Modify DB Path in script:** 

Once the Repository is cloned, modify line 24 to the path, where the "password-manager.db" database is stored

2. **Run the Script:**

Run the script with Powershell

## Project Details

### Script Overview

The script consists of several functions and steps:

1. **Database Setup**:
Initializes the SQLite database connection.

2. **User Functions**:

**CreateLogin**:
Creates a new user login.

**Login**:
Validates user credentials.

**AddEntry**:
Adds new password entries.

3. **GUI Elements**:

**ShowLoginGui**:
Displays a user-friendly login/signup GUI.

**ViewNotes**:
GUI for viewing and deleting entries.

**ShowPasswordManagerGui**:
Main GUI for adding, viewing, and logging out.

4. **Main Execution**:
Initializes the database connection.
Launches the login GUI.

5. **Exception Handling**:
Catches and handles exceptions.

6. **Usage Flow**:
Users run the script.
Login or sign up through the GUI.
Access the main GUI for managing passwords.

- **TODO**: 
[] Mindstorm Project //Saranhan, Parwar
[] Plan Action Steps //Saranhan, Parwar
[] Create Repository in GitHub //Parwar
[] Write ReadMe // Saranhan
[] Create Header for Script //Saranhan
[] Create a DB with Sqlite //Parwar
[] Establish connection with DB //Parwar
[] Create Login function into password manager //Parwar
[] Create AddEntry function to be able to enter passwords //Parwar
[] Create the Login GUI with Sign In and Sign Up tab //Parwar
[] Create password manager GUI with buttons to add entries, view notes and logout //Parwar
[] Create view notes tab, where you can edit and delete your entires. //Parwar
[] Create Usecases and Testcase //Saranhan
[] Clean up Code 


### Author

- sth134864@stud.gibb.ch
- hpa134085@stud.gibb.ch

## Requirements

- PowerShell
- SQlite

## Disclamer

- This password manager will store your passwords only locally on the database. This password manager utilises as an convenience application and not as an backup solution.

## Usecase

**Testfall 1:** Neuen Benutzer erstellen 

**Usecase:** Ein neuer Benutzer möchte sich im Passwort-Manager registrieren. 

**Testszenario:**

Benutzer gibt einen eindeutigen Benutzernamen und ein sicheres Passwort ein. 

**Schritte:** 

Skript starten mit PowerShell 

User registrieren 

**Randbedingungen:** 

Skript muss lokal von GitHub geklont sein. 

Im Skript den Datenbank Pfad angepasst haben.

**Erwartete Ergebnisse:** 

Das Skript sollte den neuen Benutzer erfolgreich erstellen und eine Bestätigung ausgeben. 

**Beweis der Durchführung:**

![Alt text](screenshots\creating_user.JPG)

![Alt text](screenshots\creation_successful.JPG)



**Testfall 2: Benutzeranmeldung**

**Usecase:** Ein Benutzer möchte sich im Passwort-Manager anmelden. 

**Testszenario:** 

Benutzer gibt gültigen Benutzernamen und gültiges Passwort ein. 

**Schritte:** 

Skript starten 

Einloggen mit einem erstellen User 

**Randbedingungen:** 

Skript muss lokal von GitHub geklont sein. 

Im Skript den Datenbank Pfad angepasst haben. 

User registriert haben

**Erwartete Ergebnisse:** 

Das Skript sollte den Benutzer erfolgreich anmelden und eine Bestätigung ausgeben. 

**Beweis der Durchführung:** 

![Alt text](screenshots\db_connection.JPG)

![Alt text](screenshots\login.JPG)



**Testfall 3:** Neuen Eintrag hinzufügen 

**Usecase:** Ein eingeloggter Benutzer möchte einen neuen Eintrag (Passwort) hinzufügen. 

**Testszenario:** 

Benutzer gibt alle erforderlichen Informationen für den neuen Eintrag ein. 

**Schritte:**

Skript starten mit PowerShell 

Mit einem existierenden User anmelden 

Eintrag erstellen 

**Randbedingungen:** 

Skript muss lokal von GitHub geklont sein.  

Im Skript den Datenbank Pfad angepasst haben.  

User registriert haben 

**Erwartete Ergebnisse:** 

Das Skript sollte den Eintrag erfolgreich hinzufügen und eine Bestätigung ausgeben. 

**Beweis der Durchführung:** 

![Alt text](screenshots\new_entry.JPG)

![Alt text](screenshots\entry_added.JPG)

