*** Settings ***

Resource  plone/app/robotframework/keywords.robot
Resource  ./keywords.robot

Suite Setup     Browser Setup
Suite Teardown  Browser Teardown

*** Test Cases ***

Test Hello World
    Go to  ${PLONE_URL}/@@theme-fragment/hello-world
    Page should contain  Hello World!
