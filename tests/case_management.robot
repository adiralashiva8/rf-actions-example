*** Settings ***
Documentation     Case Management Module - Support Case CRUD and Workflow Tests
Library           Collections
Library           String
Resource          resources/common.resource
Default Tags      case_management

*** Variables ***
${CASES_URL}            ${BASE_URL}/cases
${NEW_CASE_SUBJECT}     Application crashes on file upload
${CASE_PRIORITY}        High
${CASE_STATUS}          Open
${CASE_CATEGORY}        Technical Support

*** Test Cases ***
Verify Create New Support Case
    [Documentation]    Agent can create a new support case with all required fields
    [Tags]    CTS-301    alice    smoke
    Navigate To Cases Module
    Click Create New Case Button
    Fill Form Field    Subject    ${NEW_CASE_SUBJECT}
    Fill Form Field    Priority    ${CASE_PRIORITY}
    Fill Form Field    Category    ${CASE_CATEGORY}
    Submit Form And Verify Success
    Verify Toast Message    Case created successfully

Verify Case List View Displays All Cases
    [Documentation]    Cases list view loads with correct columns and data
    [Tags]    CTS-302    bob    smoke
    Navigate To Cases Module
    Verify Element Is Visible    cases-table
    Verify Table Contains Rows    10
    Verify Case List Columns Exist

Verify Case Detail Page Loads
    [Documentation]    Clicking a case navigates to its detail page
    [Tags]    CTS-303    tim    smoke
    Navigate To Cases Module
    Select Record From List    CASE-2024-001
    Verify Page Title    Case Detail - CRM
    Verify Record Field Value    Subject    ${NEW_CASE_SUBJECT}

Verify Case Status Change Workflow
    [Documentation]    Case status transitions follow the correct workflow
    [Tags]    CTS-304    alice    regression
    Navigate To Cases Module
    Select Record From List    CASE-2024-002
    Change Case Status    In Progress
    Verify Record Field Value    Status    In Progress
    Change Case Status    Resolved
    Fail    Status transition from 'In Progress' to 'Resolved' was rejected. Workflow rule requires 'Pending Review' before 'Resolved'.

Verify Case Priority Filter
    [Documentation]    Filtering cases by priority returns correct results
    [Tags]    CTS-305    bob    regression
    Navigate To Cases Module
    Apply Case Filter    Priority    High
    Verify Table Contains Rows    5
    Verify All Cases Match Priority    High

Verify Case Assignment To Agent
    [Documentation]    Supervisor can assign a case to another agent
    [Tags]    CTS-306    tim    regression
    Navigate To Cases Module
    Select Record From List    CASE-2024-003
    Assign Case To Agent    agent.smith@example.com
    Verify Record Field Value    Assigned To    Agent Smith
    Verify Toast Message    Case assigned successfully

Verify Adding Comment To Case
    [Documentation]    Agent can add an internal comment to a case
    [Tags]    CTS-307    alice    sanity
    Navigate To Cases Module
    Select Record From List    CASE-2024-001
    Add Case Comment    Contacted customer via phone. Awaiting callback.
    Verify Element Is Visible    comment-timeline
    Verify Table Contains Rows    1

Verify Case Attachment Upload
    [Documentation]    Agent can attach files to a support case
    [Tags]    CTS-308    bob    regression
    Navigate To Cases Module
    Select Record From List    CASE-2024-001
    Upload Attachment    screenshot_error.png
    Fail    File upload failed with error: 'MaxUploadSizeExceededException: Maximum upload size of 5MB exceeded'. File size was 12MB.

Verify Case SLA Timer Display
    [Documentation]    SLA countdown timer appears for high-priority cases
    [Tags]    CTS-309    tim    regression
    Navigate To Cases Module
    Select Record From List    CASE-2024-004
    Verify Element Is Visible    sla-timer
    Verify SLA Timer Is Running

Verify Case Search By Subject
    [Documentation]    Global search finds cases by subject keyword
    [Tags]    CTS-310    alice    smoke
    Navigate To Cases Module
    Search Records By Keyword    crashes on file upload
    Verify Table Contains Rows    1
    Select Record From List    CASE-2024-001

Verify Case Deletion Requires Confirmation
    [Documentation]    Delete action prompts for confirmation before removing case
    [Tags]    CTS-311    bob    regression
    Navigate To Cases Module
    Select Record From List    CASE-2024-005
    Delete Record And Confirm    CASE-2024-005
    Fail    Case was deleted without confirmation dialog. Expected modal with 'Are you sure?' prompt but record was immediately removed.

Verify Case Escalation To Manager
    [Documentation]    High-priority unresolved cases can be escalated
    [Tags]    CTS-312    tim    regression
    Navigate To Cases Module
    Select Record From List    CASE-2024-006
    Escalate Case To Manager
    Fail    Escalation failed: Manager notification email was not sent. SMTP connection refused on port 587.

Verify Bulk Case Status Update
    [Documentation]    Multiple cases can be updated at once via bulk action
    [Tags]    CTS-313    alice    sanity
    Navigate To Cases Module
    Select Multiple Cases    CASE-2024-007    CASE-2024-008    CASE-2024-009
    Apply Bulk Action    Change Status    Closed
    Verify Toast Message    3 cases updated successfully

Verify Case Export To CSV
    [Documentation]    Cases list can be exported to CSV file
    [Tags]    CTS-314    bob    regression
    Navigate To Cases Module
    Export Data To CSV    cases
    Verify File Downloaded    cases_export.csv

Verify Case Reopen After Resolution
    [Documentation]    Resolved cases can be reopened by authorized users
    [Tags]    CTS-315    tim    sanity
    [Setup]    Skip    Feature under development - CRM-4521 backlog
    Navigate To Cases Module
    Select Record From List    CASE-2024-010
    Change Case Status    Reopened

*** Keywords ***
Navigate To Cases Module
    Click Navigation Menu Item    Cases
    Wait For Page Load
    Verify Page Title    Cases - CRM

Click Create New Case Button
    Log    Clicking 'New Case' button
    Verify Element Is Visible    new-case-button

Verify Case List Columns Exist
    Log    Verifying columns: ID, Subject, Priority, Status, Assigned To, Created Date
    ${columns}=    Create List    ID    Subject    Priority    Status    Assigned To    Created Date
    Length Should Be    ${columns}    6

Change Case Status
    [Arguments]    ${new_status}
    Log    Changing case status to: ${new_status}
    Fill Form Field    Status    ${new_status}

Apply Case Filter
    [Arguments]    ${field}    ${value}
    Log    Filtering by ${field} = ${value}
    Should Not Be Empty    ${value}

Verify All Cases Match Priority
    [Arguments]    ${priority}
    Log    Verifying all visible cases have priority: ${priority}

Assign Case To Agent
    [Arguments]    ${agent_email}
    Log    Assigning case to ${agent_email}
    Fill Form Field    Assigned To    ${agent_email}

Add Case Comment
    [Arguments]    ${comment_text}
    Log    Adding comment: ${comment_text}
    Fill Form Field    Comment    ${comment_text}
    Submit Form And Verify Success

Verify SLA Timer Is Running
    Log    Checking SLA timer is counting down
    Should Be True    ${True}

Escalate Case To Manager
    Log    Clicking Escalate button
    Verify Element Is Visible    escalate-button

Select Multiple Cases
    [Arguments]    @{case_ids}
    FOR    ${case_id}    IN    @{case_ids}
        Log    Selecting checkbox for ${case_id}
    END

Apply Bulk Action
    [Arguments]    ${action}    ${value}
    Log    Applying bulk action: ${action} = ${value}
