#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
  then
    echo Please provide an element as an argument.
  else
    ELEMENT=$1
    # echo $ELEMENT
    # Check if the input is an integer (atomic number)
    if [[ $ELEMENT =~ ^[0-9]+$ ]]; then
      # ATOMIC_NUMBER=$1
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = '$ELEMENT';")
      # echo $ATOMIC_NUMBER
    
    # Check if the input is 1 or 2 characters (symbol)
    elif [[ ${#ELEMENT} -ge 1 && ${#ELEMENT} -le 2 ]]; then
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$ELEMENT';")
      # echo $ATOMIC_NUMBER
    
    # Otherwise, assume it's a full name of the element
    else
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name ILIKE '%$ELEMENT%';")
      # echo $ATOMIC_NUMBER
    fi

    if [[ -z $ATOMIC_NUMBER ]]
    then
      echo I could not find that element in the database.
    else
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = '$ATOMIC_NUMBER';")
      ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = '$ATOMIC_NUMBER';")
      TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties ON types.type_id = properties.type_id WHERE atomic_number = '$ATOMIC_NUMBER';")
      MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = '$ATOMIC_NUMBER';")
      MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = '$ATOMIC_NUMBER';")
      BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = '$ATOMIC_NUMBER';")
      echo -e "The element with atomic number $ATOMIC_NUMBER is $ELEMENT_NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $ELEMENT_NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    fi
fi