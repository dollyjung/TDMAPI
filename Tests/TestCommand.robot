*** Settings ***
Library  SeleniumLibrary


*** Variables ***
${url_fb} =  https://www.facebook.com


*** Test Cases ***
Test deployment
    #robot -d %% Tests/TestCommand.robot
    log  log should be at define path

Test run browser with option
    [Tags]  browser
    #robot -d Results -i browser Tests/TestCommand.robot
    ${options}=    Evaluate  sys.modules['selenium.webdriver.chrome.options'].Options()    sys
    Call Method     ${options}    add_argument    --disable-notifications
    Call Method     ${options}    add_argument    --disable-infobars
    ${driver}=    Create Webdriver    Chrome    options=${options}
    Go to  ${url_fb}

*** Keywords ***

