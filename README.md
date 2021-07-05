# eigital_exam

Eigital Exam

## Flutter version
Channel stable, 2.2.1

# Note:
Facebook login is only working using my own account.
In order to make the login via facebook work in any account, facebook required to make the app live in the facebook console and to make it live, it's require to have a Privacy Policy Url  and a User Data Deletion url 
which I don't have since this only a demo project.

You also required to used a real device in testing the functionality of the map.
Because some google api doesn't work using emulator or simulator.

If the app doesn't work in IOS or there's a problem in initializing firebase
follow this steps:

1. using finder goto  project directory ios/runner (and look for GoogleService-Info.plist)
2. open the ios folder in xcode
3. Under the runner/runner/ (where the appDelegate.swift is located)
   drag the file GoogleService-Info.plist (step 1)
4. Clean the project and close the app and run again.
