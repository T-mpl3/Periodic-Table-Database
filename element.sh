PSQL="psql --username=freecodecamp --dbname=periodic_table -t -c"

if [[ $1 ]] 
then
  if [[ $1 =~ [0-9]+ ]]
  then 
    ATOMIC_NUMBER=$1
  else 
    ATOMIC_NUMBER=0
  fi 
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1' OR name='$1' OR atomic_number=$ATOMIC_NUMBER")
  if [[ $ATOMIC_NUMBER ]]
  then
    echo $($PSQL "SELECT * FROM elements WHERE atomic_number='$ATOMIC_NUMBER'")| while read ATOMIC_NUM BAR ATOMIC_SYMBOL BAR ELEMENT_NAME
    do
      echo $($PSQL "SELECT * FROM properties FULL JOIN types ON properties.type_id = types.type_id WHERE atomic_number='$ATOMIC_NUMBER'")| while read ATOMIC_NUM BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT BAR TYPE_ID BAR TYPE_ID BAR TYPE
      do
        ATOMIC_NUMBER_FIXED=$(echo $ATOMIC_NUMBER| sed -E 's/^ +| +$//g')
        echo "The element with atomic number $ATOMIC_NUMBER_FIXED is $ELEMENT_NAME ($ATOMIC_SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $ELEMENT_NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius." 
      done
    done
  else
    echo "I could not find that element in the database."
  fi
else
  echo "Please provide an element as an argument."
fi
