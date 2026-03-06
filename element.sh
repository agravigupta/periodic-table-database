#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# if no argument 
if [[ ! $1 ]]
then
  echo "Please provide an element as an argument."
else
  # if argument is a number (atomic number)
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    RESULT=$($PSQL "select e.atomic_number, e.symbol, e.name, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius from elements e inner join properties p using(atomic_number) inner join types t using(type_id) where e.atomic_number=$1")
  
  # if argument is a symbol or a name
  else
    RESULT=$($PSQL "select e.atomic_number, e.symbol, e.name, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius from elements e inner join properties p using(atomic_number) inner join types t using(type_id) where e.symbol='$1' OR e.name='$1'")
  fi

  # if no result
  if [[ -z $RESULT ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$RESULT" | while IFS="|" read ATOMIC_NUMBER SYMBOL NAME TYPE MASS MELTING BOILING
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  fi

fi
