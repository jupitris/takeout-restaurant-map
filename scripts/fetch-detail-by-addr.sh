#!/usr/bin/env bash

if [ -z "${PLACE_API_KEY:foo}" ]; then
    echo "Environment variable 'PLACE_API_KEY' is required."
    echo "export PLACE_API_KEY='YOUR_API_KEY'"
    exit 1
fi

if [ -z "${GEOCODING_API_KEY:foo}" ]; then
    echo "Environment variable 'GEOCODING_API_KEY' is required."
    echo "export GEOCODING_API_KEY='GEOCODING_API_KEY'"
    exit 1
fi

ADDRESS=$(echo "${1}" | cut -d , -f 2 | sed -e 's/\s/+/g')
GEO_API="https://maps.googleapis.com/maps/api/geocode/json?address=${ADDRESS}&key=${GEOCODING_API_KEY}"
RES=$(curl -s "${GEO_API}" | jq -c '.results[].place_id')
PLACE_ID=$(echo "${RES}" | awk -F\" '{print $2}')
DETAIL=$(curl -s "https://maps.googleapis.com/maps/api/place/details/json?place_id=${PLACE_ID}&fields=name,formatted_address,formatted_phone_number,geometry,website&language=ja&key=${PLACE_API_KEY}")
echo "\"name\",\"address\",\"takeaway\",\"phone\",\"lat\",\"lng\",\"url\""
echo "${DETAIL}" | jq -c --raw-output '.result | [.name,.formatted_address,"FALSE",.formatted_phone_number,.geometry.location.lat,.geometry.location.lng,.website] | @csv'

exit 0
