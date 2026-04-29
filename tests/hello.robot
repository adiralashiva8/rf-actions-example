*** Settings ***
Library    BuiltIn
Library    String
Library    Collections

*** Test Cases ***
Test Case 001 - String Conversion Positive
    [Tags]    positive    string-operations    owner:team-a
    ${result}=    Convert To String    12345
    Should Be Equal    ${result}    12345

Test Case 002 - List Length Positive
    [Tags]    positive    list-operations    owner:team-b
    ${list}=    Create List    item1    item2    item3
    ${length}=    Get Length    ${list}
    Should Be Equal As Integers    ${length}    3

Test Case 003 - String Contains Negative
    [Tags]    negative    string-operations    owner:team-a
    ${text}=    Set Variable    Hello World
    Run Keyword And Expect Error    *    Should Contain    ${text}    NotFound

Test Case 004 - Dictionary Access Fail
    [Tags]    fail    dict-operations    owner:team-c
    ${dict}=    Create Dictionary    key1=value1    key2=value2
    Should Be Equal    ${dict}[key1]    wrong_value

Test Case 005 - List Operations Pass
    [Tags]    pass    list-operations    owner:team-b
    ${list}=    Create List    a    b    c
    List Should Contain Value    ${list}    b
    Should Be Equal As Integers    ${list}[0]    a

Test Case 006 - Skip Test Demo
    [Tags]    skip    owner:team-a
    Skip    Skipped for demonstration purposes

Test Case 007 - String Format Error
    [Tags]    error    string-operations    owner:team-c
    ${result}=    Get Substring    invalid    10    20

Test Case 008 - Append To List Positive
    [Tags]    positive    list-operations    owner:team-b
    ${list}=    Create List    1    2    3
    Append To List    ${list}    4
    Should Be Equal As Integers    ${list}[3]    4

Test Case 009 - Convert To Integer Negative
    [Tags]    negative    conversion    owner:team-a
    Run Keyword And Expect Error    *    Convert To Integer    not_a_number

Test Case 010 - Remove Duplicates Fail
    [Tags]    fail    list-operations    owner:team-c
    ${list}=    Create List    a    b    a    c
    ${unique}=    Remove Duplicates    ${list}
    Should Be Equal As Integers    ${unique}    3

Test Case 011 - Log Message Pass
    [Tags]    pass    debug    owner:team-b
    Log    This is a debug message    INFO
    Should Be Equal    1+1    2

Test Case 012 - Dictionary Keys Error
    [Tags]    error    dict-operations    owner:team-a
    ${dict}=    Create Dictionary
    ${keys}=    Get Dictionary Keys    ${dict}[nonexistent]

Test Case 013 - String Uppercase Positive
    [Tags]    positive    string-operations    owner:team-b
    ${result}=    Convert To Uppercase    hello
    Should Be Equal    ${result}    HELLO

Test Case 014 - List Index Out Of Bounds Negative
    [Tags]    negative    list-operations    owner:team-c
    ${list}=    Create List    a    b    c
    Run Keyword And Expect Error    *    Get From List    ${list}    99

Test Case 015 - Should Be Equal Fail
    [Tags]    fail    comparison    owner:team-a
    Should Be Equal    actual_value    expected_different_value
