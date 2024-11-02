# Jackal
A google dorks and curl based web scraper.

this should work off the shelf for KALI users.
if not, the dependencies are: curl, figlet, sherlock.

user_agents:
in the same directory should be the user agents txt file which the script chooses at random with evry roll.

file mode:
- the script requires user input based on "site" operator (example.com, www.example.com etc..)
- the script will than prompt the user to choose the file type by index number, and after that the exact extension by index number.
- the script gives an option for a keyword; an indipendent variable to act as modifyer for the search without any specific operator. it can be used or ignored.
- choosing all file types does not seem to work as intended at this moment, i plan to fix this in the future. also it seems to enumerate folders so why not keep it ¯\_(ツ)_/¯
- when done the terminal will provide all links with the majority of irrelevant data scrubed from it - all remains is to look what URLs are relevant, rightclick and visit.
- the script will ask the user if it should download the files found, if chosen "yes" they will be saved to a directory with the target's URL as its name in the Jackal directory.

social accounts mode:
- the script require user input based on "inurl" operator and does not require special characters (firstname secondname), just write as it is.
- the script gives an option for a keyword; an indipendent variable to act as modifyer for the search without any specific operator. it can be used or ignored.
- when done the terminal will provide all links with the majority of irrelevant data scrubed from it - all remains is to look what URLs are relevant, rightclick and visit.
- results will be saved automaticly without user promped to a folder with the POI's name in the Jackal directory.
- the script uses both "Sherlock" and google dorks operatoras, this increases the results but can also cause dubles.
