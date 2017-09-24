#!/usr/bin/env bash
./bin/i18ndude rebuild-pot \
    --pot resources/theme/demotheme/locales/plone.pot \
    --merge resources/theme/demotheme/locales/manual.pot \
    --create plone resources/theme/demotheme
./bin/i18ndude sync \
    --pot resources/theme/demotheme/locales/plone.pot resources/theme/demotheme/locales/*/LC_MESSAGES/plone.po
