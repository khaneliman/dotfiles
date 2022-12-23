import sys
import json
from lib.nba_api.live.nba.endpoints.scoreboard import ScoreBoard

class NBAScoreboard:
    def __init__(self):
        self.todays_games = ScoreBoard().get_dict()["scoreboard"]["games"]
        self.base_url = "https://www.nba.com/game/"

    def create_lists(self):
        scores_list = []
        gametime_list = []
        player_leaders = []
        for i in range(len(self.todays_games)):
            scores_list.append([
                self.todays_games[i]["awayTeam"].get("teamTricode"),
                self.todays_games[i]["awayTeam"].get("score"),
                self.todays_games[i]["homeTeam"].get("score"),
                self.todays_games[i]["homeTeam"].get("teamTricode"),
            ])
            gametime_list.append(self.todays_games[i]["gameStatusText"])
            player_leaders.append([
                self.todays_games[i]["gameLeaders"]["awayLeaders"].get("name"),
                self.todays_games[i]["gameLeaders"]["awayLeaders"].get("points"),
                self.todays_games[i]["gameLeaders"]["awayLeaders"].get("rebounds"),
                self.todays_games[i]["gameLeaders"]["awayLeaders"].get("assists"),
                self.todays_games[i]["gameLeaders"]["homeLeaders"].get("name"),
                self.todays_games[i]["gameLeaders"]["homeLeaders"].get("points"),
                self.todays_games[i]["gameLeaders"]["homeLeaders"].get("rebounds"),
                self.todays_games[i]["gameLeaders"]["homeLeaders"].get("assists"),
                ])
        return scores_list, gametime_list, player_leaders

    def create_json_obj(self):
        scores_list, gametime_list, player_leaders = self.create_lists()
        if len(scores_list) == 0:
            result = {
                "title": "No games!",
            }
            return [result]
        else:
            results = []
            for i, j in zip(scores_list, player_leaders):
                if self.todays_games[scores_list.index(i)]["gameStatus"] == 1:
                    results.append({
                        "title": f"{i[0]} @ {i[3]}",
                        "subtitle": f"{gametime_list[scores_list.index(i)]}",
                        "arg": f"{self.base_url}{self.todays_games[scores_list.index(i)]['awayTeam'].get('teamTricode')}-vs-{self.todays_games[scores_list.index(i)]['homeTeam'].get('teamTricode')}-{self.todays_games[scores_list.index(i)]['gameId']}",
                    })
                else:
                    results.append({
                        "title": f"{i[0]} {i[1]} - {i[2]} {i[3]}\t\t({gametime_list[scores_list.index(i)]})",
                        "subtitle": f"{j[0]}: {j[1]}pts/{j[2]}reb/{j[3]}ast - {j[4]}: {j[5]}pts/{j[6]}reb/{j[7]}ast",
                        "arg": f"{self.base_url}{self.todays_games[scores_list.index(i)]['awayTeam'].get('teamTricode')}-vs-{self.todays_games[scores_list.index(i)]['homeTeam'].get('teamTricode')}-{self.todays_games[scores_list.index(i)]['gameId']}/box-score",
                    })
            return results

if __name__ == "__main__":
    alfred_json = json.dumps({
        "items": NBAScoreboard().create_json_obj()
    })
    sys.stdout.write(alfred_json)