*** Settings ***
Library         SeleniumLibrary
Test Teardown   Close All Browsers

*** Test Cases ***
TC_SEARCH_001 Search For PS5
    Open Store And Search For PS5
    Scroll Element Into View    css:main a[href*="/Product/Show/"]:has(img)
    Wait For Condition    return (() => { const img = document.querySelector('main a[href*="/Product/Show/"] img'); return img && img.complete && img.naturalWidth > 0; })();    timeout=30s
    Capture Element Screenshot    css:main a[href*="/Product/Show/"]:has(img)    first-product.png
    Capture Element Screenshot    css:a.btn-cart    cart-icon.png
    Sleep    5s

TC_PRODUCT_001 Open Product From Search
    Open Store And Search For PS5
    ${selected_title}=    Get Text    css:main h5 a[href*="/Product/Show/"]
    Click Link    css:main h5 a[href*="/Product/Show/"]
    Wait Until Location Contains    /Product/Show/    timeout=20s
    Wait Until Element Is Visible    css:main h1    timeout=20s
    Element Should Contain    css:main h1    ps5    ignore_case=True
    ${product_title}=    Get Text    css:main h1
    Should Be Equal    ${product_title}    ${selected_title}
    Sleep    5s

TC_PRODUCT_002 Verify Add To Cart Link
    Open Store And Search For PS5
    Click Link    css:main h5 a[href*="/Product/Show/"]
    Wait Until Location Contains    /Product/Show/    timeout=20s
    Wait Until Element Is Visible    css:main h1    timeout=20s
    Wait Until Element Is Visible    css:main a[href*="/ShoppingCart/AddItem"]    timeout=20s
    Element Should Contain    css:main a[href*="/ShoppingCart/AddItem"]    Lisää koriin    ignore_case=True
    Element Should Be Enabled    css:main a[href*="/ShoppingCart/AddItem"]
    Sleep    5s

*** Keywords ***
Open Store And Search For PS5
    Open Browser    https://www.jimms.fi/    chrome
    Maximize Browser Window
    Wait Until Element Is Visible    id:searchinput    timeout=20s

    ${cookie_visible}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    xpath://button[normalize-space(.)="Hylkää kaikki"]    timeout=5s
    IF    ${cookie_visible}
        Click Button    xpath://button[normalize-space(.)="Hylkää kaikki"]
    END

    Input Text    id:searchinput    ps5
    Press Keys    id:searchinput    ENTER
    Wait Until Location Contains    /Product/Search    timeout=20s
    Wait Until Element Is Visible    css:main h5 a[href*="/Product/Show/"]    timeout=30s
    Element Should Contain    css:main h5 a[href*="/Product/Show/"]    ps5    ignore_case=True