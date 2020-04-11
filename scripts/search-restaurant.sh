#!/usr/bin/env bash

if [ $# -eq 0 ]; then
    cat <<EOF
Usage: bash $(basename ${0}) '35.6197,139.728553'
EOF
    exit 1
fi
LONLAT=${1}

if [ -z "${PLACE_API_KEY:foo}" ]; then
    echo "Environment variable 'PLACE_API_KEY' is required."
    echo "export PLACE_API_KEY='YOUR_API_KEY'"
    exit 1
fi

echo "\"name\",\"address\",\"takeaway\",\"phone\",\"lat\",\"lng\",\"url\""
TOKEN=""
while [ TRUE ]
do
    if [ -z "${TOKEN}" ]; then
        RES=$(curl -s "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${LONLAT}&radius=200&type=restaurant&language=ja&key=${PLACE_API_KEY}" | jq -c '.next_page_token?,.results[]')
    else
        RES=$(curl -s "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${LONLAT}&radius=200&type=restaurant&language=ja&key=${PLACE_API_KEY}&pagetoken=${TOKEN}" | jq -c '.next_page_token?,.results[]')
    fi

    TOKEN=$(echo "${RES}" | head -n 1 | awk -F\" '{print $2}')
    echo "${RES}"  | tail -n +2 | while read LINE
    do
        PLACE_ID=$(echo "${LINE}" | sed 's/.*"place_id":"\([^\"]*\)".*$/\1/')
        DETAIL=$(curl -s "https://maps.googleapis.com/maps/api/place/details/json?place_id=${PLACE_ID}&fields=name,formatted_address,formatted_phone_number,geometry,website&language=ja&key=${PLACE_API_KEY}")
        echo "${DETAIL}" | jq -c --raw-output '.result | [.name,.formatted_address,"FALSE",.formatted_phone_number,.geometry.location.lat,.geometry.location.lng,.website] | @csv'
    done
    if [ -z "${TOKEN}" ]; then
        break;
    fi
    sleep 2
done

exit 0
