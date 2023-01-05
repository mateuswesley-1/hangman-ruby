# hangman-ruby
 Implementing a Hangman game where we can save our progress  in Ruby

# The Process
The hangman is a simple game. The point of this project is in some way store the variables of the instance of the game class outside the code, so we can access them later on. 
To do so i've used the serilization module that was made in a previous class, so I managed to write the class object.inspect in a JSON file. The JSON file would store the values of all the instance variables, and in a new stance we could use this same values and would be able to load the saved game and go on where it left off.
Thats a new and beautfull idea to me. It was my first project in serialization and the idea of store the values of dinamic variables out side the program, in the computer's hard drive just blowed my mind in certain a way, it feels powerfull to be able to manipulating the computer outside the scope of the script.
