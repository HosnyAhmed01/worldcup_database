#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo "$($PSQL "TRUNCATE games, teams")"
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $YEAR != year ]]
then 

WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"

# IF NOT FOUND

if [[ -z $WINNER_ID ]] 
then 
  INSERT_WINNER_ID_RESULT="$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")"
  if [[ $INSERT_WINNER_ID_RESULT == "INSERT 0 1" ]] 
  then 
    echo "inserted into teams , $WINNER "
  fi
  # GET NEW TEAM_ID
  WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
fi

OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"

  if [[ -z $OPPONENT_ID ]] 
  then 
    INSERT_OPPONENT_RESULT="$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")"

    if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
    then 
        echo inserted into teams , $OPPONENT
    fi 

    OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"
  fi

  INSERT_GAMES_RESULT="$($PSQL "INSERT INTO games(opponent_goals , winner_goals , winner_id , opponent_id , year , round) VALUES ($OPPONENT_GOALS , $WINNER_GOALS , $WINNER_ID , $OPPONENT_ID , $YEAR , '$ROUND')")"
  if [[ $INSERT_GAMES_RESULT == 'INSERT 0 1' ]]
  then
    echo inserted into games , $OPPONENT_GOALS , $WINNER_GOALS , $WINNER_ID , $OPPONENT_ID , $YEAR , $ROUND
  fi  

fi

done 
