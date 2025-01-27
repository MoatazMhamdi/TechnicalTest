-API integration : 
use the spaceX to fetch data about launces and mission 

User interface : 
-display a list of spaceX launches and mission 
 -each item in the list should show the basic information ( launch name , date )
-when a user clicks on an item , display information aboout the selected launch or mission 
offline mode : 
-implement offline support to cach te launch and mission list locally 
-when the device is ooffline , display the cached data 

Tasks ; 
- 1- setup : 
- -setup the project structure with approprite folder for screens ( component ), services , styles ..;
- 2- fetc data : 
- -create service or utility to fetch data from spaceX api 
- -fetch a list of launces and missions from spaceX endpoints 
- -implement caching of the fetched data using local storage ( hive / sqlite)
- 3- display data 
- -create a main screen to display the list launches and missions. 
- - each list item should include basic information sush as name and date 
- -ensure the list display cached data when offline
- 4- detail view : 
- - create detail screen to display detailed information about selected launch or mission 
- - when a user clicks on list item , navigate to the detail screen and display information 
- 5- navigation : 
- - implement navigation between list view and detail view 
- - ensure the application handels navigation smoothly and displays approprite loading states 
- Error Handling : 
- - implement error handling for API requests 
- - display user-friendly error messages if the data cannot be fetced or if the device is offline 


Exemples api endpoints :

List of launches : https://api.spacexdata.com/v3/launches
List of missions : https://api.spacexdata.com/v3/missions
