*** Settings ***
Library    Collections
Library    String
Library    HttpLibrary.HTTP
Library    RequestsLibrary

*** Variables ***
${url}    http://data.tmd.go.th/api

@{header_response}        Title    Description    Uri    LastBuiltDate
...    CopyRight    Generator
@{stations_response}        WmoNumber    StationNameTh    StationNameEng
...    Province    Latitude    Longitude    Observe

#https://medium.com/@popphoenix/robot-framework-test-api-1-5938a271daf
#robot -d Results Tests/example_script.robot
*** Test Cases ***
Get Weather3Hours Should Success and return data
    &{params}=    Create Dictionary    type=json
    ${resp}=    Get Weather3Hours    ${params}
    #Log Json    ${resp.content}
    Response Status should be Success    ${resp}
    ${header}=    Get Json Value and convert to Object    ${resp.content}    /Header
    Response Should Contain Keys    ${header}    ${header_response}
    ${stations}=    Get Json Value and convert to Object    ${resp.content}    /Stations
    ${len}=    Get Length    ${stations}
    Run Keyword If    ${len} > 0    Response Should Contain Keys    @{stations}[0]    ${stations_response}

Get Weather3Hours BANGKOK METROPOLIS Should Success and return data
    &{params} =    Create Dictionary
    ...    type=json
    ...    province=กรุงเทพมหานคร
    ${resp}=    Get Weather3Hours    ${params}
    # ${resp}=    Get Weather3Hours JSON    ${params}
    #Log Json    ${resp.content}
    Response Status should be Success    ${resp}
    ${header}=    Get Json Value and convert to Object    ${resp.content}    /Header
    Response Should Contain Keys    ${header}    ${header_response}
    ${stations}=    Get Json Value and convert to Object    ${resp.content}    /Stations
    ${len}=    Get Length    ${stations}
    Run Keyword If    ${len} > 0    Response Should Contain Keys    @{stations}[0]    ${stations_response}

*** Keywords ***
Response Status should be Success
    [Arguments]    ${resp}
    Should Be Equal As Strings    ${resp.status_code}    200

Get Json Value and convert to Object
    [Arguments]    ${json_string}    ${path}
    ${value}=    Get Json Value    ${json_string}    ${path}
    ${value}=    Parse Json    ${value}
    Return From Keyword    ${value}

Response Should Contain Keys
    [Arguments]    ${object}    ${expected_keys}
    ${object_keys}    Get Dictionary Keys    ${object}
    Sort List    ${object_keys}
    Sort List    ${expected_keys}
    Log List    ${object_keys}
    Log List    ${expected_keys}
    Lists Should Be Equal    ${object_keys}    ${expected_keys}

Get Weather3Hours
    [Arguments]    ${params}
    Create Session    tmd    ${url}
    ${resp}=    Get Request    tmd    /Weather3Hours/V1    params=${params}
    Return From Keyword    ${resp}

Get Weather3Hours JSON
    [Arguments]    ${params}
    Create Session    tmd    ${url}
    ${resp}=    Get Request    tmd    /Weather3Hours/V1?type=json    params=${params}
    Return From Keyword    ${resp}

Get Weather3Hours JSON no params
    Create Session    tmd    ${url}
    ${resp}=    Get Request    tmd    /Weather3Hours/V1?type=json
    Return From Keyword    ${resp}