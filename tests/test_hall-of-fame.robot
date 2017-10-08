*** Settings ***

Resource  plone/app/robotframework/keywords.robot
Resource  ./keywords.robot

Suite Setup     Browser Setup
Suite Teardown  Browser Teardown

*** Test Cases ***

Test Hall of Fame
    Go to  ${PLONE_URL}/++themefragment++wall-of-fame
    Page should contain element  css=.wall-of-fame
