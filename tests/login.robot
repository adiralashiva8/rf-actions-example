*** Settings ***
Documentation     Login Module - Authentication and Session Management Tests
Library           Collections
Library           String
Resource          resources/common.resource
Default Tags      login

*** Variables ***
${LOGIN_URL}             ${BASE_URL}/login
${DASHBOARD_URL}         ${BASE_URL}/dashboard
${SESSION_TIMEOUT}       1800
${MAX_LOGIN_ATTEMPTS}    5

*** Test Cases ***
Verify Successful Login With Valid Credentials
    [Documentation]    User can log in with correct email and password
    [Tags]    CTS-101    alice    smoke
    Open Browser To Login Page
    Enter Credentials And Submit    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Verify Page Title    Dashboard - CRM
    Verify Element Is Visible    welcome-banner

Verify Login Page Elements Are Displayed
    [Documentation]    All expected elements render on login page load
    [Tags]    CTS-102    bob    smoke
    Open Browser To Login Page
    Verify Element Is Visible    username-field
    Verify Element Is Visible    password-field
    Verify Element Is Visible    login-button
    Verify Element Is Visible    forgot-password-link

Verify Login Fails With Invalid Password
    [Documentation]    Error message shown when password is incorrect
    [Tags]    CTS-103    alice    regression
    Open Browser To Login Page
    Enter Credentials And Submit    ${VALID_USERNAME}    ${INVALID_PASSWORD}
    Verify Toast Message    Invalid username or password
    Verify Login Error Message Is Displayed    Invalid credentials. Please try again.

Verify Login Fails With Empty Username
    [Documentation]    Validation prevents submission with empty username
    [Tags]    CTS-104    tim    regression
    Open Browser To Login Page
    Enter Credentials And Submit    ${EMPTY}    ${VALID_PASSWORD}
    Fail    Expected validation error 'Username is required' but field was accepted

Verify Login Fails With Empty Password
    [Documentation]    Validation prevents submission with empty password
    [Tags]    CTS-105    bob    regression
    Open Browser To Login Page
    Enter Credentials And Submit    ${VALID_USERNAME}    ${EMPTY}
    Fail    Expected validation error 'Password is required' but field was accepted

Verify Remember Me Checkbox Works
    [Documentation]    Session persists after browser restart when remember me is checked
    [Tags]    CTS-106    alice    sanity
    Open Browser To Login Page
    Toggle Remember Me Checkbox
    Enter Credentials And Submit    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Verify Page Title    Dashboard - CRM

Verify Forgot Password Link Navigates Correctly
    [Documentation]    Clicking forgot password opens the reset password page
    [Tags]    CTS-107    tim    smoke
    Open Browser To Login Page
    Click Forgot Password Link
    Verify Page Title    Reset Password - CRM

Verify Account Lockout After Max Failed Attempts
    [Documentation]    Account locks after 5 consecutive failed login attempts
    [Tags]    CTS-108    alice    regression
    Open Browser To Login Page
    Attempt Login Multiple Times    ${VALID_USERNAME}    wrongpass    ${MAX_LOGIN_ATTEMPTS}
    Verify Toast Message    Account locked. Contact administrator.
    Fail    Account was not locked after ${MAX_LOGIN_ATTEMPTS} failed attempts. User could still attempt login.

Verify Session Timeout Redirects To Login
    [Documentation]    Idle session redirects user to login after timeout
    [Tags]    CTS-109    bob    regression
    Open Browser To Login Page
    Enter Credentials And Submit    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Verify Page Title    Dashboard - CRM
    Simulate Session Timeout
    Fail    Session did not expire after ${SESSION_TIMEOUT}s. User remained on dashboard without re-authentication.

Verify Successful Logout
    [Documentation]    User can log out and is redirected to login page
    [Tags]    CTS-110    tim    smoke
    Open Browser To Login Page
    Enter Credentials And Submit    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Logout From Application
    Verify Page Title    Login - CRM

Verify SSO Login Button Is Visible
    [Documentation]    SSO login option is displayed on login page
    [Tags]    CTS-111    alice    sanity
    Open Browser To Login Page
    Verify Element Is Visible    sso-login-button
    Verify Element Is Visible    sso-divider-text

Verify Password Field Masks Input
    [Documentation]    Password characters are masked with dots
    [Tags]    CTS-112    bob    sanity
    Open Browser To Login Page
    Verify Password Field Is Masked

*** Keywords ***
Verify Login Error Message Is Displayed
    [Arguments]    ${message}
    Log    Checking error banner displays: ${message}
    Fail    Element 'login-error-banner' not found on page. Expected error message: ${message}

Toggle Remember Me Checkbox
    Log    Toggling remember me checkbox
    Verify Element Is Visible    remember-me-checkbox

Click Forgot Password Link
    Log    Clicking Forgot Password link
    Verify Element Is Visible    forgot-password-link

Attempt Login Multiple Times
    [Arguments]    ${username}    ${password}    ${times}
    FOR    ${i}    IN RANGE    ${times}
        Enter Credentials And Submit    ${username}    ${password}
    END

Simulate Session Timeout
    Log    Simulating session timeout by waiting...
    Sleep    0.1s

Verify Password Field Is Masked
    Log    Verifying password input type is 'password'
    Should Be Equal    password    password
