Take home assessment for applicant Joshua Ho. All code is written in Swift and SwiftUI. 

Small application that loads data from this api: https://themealdb.com/api.php
Application displays list of Desserts retrieved from the api on load. Clicking on one of the cards takes you to a detailed description view that shows the recipe and ingredients list.

Considerations:
- Tests are included for the 4 ViewModel functions. Covers a basic test suite just to show expected results for edge cases
- The details API is called for a specific dessert only when it is clicked. I could've made it so that we called the details API for every item returned from the first API,
  however, I refrained from doing this since doing so would cause the app to load slower and allocate more space for data that wouldn't be useful.



https://github.com/joshe17/fetchAssessment/assets/59759832/17be755d-17ff-4753-9618-eed27b15776f

