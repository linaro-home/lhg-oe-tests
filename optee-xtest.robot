*** Settings ***
Documentation     This test executing OPTEE "xtestx" on a remote machine
...               and getting the test result.
Suite Setup       Run Keywords    Open Connection And Log In    Run Tee Supplicant
Suite Teardown    Run Keywords    Terminate Tee Supplicant    Close All Connections
Library           SSHLibrary
Library           String

*** Variables ***
${HOST}           192.168.29.110
${USERNAME}       root
${PASSWORD}       ${EMPTY}
${HIKEY_PROMPT}    root@hikey:~#

*** Test Cases ***
Execute xtest regression test
    [Documentation]    Execute "xtest -t regression"
    Set Client Configuration    timeout=40s    prompt=${HIKEY_PROMPT}
    Run Regression Test
    ${result}    Read Until Prompt
    Should Contain    ${result}    TEE test application done!

Execute xtest benchmark test
    [Documentation]    Execute "xtest -t benchmark"
    Set Client Configuration    timeout=10s    prompt=${HIKEY_PROMPT}
    Run Benchmark Test
    ${result}    Read Until Prompt
    Should Contain    ${result}    TEE test application done!

*** Keywords ***
Open Connection And Log In
    Open Connection    ${HOST}
    Login    ${USERNAME}    ${PASSWORD}

Run Tee Supplicant
    Start Command    /usr/bin/tee-supplicant

Terminate Tee Supplicant
    Start Command    pkill tee-supplicant

Run Regression Test
    write    xtest -t regression

Run Benchmark Test
    write    xtest -t benchmark
