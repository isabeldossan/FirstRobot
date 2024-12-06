
*** Settings ***
Documentation    Login function on Sellpy.se
Library    SeleniumLibrary

*** Variables ***
${right_email}  ikemap741@deligy.com
${right_password}  ecutbildning
${not_accepted_char_email}  ike?map741@deligy.com
${wrong_password}  ec
${email_missing_@}  ikemap741deligy.com
${error_expected_missing_@}  Inkludera ett @ i e-postadressen. ikemap741deligy.com saknar ett @.
${new_email}  ikemap74111@deligy.com
${empty_input}

*** Test Cases ***
Successful login attempt
    [Documentation]  Test aims to successfully login to Sellpy.se with correct test data
    [Tags]  function

    Test Setup
    Sleep  7 seconds
    Input Text  name:email  ${right_email}
    Click Submit Button
    Sleep  5 seconds
    Input Password  name:password  ${right_password}
    Click Submit Button
    Sleep  5 seconds
    Location Should Be  https://www.sellpy.se/home
    Wait Until Page Contains  Välkommen
    Close Browser

Failed login attempt due to not accepted char in email
    [Documentation]  Test aims to fail the login attempt due to input email with not accepted char (?) and therefore expect Error Message
    [Tags]  function

    Test Setup
    Sleep  7 seconds
    Input Text  name:email  ${not_accepted_char_email}
    Click Submit Button
    Sleep  5 seconds
    Wait Until Page Contains  Ogiltig mejladress
    Location Should Be  https://www.sellpy.se/login
    Close Browser

Failed login attempt due to wrong password
    [Documentation]  Test aims to fail the login attempt due to wrong password and therefore expect Error Message
    [Tags]  function

    Test Setup
    Sleep  7 seconds
    Input Text  name:email  ${right_email}
    Click Submit Button
    Sleep  5 seconds
    Input Password  name:password  ${wrong_password}
    Click Submit Button
    Sleep  5 seconds
    Wait Until Page Contains  Fel lösenord. Försök igen.
    Location Should Be  https://www.sellpy.se/login/password
    Close Browser

Failed login attempt due to missing \@ in email
    [Documentation]  Test aims to fail the login attempt due to email missing @ and therefore expect Error Message in Javascript Tooltip
    [Tags]  function

    Test Setup
    Sleep  7 seconds
    Input Text  name:email  ${email_missing_@}
    Sleep  5 seconds
    Click Submit Button
    Sleep  5 seconds
    ${Javascript_error_message} =  Execute JavaScript  return document.querySelector("input[name='email']").validationMessage
    Should Be Equal As Strings  ${Javascript_error_message}  ${error_expected_missing_@}
    Close Browser

Login attempt switching to Signup due to new email input
    [Documentation]  Test aims to switch the login attempt to Signup option due to new email input that does not exist in database and therefore expect Signup page
    [Tags]  function

    Test Setup
    Sleep  7 seconds
    Input Text  name:email  ${new_email}
    Click Submit Button
    Sleep  5 seconds
    Wait Until Page Contains  Skapa en Sellpy-profil
    Location Should Be  https://www.sellpy.se/signup/password
    Close Browser

Failed login attempt due to empty email input
    [Documentation]  Test aims to fail the login attempt due to empty email input and therefore expect disabled Continue/Fortsätt button
    [Tags]  function

    Test Setup
    Sleep  7 seconds
    Input Text  name:email  ${empty_input}
    Element Should Be Disabled  xpath://button[@type='submit']
    Sleep  5 seconds
    Close Browser

Successfully hide and show password in login function
    [Documentation]  Test aims to use the hide/show function in password field and expect function to be successful
    [Tags]  function

    Test Setup
    Sleep  7 seconds
    Input Text  name:email  ${right_email}
    Click Submit Button
    Sleep  5 seconds
    Input Password  name:password  ${right_password}
    Sleep  3 seconds
    Element Should Be Visible  xpath://i[@title='EYE_FILLED']
    Click Element  xpath://i[@title='EYE_FILLED']
    Sleep  5 seconds
    Element Should Be Visible  xpath://i[@title='EYE_OFF_FILLED']
    Close Browser

*** Keywords ***
Handle Cookie Banner
    [Documentation]  Waits until the cookies banner is shown and then accepts all cookies by clicking "Tillåt alla cookies"
    Wait Until Element Is Visible  xpath://*[@id="app"]/div[3]/div/div/button[1]/span/span
    Click Element  xpath://*[@id="app"]/div[3]/div/div/button[1]/span/span

Click Profile Button
    [Documentation]    Clicks on the profile button to open the login page
    Click Element    xpath://a[.//i[@title='PROFILE']]

Click Submit Button
    [Documentation]  Clicks on the submit button called "Fortsätt"
    Click Button  xpath://button[@type='submit']

Test Setup
    [Documentation]  Opens browser, accepts the cookies and clicks on the Profile button
    Open Browser  https://www.sellpy.se  chrome
    Maximize Browser Window
    Handle Cookie Banner
    Click Profile Button


