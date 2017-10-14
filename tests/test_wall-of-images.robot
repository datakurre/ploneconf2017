*** Settings ***

Resource  plone/app/robotframework/keywords.robot
Resource  ./keywords.robot

Suite Setup     Browser Setup
Suite Teardown  Browser Teardown

*** Test Cases ***

Test Wall of images
    Go to  ${PLONE_URL}/++themefragment++wall-of-images
    Page should contain element  css=.wall-of-images
