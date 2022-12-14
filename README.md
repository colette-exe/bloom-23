# bloom
## CMSC 23 Shared Todo App Project
A shared todo app where you can see your friends' todos. Bloom together as all of you complete your tasks step-by-step, little-by-little :>

### Angelica Nicolette U. Adoptante
### 2020-01692
### D-1L

## Screenshots
![Log In Page](https://github.com/CMSC-23-1st-Sem-2022-2023/project-colette-exe/blob/main/screenshots/flutter_01.png)
![Profile - after successful log in](https://github.com/CMSC-23-1st-Sem-2022-2023/project-colette-exe/blob/main/screenshots/flutter_02.png)
![Options](https://github.com/CMSC-23-1st-Sem-2022-2023/project-colette-exe/blob/main/screenshots/flutter_04.png)
![Friends Page](https://github.com/CMSC-23-1st-Sem-2022-2023/project-colette-exe/blob/main/screenshots/flutter_05.png)
![Received Friend Requests Page](https://github.com/CMSC-23-1st-Sem-2022-2023/project-colette-exe/blob/main/screenshots/flutter_06.png)
![Viewing another user's profile](https://github.com/CMSC-23-1st-Sem-2022-2023/project-colette-exe/blob/main/screenshots/flutter_07.png)
![Search for Users Page](https://github.com/CMSC-23-1st-Sem-2022-2023/project-colette-exe/blob/main/screenshots/flutter_08.png)
![Sample searching](https://github.com/CMSC-23-1st-Sem-2022-2023/project-colette-exe/blob/main/screenshots/flutter_09.png)
![Shared Todos Page](https://github.com/CMSC-23-1st-Sem-2022-2023/project-colette-exe/blob/main/screenshots/flutter_10.png)
![Adding a new todo](https://github.com/CMSC-23-1st-Sem-2022-2023/project-colette-exe/blob/main/screenshots/flutter_11.png)

## Things you did in the code

1. **Files have been separated into different folders**
### api
- **firebase_auth_api.dart** -> adds user to the database and authentication storage after signing up; called to fetch the currently logged in user's information
- **firebase_user_api.dart** -> called for all user actions; add, accept, reject friend requests, unfriend another user, updating bio
- **firebase_todo_api.dart** -> called for todo actions; add, edit, update, delete todos; also called whenever a user unfriends or accepts another user;s friend request to update the 'ownerFriends' field

### models
- **screen_arguments.dart** -> used for passing arguments to a different screen; called in the pages for user's friends, friend requests, profile, search, todos, and viewing another user's profile
- **todo_model.dart** -> todo's structure
- **user_model.dart** -> user's structure

### providers
- **auth_provider.dart** -> the functions login and signup call are declared here; bridges operations between user and firebase
- **todo_provider.dart** -> the function todo uses are defined here
- **user_provider.dart** -> the functions user uses are defined here, especially for checking a user's association with another user (friends, strangers, in-the-friend-requests-inbox); calls functions unfriendUpdate and acceptUpdate from TodoListProvider to update the user's todos

### screens
- **login.dart** -> Log In Page, has fields for email and password
- **signup.dart** -> Sign Up Page, has fields for first and last names, username, location, birthday, email, and password
- **profile.dart** -> Profile Page, displays the currently logged in user's first and last names, username, id, birthday, location, and bio; also is the root for all other functions namely friends, friend requests, search, and shared todos pages 
- **friends_page.dart** -> display the users friends and the actions they can perform; view and unfriend; uses user_page.dart 
- **requests.dart** -> displays the requests the user has received; gives the option of viewing their profile and accepting or rejecting their friend request; uses user_page.dart
- **search.dart** -> Search Page; has a textbox for searching, uses user_page.dart to display all users depending on the search value
- **user_page.dart** -> displays users, except for the currently logged in user, along with buttons depending on their relationship with the user; uses modal_user.dart
- **view_profile.dart** -> displays another user's profile (only if their friends with the current user or has sent them a friend request); has a similar layout with profile.dart
- **modal_user.dart** -> user actions, display a dialog depending on the button the user pressed and acts accordingly
- **todo_page.dart** -> displays the user and their friends' todos; uses modal_todo.dart to perform actions on todos
- **modal_todo.dart** -> handles add, edit, delete, and view funnctions for todos

### services
- **notifications.dart** -> handles notifications (wasn't able to implement)

2. **Displaying a user's profile**
- To get a reference of the currently logged in user, I used the auth provider and fed the input to user list provider.
- Using a future builder, the information for user was fetched using the reference defined above.
- All details to be displayed were placed contiguously and as is, except for the bio. I created a new widget for the user's bio called **bioWidget()** with the context, bio, and user's id as parameters. For editing and saving the bio, another widget was created, **buttonWidget()** whose value changes from 'EDIT' to 'SAVE'.
- To reflect the changes made to the user's bio, the app must be reloaded. I have yet to find the fix for this.
- For other users, the layout is the same, without the buttonWidget, and some changes with the colors.

3. **Search Page**
- For the search page, I made a separate widget for the results, in user_page.dart. The search page takes in whatever the user types in the textbox and updates the displayed users. Regular expressions were used to be able to construct this feature. As for user_page.dart and the reason why I separated it, for other pages (Friends and Friend Requests Page), to be able to perform the same functions such as Add, Accept or Reject, and Unfriend.

4. **User Page**
- UserPage displays users, except the currently logged in user, with icon buttons for actions like add, accept, reject, unfriend, or viewing their profile.
- There are conditional clauses for the many pages using this widget, for search, friends, and friend requests pages.

5. **Todo Page**
- TodoPage displays the user's (colored in blue) and their friends' (pink) todos with buttons depending on wether they're the owner of that todo or not.
- TodoModal is used here for the operations of each button.
- At the bottom right part of this page is a button that adds and creates a new todo when the user chooses to.
- Only the owner can delete the todo, and they can do this by sliding the specific todo tehy want to delete. I could've made a button for it instead but I really liekd this feature.

## Challenges faced
The challenges I've faced we're always with handling and working with the firestore database, streambuilders, etc. There are some functions I wanted to implement but couldn't because I don't know how to solve the errors and problems I've encountered trying it.

For example:
- I wanted to make it so that the user's friends are displayed on their profile. I wa sable to make it work but my search page started lagging, and it kept loading and loading. So I decided to just make a separate page for it.
- I wanted to make some kind of zoom out option so that the user can zoom out and take a look at all the shared todos but didn't know how to implement it.
- As for database operations, I had troubles doing them but was able execute them with the help of flutter's documentations and other people's tips and tricks.


## Test Cases
There are 3 tests included in this project:
1. Unit Tests -> testing all functions of all the apis and providers used
2. Widget Tests -> testing the login, sign up, and profile page (whether the profile has the means to go to friends, friend requests, search, and shared todos page)
3. Integration Tests -> testing the log in and sign up pages and their validators.


## References
[1] https://stackoverflow.com/questions/66397629/retrieving-data-of-currently-logged-in-user-using-firebase-realtime-database-in
[2] https://www.kindacode.com/article/working-with-elevatedbutton-in-flutter/#Style_Color_Border_Elevation
[3] https://docs.appgyver.com/docs/get-current-user-firebase-auth
[4] https://api.flutter.dev/flutter/material/showDatePicker.html
[5] https://www.youtube.com/watch?v=W0hPbUF7xNM
[6] https://firebase.google.com/docs/firestore/query-data/get-data#get_multiple_documents_from_a_collection
[7] https://stackoverflow.com/questions/45900387/multi-line-textfield-in-flutter
[8] https://medium.com/flutter-community/useful-list-methods-in-dart-6e173cac803d
[9] https://api.flutter.dev/flutter/widgets/GridView-class.html
[10] https://www.kindacode.com/article/flutter-gridtile-examples/
[11] https://firebase.google.com/docs/firestore/query-data/get-data#dart_5
[12] https://stackoverflow.com/questions/65049133/struggling-to-update-multiple-documents-at-once-with-flutter-cloud-firestore
[13] https://stackoverflow.com/questions/46611369/get-all-from-a-firestore-collection-in-flutter
[14] https://stackoverflow.com/questions/58282160/flutter-driver-select-date-from-date-picker
