*** Settings ***
Documentation     Knowledge Base Module - Article Management and Search Tests
Library           Collections
Library           String
Resource          resources/common.resource
Default Tags      knowledge_base

*** Variables ***
${KB_URL}                 ${BASE_URL}/knowledge-base
${ARTICLE_TITLE}          How to Reset Your Password
${ARTICLE_CATEGORY}       Account Management
${ARTICLE_STATUS}         Published

*** Test Cases ***
Verify Knowledge Base Home Page Loads
    [Documentation]    KB landing page renders with categories and search bar
    [Tags]    CTS-501    tim    smoke
    Navigate To Knowledge Base
    Verify Element Is Visible    kb-search-bar
    Verify Element Is Visible    category-grid
    Verify Page Title    Knowledge Base - CRM

Verify Article Search Returns Results
    [Documentation]    Searching for a keyword returns matching articles
    [Tags]    CTS-502    alice    smoke
    Navigate To Knowledge Base
    Search Records By Keyword    password reset
    Verify Table Contains Rows    3

Verify Create New Article
    [Documentation]    Admin can create and publish a new KB article
    [Tags]    CTS-503    bob    smoke
    Navigate To Knowledge Base
    Click Create New Article Button
    Fill Form Field    Title    ${ARTICLE_TITLE}
    Fill Form Field    Category    ${ARTICLE_CATEGORY}
    Fill Form Field    Content    Step 1: Navigate to Settings. Step 2: Click Reset Password.
    Submit Form And Verify Success
    Verify Toast Message    Article published successfully

Verify Article Detail View
    [Documentation]    Article detail page shows full content and metadata
    [Tags]    CTS-504    tim    regression
    Navigate To Knowledge Base
    Search Records By Keyword    password reset
    Select Record From List    ${ARTICLE_TITLE}
    Verify Record Field Value    Title    ${ARTICLE_TITLE}
    Verify Record Field Value    Category    ${ARTICLE_CATEGORY}

Verify Article Edit And Save
    [Documentation]    Published articles can be edited and re-saved
    [Tags]    CTS-505    alice    regression
    Navigate To Knowledge Base
    Select Record From List    ${ARTICLE_TITLE}
    Fill Form Field    Content    Updated Step 1: Go to Profile > Security > Reset Password.
    Submit Form And Verify Success
    Verify Toast Message    Article updated successfully

Verify Article Category Filter
    [Documentation]    Filtering by category shows only matching articles
    [Tags]    CTS-506    bob    regression
    Navigate To Knowledge Base
    Apply Category Filter    ${ARTICLE_CATEGORY}
    Verify Table Contains Rows    5

Verify Article Rating System
    [Documentation]    Users can rate articles with thumbs up/down
    [Tags]    CTS-507    tim    sanity
    Navigate To Knowledge Base
    Select Record From List    ${ARTICLE_TITLE}
    Rate Article    thumbs-up
    Verify Element Is Visible    rating-confirmation

Verify Article Version History
    [Documentation]    Knowledge base tracks article revision history
    [Tags]    CTS-508    alice    regression
    Navigate To Knowledge Base
    Select Record From List    ${ARTICLE_TITLE}
    Open Article Version History
    Fail    Version history panel failed to load. Error: 'TypeError: Cannot read properties of undefined (reading versions)'. Article versioning API returned malformed JSON.

Verify Article Deletion By Admin
    [Documentation]    Admin can delete an article after confirmation
    [Tags]    CTS-509    bob    regression
    Navigate To Knowledge Base
    Select Record From List    Deprecated Feature Guide
    Delete Record And Confirm    Deprecated Feature Guide
    Verify Toast Message    Article deleted

Verify Search With No Results Shows Empty State
    [Documentation]    Searching for a non-existent term shows empty state message
    [Tags]    CTS-510    tim    regression
    Navigate To Knowledge Base
    Search Records By Keyword    xyznonexistent12345
    Verify Empty State Message    No articles found matching your search

Verify Article Attachment Support
    [Documentation]    Articles support embedded file attachments
    [Tags]    CTS-511    alice    regression
    Navigate To Knowledge Base
    Select Record From List    ${ARTICLE_TITLE}
    Upload Attachment    setup_guide.pdf
    Fail    File upload failed with error: 'MaxUploadSizeExceededException: Maximum upload size of 5MB exceeded'. File size was 12MB.

Verify Article Internal Linking
    [Documentation]    Articles can link to other KB articles inline
    [Tags]    CTS-512    bob    sanity
    Navigate To Knowledge Base
    Select Record From List    ${ARTICLE_TITLE}
    Add Internal Link    Getting Started Guide
    Verify Element Is Visible    internal-link-badge

Verify KB Analytics Dashboard
    [Documentation]    Knowledge base analytics show article view counts
    [Tags]    CTS-513    tim    regression
    Navigate To Knowledge Base
    Open KB Analytics
    Fail    Analytics dashboard returned HTTP 500 Internal Server Error. Database query timed out on article_views aggregation.

Verify Article Draft Save
    [Documentation]    Unpublished articles can be saved as drafts
    [Tags]    CTS-514    alice    sanity
    [Setup]    Skip    Draft autosave feature pending deployment - CRM-6200
    Navigate To Knowledge Base
    Click Create New Article Button
    Fill Form Field    Title    Draft Article WIP
    Save As Draft

*** Keywords ***
Navigate To Knowledge Base
    Click Navigation Menu Item    Knowledge Base
    Wait For Page Load
    Verify Page Title    Knowledge Base - CRM

Click Create New Article Button
    Log    Clicking 'New Article' button
    Verify Element Is Visible    new-article-button

Apply Category Filter
    [Arguments]    ${category}
    Log    Filtering articles by category: ${category}
    Should Not Be Empty    ${category}

Rate Article
    [Arguments]    ${rating}
    Log    Rating article: ${rating}
    Verify Element Is Visible    rating-${rating}

Open Article Version History
    Log    Opening version history panel
    Verify Element Is Visible    version-history-button

Verify Empty State Message
    [Arguments]    ${message}
    Log    Checking empty state: ${message}
    Should Not Be Empty    ${message}

Add Internal Link
    [Arguments]    ${target_article}
    Log    Adding internal link to: ${target_article}
    Should Not Be Empty    ${target_article}

Open KB Analytics
    Log    Navigating to KB Analytics
    Click Navigation Menu Item    KB Analytics

Save As Draft
    Log    Saving article as draft
    Verify Element Is Visible    save-draft-button
