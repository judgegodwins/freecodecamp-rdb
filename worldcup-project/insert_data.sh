#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "truncate games, teams;")

cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do
  if [[ $winner == winner ]]
  then
    continue
  fi
  echo $winner, $opponent

  winner_id=$($PSQL "select team_id from teams where name = '$winner'")
  if [[ -z $winner_id ]]
  then
    result="$($PSQL "insert into teams (name) values ('$winner')")"
    winner_id=$($PSQL "select team_id from teams where name = '$winner'")
    echo "inserted $winner, result = $result"
  fi

  opponent_id=$($PSQL "select team_id from teams where name = '$opponent'")
  if [[ -z $opponent_id ]]
  then
    result="$($PSQL "insert into teams (name) values ('$opponent')")"
    opponent_id=$($PSQL "select team_id from teams where name = '$opponent'")
    echo "inserted $opponent, result = $result"
  fi

  game_result=$($PSQL "insert into games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) values ($year, '$round', $winner_id, $opponent_id, $winner_goals, $opponent_goals)")

  echo "game result = $game_result"

  echo "$($PSQL "select * from games")"
done
