#!/bin/bash

TO_ADDRESS="Sakshi.Rathore@bgw-online.de"
FROM_ADDRESS="Sakshi.Rathore@bgw-online.de"
SUBJECT="Test mail"
BODY="hai friend, this mail is automated from shell script for Release automation."

echo "${BODY}" | mail -s "${SUBJECT}" "${TO_ADDRESS}"  # -- -r "${FROM_ADDRESS}"
