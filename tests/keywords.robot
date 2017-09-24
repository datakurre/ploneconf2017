*** Settings ***

Resource  plone/app/robotframework/keywords.robot
Library  ArchiveLibrary

*** Variables ***

@{DIMENSIONS}  1200  900
${USERNAME}  admin
${PASSWORD}  secret

*** Keywords ***

Browser Setup
    Open test browser
    Run keyword and ignore error  Set window size  @{DIMENSIONS}
    Update theme
    Go to  ${PLONE_URL}

Browser Teardown
    Close all browsers

Update Theme
    Create theme archive
    Upload theme archive

Create Theme Archive
    Create Zip From Files in Directory
    ...  ${CURDIR}/../resources/theme
    ...  ${CURDIR}/../demotheme.zip
    ...  sub_directories=True

Upload Theme Archive
    Log in  ${USERNAME}  ${PASSWORD}
    Go to  ${PLONE_URL}/@@theming-controlpanel
    Page should contain  Themes
    Click link  Upload Zip file
    Page should contain  Upload theme
    Choose file  css=.plone-modal-body #themeArchive  ${CURDIR}/../demotheme.zip
    Select checkbox  css=.plone-modal-body #enableNewTheme
    Select checkbox  css=.plone-modal-body #replaceExisting
    Click button  css=.plone-modal-body input.save
    Page should contain  Back to the control panel
    Go to  ${PLONE_URL}/logout
