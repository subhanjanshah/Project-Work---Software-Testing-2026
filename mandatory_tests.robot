*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${product_title}    ${EMPTY}

*** Test Cases ***
TC_SEARCH_001 Search For PS5
    Open Browser    https://www.jimms.fi/    chrome
    Maximize Browser Window
    Set Screenshot Directory    .
    Sleep    5s

    ${cookie_count}=    Get Element Count    xpath://button[normalize-space(.)="Hylkää kaikki"]
    FOR    ${index}    IN RANGE    ${cookie_count}
        Click Button    xpath://button[normalize-space(.)="Hylkää kaikki"]
        Sleep    1s
    END

    Click Element    id:searchinput
    Input Text    id:searchinput    ps5
    Sleep    5s

    # Click the search suggestion below the input field.
    Element Should Be Visible    xpath://a[@href="/fi/Product/Search?q=ps5"]
    Click Element    xpath://a[@href="/fi/Product/Search?q=ps5"]
    Sleep    8s

    Capture Page Screenshot    search-check.png
    Element Should Contain    css:main    Hakusanalla "ps5"
    Element Should Be Visible    xpath:(//main//h5/a)[1]
    Element Should Contain    xpath:(//main//h5/a)[1]    PS5

    ${product_title}=    Get Text    xpath:(//main//h5/a)[1]
    Set Suite Variable    \${product_title}    ${product_title}
    Log To Console    Selected product: ${product_title}

    Capture Element Screenshot    xpath:(//main//a[contains(@href, '/Product/Show/')]//img)[1]    first-product.png
    Sleep    3s
    Capture Element Screenshot    xpath:(//main//a[contains(@href, '/Product/Show/')]//img)[1]    first-product.png
    Capture Element Screenshot    css:a.btn-cart    cart-icon.png

TC_PRODUCT_001 Open Product From Search
    Element Should Contain    css:main    Hakusanalla "ps5"
    Element Should Contain    xpath:(//main//h5/a)[1]    PS5
    Click Element    xpath:(//main//h5/a)[1]
    Sleep    5s

    Element Should Be Visible    css:main h1
    Element Should Contain    css:main h1    PS5

    ${opened_title}=    Get Text    css:main h1
    Should Be Equal As Strings    ${opened_title}    ${product_title}
    Capture Page Screenshot    product-page.png
    Sleep    3s

TC_PRODUCT_002 Verify Add To Cart Link
    Element Should Be Visible    css:main h1
    Element Should Contain    css:main h1    PS5

    Element Should Be Visible    xpath://main//a[contains(@href, '/ShoppingCart/AddItem')]
    Element Should Contain    xpath://main//a[contains(@href, '/ShoppingCart/AddItem')]    LISÄÄ KORIIN
    Element Should Be Enabled    xpath://main//a[contains(@href, '/ShoppingCart/AddItem')]
    Sleep    3s

TC_CART_001 Add Product To Shopping Cart
    # Check that we are on the selected product before adding it.
    ${opened_title}=    Get Text    css:main h1
    Should Be Equal As Strings    ${opened_title}    ${product_title}
    Element Should Contain    css:main h1    PS5

    Click Element    xpath://main//a[contains(@href, '/ShoppingCart/AddItem')]
    Sleep    5s

    Click Element    css:a.btn-cart
    Sleep    5s

    Element Should Contain    css:main h1    OSTOSKORI
    Element Should Contain    css:main article    ${product_title}
    Capture Page Screenshot    shopping-cart.png
    Sleep    3s

    # Remove the test item after saving the evidence.
    Click Element    xpath://main//article//*[@role="button" and normalize-space(.)="close"]
    Sleep    3s
    Page Should Contain    Ostoskorisi on tyhjä

    Close Browser