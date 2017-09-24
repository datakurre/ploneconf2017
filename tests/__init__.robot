*** Settings ***

Resource  plone/app/robotframework/server.robot
Library  Selenium2Library

Suite Setup  Plone Setup
Suite Teardown  Plone Teardown

*** Variables ***

${FIXTURE}  plone.app.robotframework.testing.PLONE_ROBOT_TESTING
@{DIMENSIONS}  1200  900
@{CONFIGURE_PACKAGES}  collective.themefragments  collective.themesitesetup

*** Keywords ***

Plone Setup
    Setup Plone site  ${FIXTURE}
    Close all browsers

Plone Teardown
    Teardown Plone Site
