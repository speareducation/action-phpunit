#!/bin/bash
[ ! -f vendor/bin/phpunit ] && echo 'vendor/bin/phpunit not found' && exit 1

cp .env .env.bak 2>/dev/null
cp .env.github .env.testing
cp .env.github .env

apk add php-xmlwriter

cat > /etc/php/conf.d/98_pcov.ini <<EOT
[pcov]
extension=pcov
pcov.enabled=1
EOT

composer dump-autoload # ensure fresh file paths since composer is run in another step

php artisan --env=testing migrate

if [ -z "$INPUT_TARGETDIR" ]
then
    outputFile=""
else
    [ ! -d "$INPUT_TARGETDIR" ] && mkdir "$INPUT_TARGETDIR"

    if [ -d storage ]
    then
        mkdir -p storage/logs
        ln -s $INPUT_TARGETDIR/logs storage/logs
    fi

    outputFile="$INPUT_TARGETDIR/phpunit-results.txt"
fi

vendor/bin/phpunit $INPUT_OPTIONS | tee "$outputFile"

SUCCESS=$(fgrep OK "$outputFile" && echo 'true' || echo 'false')
SUMMARY=$(grep -i 'assertions' "$outputFile" | grep -i 'tests')
RESULT_TEXT=$([ "$SUCCESS" == "true" ] && echo "PASS" || echo "FAIL")
RESULT_EMOJI=$([ "$SUCCESS" == "true" ] && echo ':white_check_mark:' || echo ':x:')

echo SUCCESS=${SUCCESS}
echo SUMMARY=${SUMMARY}

echo "::set-output name=success::${SUCCESS}"
echo "::set-output name=summary::${SUMMARY}"
echo "::set-output name=result-text::${RESULT_TEXT}"
echo "::set-output name=result-emoji::${RESULT_EMOJI}"

