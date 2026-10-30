#!/bin/bash

PSQL="psql -X -U freecodecamp -d salon -t -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo "Welcome to My Salon, how can I help you?"

echo "$($PSQL "SELECT service_id || ') ' || name FROM services ORDER BY service_id")"
read SERVICE_ID_SELECTED

SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED" | sed 's/^ *//;s/ *$//')

while [[ -z $SERVICE_NAME ]]
do
	echo -e "\nI could not find that service. What would you like today?"
	echo "$($PSQL "SELECT service_id || ') ' || name FROM services ORDER BY service_id")"
	read SERVICE_ID_SELECTED
	SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED" | sed 's/^ *//;s/ *$//')
done

echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE

CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'" | sed 's/^ *//;s/ *$//')

if [[ -z $CUSTOMER_NAME ]]
then
	echo -e "\nI don't have a record for that phone number, what's your name?"
	read CUSTOMER_NAME
	$PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')"
fi

echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
read SERVICE_TIME

CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'" | sed 's/^ *//;s/ *$//')
$PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')"

echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."