# Password-Manager

## Überblich

Der Passwort Manager ist ein Schulprojekt für das Modul 122. Dieses PowerShell Skript erlaubt dem Benutzer ihr passwort sicher und einfach zu speichern. Die Einträge werden in einer SQlite Datenbank gespeichert, die lokal auf dem Gerät ist.

## Ziel dieses Skripts

Das Ziel dieses Projektes ist ein Benutzerfreundlicher Passwort-Manager zu erstellen mit PowerShell
Die Benutzeroberfläche wird eifach zum handhaben sein.
Die gespeicherten Passwörter werden verschlüsselt in einer SQlite Datenbank gespeichert, die wir erstellen werden.

**S - Specific (Spezifisch)**:

Das Ziel ist ein Passwort-Manager zu erstellen, der eine SQlite Datenbank für die Einträge braucht. In dieses Skript kann man seine Passwörter verschlüsselt speichern, bearbeiten oder löschen. Zu den gespeicherten Passwörter, kann man den Usernamen, eine Email-Adresse, Notizen und tags speichern. Dieses Skript wird mit einer Benutzeroberfläche erstellt, um eine einfache Benutzung zu gewährleisten. Um den Password-Manager zu brauchen, muss man ein Hauptpasswort setzen, damit die gespeicherten Einträge nicht offen an alle sind.

**M - Measurable (Messbar)**:

Dieses Skript kann man anhand der Benutzung messen. Zudem ist erkennbar, wie dieses Skript mit dem aufrufen editieren oder löschen der Einträge umgeht. Auch die Aktionen, wie die Informationen zusätzlich der Passwörter sind messbar. Die Benutzeroberfläche muss einfach zum navigieren sein und die Passwörter schnell abrufbar sein.

**A - Achievable (Erreichbar)**:

Dieses Ziel ist realistisch zum Umsetzen. Hier geht es um den Umfang den man ausführt für dieses Projekt. Mit den Implementationen der Verschlüsselung, eintragen, editieren, abrufen und löschen der Passwörter, erreichen wir alle Kriterien, die es braucht einen guten Passwort-Manager zu erstellen.  

**R - Relevant (Relevant)**:

Dieses Projekt hat eine grosse Relevanz, weil man seine Passwörter sicher und einfach speichern möchte. Dazu werden auch zusätzliche Funktioinen zur verfügung gestellt, die das benutzen des Passwort-Manager einfacher macht. Dieses Skript strebt eine effektive und einfache Weise an Passwörter zu speichern, in welcher auch die Sicherheit gewährleistet wird. 

**T - Time-bound (Zeitgebunden)**:

Die Zeitspanne, die wir haben sind 8 Wochen. In diesen 8 Wochen, wollen wir die Arbeit gemäss den Kriterien erarbeiten und fertigstellen. Die Verschiedenen schritte, wie Planung, Entwicklung und Testen des Skripts. 
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

**Testfall 1: Neuen Benutzer erstellen** 

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

![Alt text](screenshots/creating_user.JPG)

![Alt text](screenshots/creation_successful.JPG)



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

![Alt text](screenshots/db_connection.JPG)

![Alt text](screenshots/login.JPG)



**Testfall 3: Neuen Eintrag hinzufügen** 

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

![Alt text](screenshots/new_entry.JPG)

![Alt text](screenshots/entry_added.JPG)

