*** Test Cases ***
Test Case 1
    Log    This is test case 1
    Should Be Equal    ${1}    ${1}

Test Case 2
    Log    This is test case 2
    Should Be Equal    hello    hello

Test Case 3
    Log    This is test case 3
    Should Contain    robot framework    robot

Test Case 4
    Log    This is test case 4
    Should Not Be Empty    test data
