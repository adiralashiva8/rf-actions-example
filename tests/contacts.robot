*** Settings ***
Documentation     Contacts Module - Contact Management and Communication Tests
Library           Collections
Library           String
Resource          resources/common.resource
Default Tags      contacts

*** Variables ***
${CONTACTS_URL}          ${BASE_URL}/contacts
${CONTACT_FIRST}         Jane
${CONTACT_LAST}          Morrison
${CONTACT_EMAIL}         jane.morrison@acmecorp.com
${CONTACT_PHONE}         +1-555-0142
${CONTACT_COMPANY}       Acme Corporation

*** Test Cases ***
Verify Create New Contact
    [Documentation]    User can create a new contact with all required fields
    [Tags]    CTS-601    alice    smoke
    Navigate To Contacts Module
    Click Create New Contact Button
    Fill Form Field    First Name    ${CONTACT_FIRST}
    Fill Form Field    Last Name    ${CONTACT_LAST}
    Fill Form Field    Email    ${CONTACT_EMAIL}
    Fill Form Field    Phone    ${CONTACT_PHONE}
    Fill Form Field    Company    ${CONTACT_COMPANY}
    Submit Form And Verify Success
    Verify Toast Message    Contact created successfully

Verify Contact List View
    [Documentation]    Contacts list view loads with proper pagination
    [Tags]    CTS-602    bob    smoke
    Navigate To Contacts Module
    Verify Element Is Visible    contacts-table
    Verify Table Contains Rows    25
    Verify Pagination    5

Verify Contact Detail Page
    [Documentation]    Contact detail page displays all fields correctly
    [Tags]    CTS-603    tim    smoke
    Navigate To Contacts Module
    Select Record From List    Jane Morrison
    Verify Record Field Value    First Name    ${CONTACT_FIRST}
    Verify Record Field Value    Last Name    ${CONTACT_LAST}
    Verify Record Field Value    Email    ${CONTACT_EMAIL}

Verify Contact Email Validation
    [Documentation]    Invalid email format is rejected during contact creation
    [Tags]    CTS-604    alice    regression
    Navigate To Contacts Module
    Click Create New Contact Button
    Fill Form Field    First Name    Test
    Fill Form Field    Last Name    User
    Fill Form Field    Email    not-a-valid-email
    Submit Form And Verify Success
    Fail    Invalid email 'not-a-valid-email' was accepted. Expected validation error 'Please enter a valid email address'.

Verify Contact Phone Format Validation
    [Documentation]    Phone field validates format on save
    [Tags]    CTS-605    bob    regression
    Navigate To Contacts Module
    Click Create New Contact Button
    Fill Form Field    First Name    Test
    Fill Form Field    Last Name    Phone
    Fill Form Field    Phone    abc-not-a-phone
    Submit Form And Verify Success
    Fail    Invalid phone 'abc-not-a-phone' was accepted. Expected validation error 'Please enter a valid phone number'.

Verify Contact Search By Name
    [Documentation]    Global search finds contacts by name
    [Tags]    CTS-606    tim    smoke
    Navigate To Contacts Module
    Search Records By Keyword    Morrison
    Verify Table Contains Rows    1
    Select Record From List    Jane Morrison

Verify Contact Edit And Save
    [Documentation]    Existing contact can be edited and changes are saved
    [Tags]    CTS-607    alice    regression
    Navigate To Contacts Module
    Select Record From List    Jane Morrison
    Fill Form Field    Phone    +1-555-0199
    Submit Form And Verify Success
    Verify Record Field Value    Phone    +1-555-0199
    Verify Toast Message    Contact updated successfully

Verify Duplicate Contact Detection
    [Documentation]    System warns when creating a contact with duplicate email
    [Tags]    CTS-608    bob    regression
    Navigate To Contacts Module
    Click Create New Contact Button
    Fill Form Field    First Name    Jane
    Fill Form Field    Last Name    Morrison
    Fill Form Field    Email    ${CONTACT_EMAIL}
    Submit Form And Verify Success
    Fail    Duplicate contact was created without warning. Expected duplicate detection for email '${CONTACT_EMAIL}'.

Verify Contact Activity Timeline
    [Documentation]    Contact detail shows activity history timeline
    [Tags]    CTS-609    tim    sanity
    Navigate To Contacts Module
    Select Record From List    Jane Morrison
    Verify Element Is Visible    activity-timeline
    Verify Table Contains Rows    8

Verify Contact Import From CSV
    [Documentation]    Contacts can be bulk imported from CSV file
    [Tags]    CTS-610    alice    regression
    Navigate To Contacts Module
    Import Contacts From CSV    contacts_import.csv
    Fail    CSV import failed on row 45: 'UnicodeDecodeError: utf-8 codec cannot decode byte 0xff at position 0'. File contains non-UTF-8 characters.

Verify Contact Export To CSV
    [Documentation]    Contact list can be exported to CSV
    [Tags]    CTS-611    bob    sanity
    Navigate To Contacts Module
    Export Data To CSV    contacts
    Verify File Downloaded    contacts_export.csv

Verify Contact Deletion
    [Documentation]    Contact can be deleted with confirmation
    [Tags]    CTS-612    tim    regression
    Navigate To Contacts Module
    Select Record From List    Deprecated Contact
    Delete Record And Confirm    Deprecated Contact
    Verify Toast Message    Contact deleted

Verify Contact Merge Duplicates
    [Documentation]    Admin can merge two duplicate contact records
    [Tags]    CTS-613    alice    regression
    Navigate To Contacts Module
    Select Contacts For Merge    Jane Morrison    Jane M Morrison
    Confirm Merge Contacts
    Fail    Merge operation failed: 'IntegrityConstraintViolationException: Duplicate key value violates unique constraint on contact_email'. Database rollback triggered.

Verify Contact Tag Assignment
    [Documentation]    Tags can be added to contacts for categorization
    [Tags]    CTS-614    bob    sanity
    Navigate To Contacts Module
    Select Record From List    Jane Morrison
    Add Tag To Contact    VIP
    Add Tag To Contact    Enterprise
    Verify Element Is Visible    tag-VIP
    Verify Element Is Visible    tag-Enterprise

Verify Contact Notes Section
    [Documentation]    Notes can be added to a contact record
    [Tags]    CTS-615    tim    sanity
    [Setup]    Skip    Notes rich text editor migration in progress - CRM-7001
    Navigate To Contacts Module
    Select Record From List    Jane Morrison
    Add Contact Note    Discussed renewal pricing for Q3

*** Keywords ***
Navigate To Contacts Module
    Click Navigation Menu Item    Contacts
    Wait For Page Load
    Verify Page Title    Contacts - CRM

Click Create New Contact Button
    Log    Clicking 'New Contact' button
    Verify Element Is Visible    new-contact-button

Import Contacts From CSV
    [Arguments]    ${filename}
    Log    Importing contacts from ${filename}
    Verify Element Is Visible    import-csv-button

Select Contacts For Merge
    [Arguments]    ${contact1}    ${contact2}
    Log    Selecting ${contact1} and ${contact2} for merge
    Select Record From List    ${contact1}

Confirm Merge Contacts
    Log    Confirming merge operation
    Verify Element Is Visible    merge-confirm-button

Add Tag To Contact
    [Arguments]    ${tag}
    Log    Adding tag: ${tag}
    Should Not Be Empty    ${tag}

Add Contact Note
    [Arguments]    ${note_text}
    Log    Adding note: ${note_text}
    Fill Form Field    Note    ${note_text}
    Submit Form And Verify Success
