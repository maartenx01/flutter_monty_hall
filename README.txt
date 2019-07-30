For my final project, I created a version of the classic TV sensation
Let's Make a Deal with host Monty Hall. The game play workflow is as
follows: the user chooses one of three doors in grey. The user next
presses "Reveal goat" at which point one door will turn brown. This
signifies an incorrect door. Now the user has to make the decision
whether to switch or not. If the user decides to switch, the user
will hit the "Switch door" button. Now comes the moment of truth,
the user finds out if his/her initial guess was correct by pressing
the "Show Me the Money" button. The user can choose to play again by
pressing "Replay". Additionally the user can hit the menu button on
the upper left hand corner to display a list of other possible
actions including "Switch Toggle Preference" and "View Results".

This project is built with the Flutter framework in the Dart
language. I use local storage and a Sqflite database to store the users
game results. Game results are automatically inserted into the database 
when the user clicks to see the result of each game. I implement shared 
preferences by giving the user the ability to enable disable the "Switch 
door" button. Some users may be so confident in their choices that they
will not need a switch button. This preference presists across different
application sessions. I connect to a random number generator API 
provided by Australian National University with the API call 
(https://qrng.anu.edu.au/API/jsonI.php?length=1&type=uint8) modulo 3 
to determine which door contains the prize. This is done with
an async task when the user clicks one of the doors as an initial guess.
I displayed the previous game results in a Listview. I used a
Listview.builder which is apparently the closest flutter analog to
Android's recycler view (at least according to 
https://medium.com/@dev.n/the-complete-flutter-series-article-3-lists-and-grids-in-flutter-b20d1a393e39).
Finally, based on Professor Gerber's responses in the Optional Flutter
Project post on Piazza, I did not implement Jetpack as Flutter does not
have jetpack. My application does run on both Android and iOS platforms.

One thing to note is that when the app initalizes for the first time, the
API call is launched. But pressing the "Reveal goat" button may have a
delay during the first game because the winning door is set to the return
value of the API call. We are unable to determine which door to reveal as
the goat until the API call is done. So it may take a few seconds until a
brown door is rendered. However, successive rounds will be able to pull
an API value immediately. I believe the lag is in making the connection.
