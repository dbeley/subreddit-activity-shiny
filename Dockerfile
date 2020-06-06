# get shiny serves plus tidyverse packages image
FROM rocker/shiny:latest

# system libraries of general use
RUN apt-get update && apt-get install -y \
    sudo \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev 
  

# install R packages required 
# (change it depending on the packages you need)
RUN R -e "install.packages('tidyverse', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('shiny', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('RSQLite', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('dbplyr', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('dply', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('ggplot2', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('forcats', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('lubridate', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('scales', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('shinyWidgets', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('shinythemes', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('tibble', repos='http://cran.rstudio.com/')"

# copy the app to the image
COPY subreddit-activity-shiny.Rproj /srv/shiny-server/
COPY app.R /srv/shiny-server/
COPY load_data.R /srv/shiny-server/
COPY load_subreddits.R /srv/shiny-server/
COPY dependencies.R /srv/shiny-server/
COPY reactive_components.R /srv/shiny-server/
COPY subreddit_tracker.db /srv/shiny-server/
# COPY subreddits/* /srv/shiny-server/subreddits/

# select port
EXPOSE 3838

# allow permission
RUN sudo chown -R shiny:shiny /srv/shiny-server

# run app
CMD ["/usr/bin/shiny-server"]
