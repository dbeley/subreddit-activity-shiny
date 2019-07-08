# subreddit-activity-shiny

Simple shiny app for exploring the live users count from a selection of subreddits.

## Gallery

## Installation

- Install rstudio.
- Clone/Download the project on your computer.
- Open the .Rproj file with rstudio to load the R project.
- Open the app.R file.
- Click on the run app button.
- Wait for the dependencies to be installed (can take quite some time as the packages are compiled from source).
- The app should launch after that.

## Known Issues

- There are quite a number of outliers in the data. This may be due to an error in the data extraction or in the reddit API.
- When there are missing values, the graph draws a long line connecting the two valid points surrounding the missing range.
- Missing values breaks the smoothing.
- Missing values sometimes breaks the summary graphs.
