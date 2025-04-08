# echio

Echio Machine Test

## Getting Started

In lib->data there are the json files which mimics api data.
There are campaigns.json and users.json.

On the login page, enter the influencerId and password from the users.json file.

The app now reads the json file and login the user.

The user details are stored using hive Db locally.

A list of campaigns are listed in the dashboard view which are fetched from the campaigns.json file using the user details saved.

Tap on the campaign to go to the details page.

Tap on the "Mark completed" button to mark the campaign as completed.

Now the app will change the data in the json file to mimic api data and db, so that the next time you open the app the completed campaign stays on the completed tab.