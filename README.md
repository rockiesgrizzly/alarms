# Alarms

A sample app showing on screen alarms and user-enabled notifications at given dates/times

# Architecture 

_For this project, I used a Clean Swift Architecture approach which allows a clear separation between the Presentation (view & view models), Domain (business logic), and Data (endpoint data retrieval and coordination) layers. You'll see lots of protocols at the top of the Data and Domain layers. These allow test object injection when utilized fully._

_The main AlarmViewModel kicks off a retrieval use case. The retrieval use case reaches out to the repository for current alarm objects. The repository invokes a service to retrieve the data from the endpoint. The use case converts the response data to models the view expects._

_The app provides both an screen notification with sound when an alarm occurs, and, if the user desires, a system notification._

<img width="1116" alt="Screenshot 2024-10-25 at 11 35 08 AM" src="https://github.com/user-attachments/assets/4bfd5333-0e90-4165-a053-bda6a9e0009a">


# Demo Video

_Note: Sound wasn't captured in this video. It works in the app itself._

https://github.com/user-attachments/assets/aac10606-580a-40ff-8373-807a5524890b




