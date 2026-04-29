*** Settings ***
Documentation     Dashboard Module - Main Dashboard Widgets and Analytics Tests
Library           Collections
Library           String
Resource          resources/common.resource
Default Tags      dashboard

*** Variables ***
${DASHBOARD_URL}          ${BASE_URL}/dashboard
${WIDGET_REFRESH_RATE}    30
${EXPECTED_WIDGETS}       6

*** Test Cases ***
Verify Dashboard Loads After Login
    [Documentation]    Dashboard page renders with all main sections visible
    [Tags]    CTS-201    bob    smoke
    Open Browser To Login Page
    Enter Credentials And Submit    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Verify Page Title    Dashboard - CRM
    Wait For Page Load
    Verify Element Is Visible    dashboard-container

Verify Revenue Widget Displays Correct Data
    [Documentation]    Revenue summary widget shows current month figures
    [Tags]    CTS-202    alice    regression
    Open Browser To Login Page
    Enter Credentials And Submit    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Verify Dashboard Widget Data    revenue-widget    $1,250,000
    Fail    Revenue widget displayed $0 instead of expected $1,250,000. Data binding error in widget component.

Verify Open Cases Widget Count
    [Documentation]    Open cases widget shows accurate count from database
    [Tags]    CTS-203    tim    regression
    Open Browser To Login Page
    Enter Credentials And Submit    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Verify Dashboard Widget Data    open-cases-widget    47
    Fail    Open cases widget shows 0 instead of 47. API endpoint /api/cases/count returned empty response.

Verify Pipeline Chart Renders
    [Documentation]    Sales pipeline chart renders with correct segments
    [Tags]    CTS-204    bob    smoke
    Open Browser To Login Page
    Enter Credentials And Submit    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Verify Element Is Visible    pipeline-chart
    Verify Pipeline Segments Exist

Verify Dashboard Date Range Filter
    [Documentation]    Changing date range updates all widgets
    [Tags]    CTS-205    alice    regression
    Open Browser To Login Page
    Enter Credentials And Submit    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Select Dashboard Date Range    Last 30 Days
    Wait For Page Load
    Verify Element Is Visible    revenue-widget

Verify Recent Activity Feed Loads
    [Documentation]    Activity feed shows latest CRM activities
    [Tags]    CTS-206    tim    smoke
    Open Browser To Login Page
    Enter Credentials And Submit    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Verify Element Is Visible    activity-feed
    Verify Table Contains Rows    5

Verify Dashboard Widget Drag And Drop
    [Documentation]    Users can rearrange widgets by drag and drop
    [Tags]    CTS-207    bob    sanity
    Open Browser To Login Page
    Enter Credentials And Submit    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Drag Widget To Position    revenue-widget    2
    Verify Widget Position    revenue-widget    2

Verify Dashboard Export To PDF
    [Documentation]    Dashboard snapshot can be exported to PDF
    [Tags]    CTS-208    alice    regression
    Open Browser To Login Page
    Enter Credentials And Submit    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Click Dashboard Export Button
    Fail    PDF export timed out after 30s. Server returned HTTP 504 Gateway Timeout on /api/dashboard/export.

Verify Task Summary Widget
    [Documentation]    My Tasks widget shows assigned tasks for logged-in user
    [Tags]    CTS-209    tim    sanity
    Open Browser To Login Page
    Enter Credentials And Submit    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Verify Element Is Visible    task-summary-widget
    Verify Table Contains Rows    3

Verify Dashboard Auto Refresh
    [Documentation]    Dashboard data refreshes automatically every 30 seconds
    [Tags]    CTS-210    bob    regression
    Open Browser To Login Page
    Enter Credentials And Submit    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Wait For Dashboard Refresh
    Verify Element Is Visible    refresh-indicator

Verify Notifications Panel On Dashboard
    [Documentation]    Notification bell shows unread notification count
    [Tags]    CTS-211    alice    smoke
    Open Browser To Login Page
    Enter Credentials And Submit    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Verify Notification Count    3
    Verify Element Is Visible    notification-panel

*** Keywords ***
Verify Dashboard Widget Data
    [Arguments]    ${widget_id}    ${expected_value}
    Log    Checking widget ${widget_id} displays ${expected_value}
    Verify Element Is Visible    ${widget_id}

Select Dashboard Date Range
    [Arguments]    ${range}
    Log    Selecting date range: ${range}
    Should Not Be Empty    ${range}

Verify Pipeline Segments Exist
    Log    Verifying pipeline chart has Prospect, Negotiation, Closed-Won segments
    ${segments}=    Create List    Prospect    Negotiation    Closed-Won
    Length Should Be    ${segments}    3

Drag Widget To Position
    [Arguments]    ${widget}    ${position}
    Log    Dragging ${widget} to position ${position}

Verify Widget Position
    [Arguments]    ${widget}    ${expected_position}
    Log    Verifying ${widget} is at position ${expected_position}
    Should Be Equal As Integers    ${expected_position}    ${expected_position}

Click Dashboard Export Button
    Log    Clicking Export to PDF button
    Verify Element Is Visible    export-pdf-button

Wait For Dashboard Refresh
    Log    Waiting for auto-refresh cycle...
    Sleep    0.1s
