#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
while IFS=',' read -r year round winner opponent winner_goals opponent_goals
do
  if [[ "$year" != "year" ]]
  then
    $PSQL "INSERT INTO teams(name)
      VALUES('$winner')
      ON CONFLICT (name) DO NOTHING"

    $PSQL "INSERT INTO teams(name)
      VALUES('$opponent')
      ON CONFLICT (name) DO NOTHING"

    $PSQL "INSERT INTO games
      (year, round, winner_id, opponent_id, winner_goals, opponent_goals)
      SELECT $year, '$round', winner.team_id, opponent.team_id,
             $winner_goals, $opponent_goals
      FROM teams AS winner
      JOIN teams AS opponent ON opponent.name = '$opponent'
      WHERE winner.name = '$winner'"
  fi
done < games.csv