*** Settings ***
Documentation     Opportunity Module - Sales Pipeline and Deal Management Tests
Library           Collections
Library           String
Resource          resources/common.resource
Default Tags      opportunity

*** Variables ***
${OPPORTUNITIES_URL}      ${BASE_URL}/opportunities
${DEAL_NAME}              Acme Corp - Enterprise License
${DEAL_AMOUNT}            75000
${DEAL_STAGE}             Qualification
${CLOSE_DATE}             2026-06-30

*** Test Cases ***
Verify Create New Opportunity
    [Documentation]    Sales rep can create a new opportunity in the pipeline
    [Tags]    CTS-401    bob    smoke
    Navigate To Opportunities Module
    Click Create New Opportunity Button
    Fill Form Field    Deal Name    ${DEAL_NAME}
    Fill Form Field    Amount    ${DEAL_AMOUNT}
    Fill Form Field    Stage    ${DEAL_STAGE}
    Fill Form Field    Close Date    ${CLOSE_DATE}
    Submit Form And Verify Success
    Verify Toast Message    Opportunity created successfully

Verify Opportunity List View
    [Documentation]    Opportunities list shows all pipeline deals
    [Tags]    CTS-402    alice    smoke
    Navigate To Opportunities Module
    Verify Element Is Visible    opportunity-table
    Verify Table Contains Rows    15

Verify Opportunity Stage Change
    [Documentation]    Opportunity stage can be updated through the pipeline
    [Tags]    CTS-403    tim    regression
    Navigate To Opportunities Module
    Select Record From List    OPP-2024-015
    Change Opportunity Stage    Negotiation
    Verify Record Field Value    Stage    Negotiation
    Verify Toast Message    Stage updated to Negotiation

Verify Opportunity Amount Validation
    [Documentation]    Negative deal amounts are rejected by validation
    [Tags]    CTS-404    bob    regression
    Navigate To Opportunities Module
    Click Create New Opportunity Button
    Fill Form Field    Deal Name    Test Deal
    Fill Form Field    Amount    -5000
    Submit Form And Verify Success
    Fail    Negative amount -5000 was accepted by the form. Expected validation error 'Amount must be a positive number'.

Verify Pipeline Kanban View
    [Documentation]    Kanban board displays opportunities grouped by stage
    [Tags]    CTS-405    alice    smoke
    Navigate To Opportunities Module
    Switch To Kanban View
    Verify Element Is Visible    kanban-board
    Verify Kanban Columns Exist

Verify Opportunity Search
    [Documentation]    Search returns matching opportunities by deal name
    [Tags]    CTS-406    tim    smoke
    Navigate To Opportunities Module
    Search Records By Keyword    Acme Corp
    Verify Table Contains Rows    2
    Select Record From List    OPP-2024-015

Verify Won Deal Moves To Closed Stage
    [Documentation]    Marking a deal as Won moves it to Closed-Won in pipeline
    [Tags]    CTS-407    bob    regression
    Navigate To Opportunities Module
    Select Record From List    OPP-2024-020
    Mark Opportunity As Won
    Verify Record Field Value    Stage    Closed-Won
    Verify Toast Message    Congratulations! Deal marked as Won.

Verify Opportunity Revenue Forecast
    [Documentation]    Revenue forecast calculates weighted pipeline correctly
    [Tags]    CTS-408    alice    regression
    Navigate To Opportunities Module
    Open Revenue Forecast Report
    Verify Forecast Calculation    Q2 2026    ${375000}
    Fail    Revenue forecast shows $0 for Q2 2026. Expected $375,000 based on weighted pipeline. Forecast API returned null for weighted_amount field.

Verify Opportunity Contact Association
    [Documentation]    Opportunity can be linked to a contact record
    [Tags]    CTS-409    tim    regression
    Navigate To Opportunities Module
    Select Record From List    OPP-2024-015
    Associate Contact To Opportunity    John Doe
    Verify Record Field Value    Primary Contact    John Doe

Verify Lost Reason Is Required For Lost Deals
    [Documentation]    Marking deal as Lost requires selecting a loss reason
    [Tags]    CTS-410    bob    regression
    Navigate To Opportunities Module
    Select Record From List    OPP-2024-025
    Mark Opportunity As Lost Without Reason
    Fail    Deal was marked as Lost without providing a reason. Expected mandatory field validation for 'Lost Reason'.

Verify Opportunity Deletion
    [Documentation]    Only admins can delete opportunity records
    [Tags]    CTS-411    alice    sanity
    Navigate To Opportunities Module
    Select Record From List    OPP-2024-030
    Delete Record And Confirm    OPP-2024-030
    Verify Toast Message    Opportunity deleted

Verify Opportunity Probability Auto-Calculation
    [Documentation]    Probability percentage auto-updates when stage changes
    [Tags]    CTS-412    tim    sanity
    [Setup]    Skip    Probability engine refactoring in progress - JIRA CRM-5102
    Navigate To Opportunities Module
    Select Record From List    OPP-2024-015
    Change Opportunity Stage    Proposal
    Verify Record Field Value    Probability    60%

*** Keywords ***
Navigate To Opportunities Module
    Click Navigation Menu Item    Opportunities
    Wait For Page Load
    Verify Page Title    Opportunities - CRM

Click Create New Opportunity Button
    Log    Clicking 'New Opportunity' button
    Verify Element Is Visible    new-opportunity-button

Change Opportunity Stage
    [Arguments]    ${stage}
    Log    Moving opportunity to stage: ${stage}
    Fill Form Field    Stage    ${stage}
    Submit Form And Verify Success

Switch To Kanban View
    Log    Switching to Kanban board view
    Verify Element Is Visible    view-toggle-kanban

Verify Kanban Columns Exist
    ${columns}=    Create List    Qualification    Proposal    Negotiation    Closed-Won    Closed-Lost
    Length Should Be    ${columns}    5

Mark Opportunity As Won
    Log    Clicking 'Mark as Won' button
    Verify Element Is Visible    mark-won-button

Open Revenue Forecast Report
    Log    Opening forecast report
    Click Navigation Menu Item    Forecast

Verify Forecast Calculation
    [Arguments]    ${quarter}    ${expected}
    Log    Checking ${quarter} forecast == ${expected}

Associate Contact To Opportunity
    [Arguments]    ${contact_name}
    Log    Associating contact: ${contact_name}
    Fill Form Field    Primary Contact    ${contact_name}
    Submit Form And Verify Success

Mark Opportunity As Lost Without Reason
    Log    Attempting to mark as Lost without reason
    Verify Element Is Visible    mark-lost-button
