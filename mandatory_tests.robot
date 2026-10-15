*** Settings ***
Library         SeleniumLibrary
Test Teardown   Close All Browsers

*** Test Cases ***
Open Jimms Website
    Open Browser    https://www.jimms.fi/    chrome
    Maximize Browser Window
    Wait Until Element Is Visible    id:searchinput    timeout=20s

    Wait Until Element Is Visible    xpath://button[normalize-space(.)="Hylkää kaikki"]    timeout=20s
    Click Button    xpath://button[normalize-space(.)="Hylkää kaikki"]