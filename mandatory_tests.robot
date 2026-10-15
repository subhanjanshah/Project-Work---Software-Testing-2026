*** Settings ***
Library         SeleniumLibrary
Test Teardown   Close All Browsers

*** Test Cases ***
TC_SEARCH_001 Search For PS5
    Open Browser    https://www.jimms.fi/    chrome
    Maximize Browser Window
    Wait Until Element Is Visible    id:searchinput    timeout=20s

    ${cookie_visible}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    xpath://button[normalize-space(.)="Hylkää kaikki"]    timeout=5s
    IF    ${cookie_visible}
        Click Button    xpath://button[normalize-space(.)="Hylkää kaikki"]
    END

    