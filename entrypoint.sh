#!/bin/bash
[ ! -f vendor/bin/phpunit ] && echo 'vendor/bin/phpunit not found' && exit 1

cp .env .env.bak 2>/dev/null
cp .env.github .env.testing
cp .env.github .env

composer dump-autoload

mkdir -p storage/logs 2>/dev/null

vendor/bin/phpunit \
    --coverage-text="$INPUT_TARGETDIR/coverage.txt" \
    --coverage-html="$INPUT_TARGETDIR/coverage-html" |\
    tee "$INPUT_TARGETDIR/phpunit-results.txt"

COVERAGE=$(head -n9 "$INPUT_TARGETDIR/coverage.txt" | egrep '^  Lines' | awk '{ print $2 }' | sed 's/%//g')
SUCCESS=$([ "$(fgrep OK "$outputFile")" != "" ] && echo 'true' || echo 'false')
SUMMARY=$(grep -i 'assertions' "$outputFile" | grep -i 'tests')
RESULT_TEXT=$([ "$SUCCESS" == "true" ] && echo "PASS" || echo "FAIL")
RESULT_EMOJI=$([ "$SUCCESS" == "true" ] && echo ':white_check_mark:' || echo ':x:')

echo ::set-output name=success::${SUCCESS}
echo ::set-output name=summary::${SUMMARY}
echo ::set-output name=result-text::${RESULT_TEXT}
echo ::set-output name=result-emoji::${RESULT_EMOJI}
echo ::set-output name=coverage::${COVERAGE}
