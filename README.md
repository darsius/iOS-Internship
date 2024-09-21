Tasks:

1. Integrated a network request to fetch a list of 100 users from an external API and displayed them in a table view. The table view adapts responsively across devices, ensuring the user’s profile picture is perfectly rounded, regardless of the device type. Applied appropriate layout constraints for a consistent look.

2. Designed and implemented a user detail page, accessible by tapping on any user in the list. This page showcases an enlarged version of the user’s profile picture and presents detailed information from the api in a structured and scrollable format. The page also includes an editable "Notes" section for user-specific comments, with the ability to save/delete notes for each user.

3. Incorporated an activity indicator to enhance user experience by showing a loading spinner while data is being fetched from the network, ensuring the interface remains responsive even during poor internet connectivity. Made the app behave properly based on wifi, mobile data or poor connection.

4. Added a search functionality allowing users to filter the list by name. The search bar can be toggled based on user interaction and provides an intuitive way to search through the user list. Made the search bar be native to iOS devices.

5. Refactored the app to a tab-based structure, adding a map view in the first tab that displays user locations with custom markers. Each marker shows the user’s name, and tapping on it leads to their details page, providing seamless navigation between the map and user data.
