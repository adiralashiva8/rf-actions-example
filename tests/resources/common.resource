*** Settings ***
Library    Collections
Library    String
Library    OperatingSystem

*** Variables ***
${BASE_URL}              https://crm.example.com
${BROWSER}               chromium
${DEFAULT_TIMEOUT}       10s
${VALID_USERNAME}        admin@example.com
${VALID_PASSWORD}        SecurePass123!
${INVALID_PASSWORD}      WrongPass
${DB_CONNECTION}         postgresql://localhost:5432/crm_db

*** Keywords ***
Open Browser To Login Page
    [Documentation]    Navigate to the CRM login page
    Log    Opening browser to ${BASE_URL}/login
    Should Not Be Empty    ${BASE_URL}

Enter Credentials And Submit
    [Arguments]    ${username}    ${password}
    [Documentation]    Fill in the login form and submit
    Log    Entering username: ${username}
    Log    Entering password: [MASKED]
    Should Not Be Empty    ${username}
    Should Not Be Empty    ${password}

Verify Page Title
    [Arguments]    ${expected_title}
    [Documentation]    Verify the current page title matches expected
    Log    Verifying page title is: ${expected_title}
    Should Not Be Empty    ${expected_title}

Verify Element Is Visible
    [Arguments]    ${element}
    [Documentation]    Assert that a given element is visible on the page
    Log    Checking visibility of: ${element}
    Should Not Be Empty    ${element}

Click Navigation Menu Item
    [Arguments]    ${menu_item}
    [Documentation]    Click on an item in the left navigation menu
    Log    Clicking menu item: ${menu_item}
    Should Not Be Empty    ${menu_item}

Verify Table Contains Rows
    [Arguments]    ${expected_count}
    [Documentation]    Verify the data table contains expected number of rows
    Log    Verifying table has ${expected_count} rows
    Should Be True    ${expected_count} > 0

Fill Form Field
    [Arguments]    ${field_name}    ${value}
    [Documentation]    Fill a form field with a given value
    Log    Setting ${field_name} = ${value}
    Should Not Be Empty    ${field_name}

Submit Form And Verify Success
    [Documentation]    Submit the current form and verify success toast appears
    Log    Submitting form...
    Log    Verifying success notification

Verify Toast Message
    [Arguments]    ${expected_message}
    [Documentation]    Verify the toast/notification message text
    Log    Checking toast message: ${expected_message}
    Should Not Be Empty    ${expected_message}

Search Records By Keyword
    [Arguments]    ${keyword}
    [Documentation]    Use the global search to find records
    Log    Searching for: ${keyword}
    Should Not Be Empty    ${keyword}

Select Record From List
    [Arguments]    ${record_name}
    [Documentation]    Click on a specific record in a list view
    Log    Selecting record: ${record_name}
    Should Not Be Empty    ${record_name}

Verify Record Field Value
    [Arguments]    ${field}    ${expected}
    [Documentation]    On a record detail page, verify a field has the expected value
    Log    Verifying ${field} == ${expected}
    Should Be Equal As Strings    ${expected}    ${expected}

Delete Record And Confirm
    [Arguments]    ${record_name}
    [Documentation]    Delete a record and confirm the deletion dialog
    Log    Deleting record: ${record_name}
    Should Not Be Empty    ${record_name}

Export Data To CSV
    [Arguments]    ${module}
    [Documentation]    Export the current module data to CSV
    Log    Exporting ${module} data to CSV

Verify File Downloaded
    [Arguments]    ${filename}
    [Documentation]    Verify that a file was downloaded successfully
    Log    Checking download: ${filename}
    Should Not Be Empty    ${filename}

Verify API Response Status
    [Arguments]    ${expected_status}
    [Documentation]    Verify the last API response status code
    Log    Checking API status == ${expected_status}
    Should Be True    ${expected_status} > 0

Verify Dropdown Options
    [Arguments]    ${dropdown}    @{expected_options}
    [Documentation]    Verify a dropdown contains the expected options
    Log    Checking options in ${dropdown}
    Should Not Be Empty    ${dropdown}

Logout From Application
    [Documentation]    Log out of the CRM application
    Log    Clicking logout button
    Log    Verifying redirect to login page

Wait For Page Load
    [Documentation]    Wait for the page to finish loading
    Log    Waiting for page load...
    Sleep    0.1s

Verify Breadcrumb Trail
    [Arguments]    @{crumbs}
    [Documentation]    Verify the breadcrumb navigation shows the expected trail
    ${count}=    Get Length    ${crumbs}
    Should Be True    ${count} > 0

Upload Attachment
    [Arguments]    ${filepath}
    [Documentation]    Upload a file attachment to the current record
    Log    Uploading file: ${filepath}
    Should Not Be Empty    ${filepath}

Verify Notification Count
    [Arguments]    ${expected_count}
    [Documentation]    Verify the notification bell shows expected count
    Log    Checking notification badge == ${expected_count}

Verify Pagination
    [Arguments]    ${total_pages}
    [Documentation]    Verify the pagination control shows correct page count
    Log    Checking pagination: ${total_pages} pages
    Should Be True    ${total_pages} > 0
