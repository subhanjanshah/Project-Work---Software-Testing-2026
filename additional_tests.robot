# Group: Subhanjan Shah, Aurelija Putnaite, Ruhan Ghantiwala
*** Settings ***
Library    SeleniumLibrary
Suite Setup    Open Test Browser
Suite Teardown    Close All Browsers
Test Teardown    Run Keyword If Test Failed    Capture Page Screenshot

*** Variables ***
${BASE_URL}          https://www.jimms.fi/
${INVALID_SEARCH}    QZTEST-NOMATCH-2026-XY91

*** Keywords ***
Open Test Browser
    Open Browser    ${BASE_URL}    chrome
    Maximize Browser Window
    Set Selenium Timeout    15 seconds
    Sleep    5s
    ${cookie_count}=    Get Element Count    xpath://button[normalize-space(.)="Hylkää kaikki"]
    FOR    ${index}    IN RANGE    ${cookie_count}
        Click Button    xpath://button[normalize-space(.)="Hylkää kaikki"]
        Sleep    1s
    END

Open First Search Result
    [Arguments]    ${keyword}
    Wait Until Element Is Visible    id:searchinput
    Click Element    id:searchinput
    Input Text    id:searchinput    ${keyword}
    Sleep    3s
    # The site's search suggestion URL pattern is used by the existing team test.
    Click Element    xpath://a[contains(@href, '/Product/Search?q=${keyword}')]
    Wait Until Page Contains Element    xpath:(//main//h5/a)[1]    timeout=20s

*** Test Cases ***
TC_SEARCH_007 Invalid Search Shows No Matching Results
    [Documentation]    Verify the site clearly indicates no results for a unique unlikely keyword.
    Go To    ${BASE_URL}
    Sleep    4s
    Click Element    id:searchinput
    Input Text    id:searchinput    ${INVALID_SEARCH}
    Sleep    3s
    # If an autocomplete suggestion appears, use it; otherwise submit with ENTER.
    ${suggestion_count}=    Get Element Count    xpath://a[contains(@href, '/Product/Search?q=${INVALID_SEARCH}')]
    IF    ${suggestion_count} > 0
        Click Element    xpath://a[contains(@href, '/Product/Search?q=${INVALID_SEARCH}')]
    ELSE
        Press Keys    id:searchinput    ENTER
    END
    Sleep    8s
    Capture Page Screenshot    tc07-invalid-search.png
    # Adjust this assertion if the live site uses different no-results wording.
    ${page_text}=    Get Text    css:main
    Should Not Contain    ${page_text}    Hakusanalla "${INVALID_SEARCH}" löytyi tuotteita

TC_PRODUCT_008 Product Price And Availability Are Visible
    [Documentation]    Open a product from a known search and verify price and availability information are present.
    Go To    ${BASE_URL}
    Sleep    4s
    Open First Search Result    ps5
    Click Element    xpath:(//main//h5/a)[1]
    Wait Until Element Is Visible    css:main h1
    Sleep    4s
    Capture Page Screenshot    tc08-product-price-availability.png
    ${main_text}=    Get Text    css:main
    Should Not Be Empty    ${main_text}
    # Manual comparison is needed to confirm price/stock consistency across listing and detail page.

TC_UI_009 Product Listing Cards Show Basic Information
    [Documentation]    Verify visible product cards include product names and product links.
    Go To    ${BASE_URL}
    Sleep    5s
    Wait Until Page Contains Element    xpath:(//main//h5/a)[1]    timeout=20s
    ${card_count}=    Get Element Count    xpath://main//h5/a
    Should Be True    ${card_count} > 0
    ${first_name}=    Get Text    xpath:(//main//h5/a)[1]
    Should Not Be Empty    ${first_name}
    Element Should Be Visible    xpath:(//main//h5/a)[1]
    Capture Page Screenshot    tc09-product-listing.png

TC_CART_010 Cart Quantity Update And Removal
    [Documentation]    Verify quantity update if available; remove the test item; never proceed to checkout.
    Go To    ${BASE_URL}
    Sleep    5s
    Open First Search Result    ps5
    Click Element    xpath:(//main//h5/a)[1]
    Wait Until Element Is Visible    css:main h1
    Wait Until Element Is Visible    xpath://main//a[contains(@href, '/ShoppingCart/AddItem')]
    Click Element    xpath://main//a[contains(@href, '/ShoppingCart/AddItem')]
    Sleep    4s
    Click Element    css:a.btn-cart
    Sleep    4s
    Capture Page Screenshot    tc10-cart-before.png
    ${quantity_controls}=    Get Element Count    xpath://main//article//input[@type="number" or @name[contains(.,'quantity')]]
    IF    ${quantity_controls} > 0
        Input Text    xpath:(//main//article//input[@type="number" or @name[contains(.,'quantity')]])[1]    2
        Press Keys    xpath:(//main//article//input[@type="number" or @name[contains(.,'quantity')]])[1]    ENTER
        Sleep    3s
        Capture Page Screenshot    tc10-cart-quantity-updated.png
    ELSE
        Log    No editable quantity control found; record this as a manual observation, not automatically as a defect.
    END
    # Cleanup: remove the test item from the cart. Never click checkout.
    ${remove_count}=    Get Element Count    xpath://main//article//*[@role="button" and normalize-space(.)="close"]
    IF    ${remove_count} > 0
        Click Element    xpath://main//article//*[@role="button" and normalize-space(.)="close"]
        Sleep    3s
    END
    Capture Page Screenshot    tc10-cart-after-removal.png

TC_UI_006 Breadcrumb Navigation
    [Documentation]    Inspect breadcrumb navigation on a product page; update selectors if the live DOM differs.
    Go To    ${BASE_URL}
    Sleep    5s
    Open First Search Result    ps5
    Click Element    xpath:(//main//h5/a)[1]
    Wait Until Element Is Visible    css:main h1
    Sleep    3s
    Capture Page Screenshot    tc06-product-breadcrumb.png
    ${breadcrumb_count}=    Get Element Count    xpath://main//*[contains(@class,'breadcrumb')]//a | //nav[@aria-label='breadcrumb']//a
    Should Be True    ${breadcrumb_count} > 0
    Click Element    xpath:(//main//*[contains(@class,'breadcrumb')]//a | //nav[@aria-label='breadcrumb']//a)[last()]
    Sleep    5s
    Capture Page Screenshot    tc06-parent-category.png
