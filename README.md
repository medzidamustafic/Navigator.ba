# Navigator.ba
## Resources:

    https://www.navigator.ba/#/categories

    Project management tool: Trello

    Trello board: https://trello.com/b/JPIKzeia/testing-internship-3-q12019
    
## Description

In this repository Smoke test for Navigator.ba is automated using test automation tools described in Enviroment setup section.

Test script contains following test cases: 

    - Verify that it is possible to search objects and places
    - Verify that it is possible to send message to suggest a feature or report an error
    - Verify that it is possible to create new place







## Environment setup: 

#### Install Linux/Ubuntu 16.04.

#### Ruby  
          
       Download and install ruby (link: https://rubyinstaller.org/downloads/)

#### RSpec

       Install `gem install rspec`

       Setup `rspec --init`

#### Capybara 
            
        Capybara requires Ruby 2.3.0 or later. 

        To install, add this line to `Gemfile` and run `bundle install`:  `gem 'capybara'`

        In the application:

                   `require 'capybara'`
                   
                   `require 'capybara/rspec'`


#### Selenium
     
       In order to use Selenium, install the `selenium-webdriver` gem, and add it to `Gemfile`.
       
       Make Capybara run tests in Selenium by setting `Capybara.default_driver = :selenium`
       
              
          

