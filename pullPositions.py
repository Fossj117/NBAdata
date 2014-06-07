import json
import urllib2
import sys
from csv import DictWriter
import pandas as pd

def id_to_json(player_id):
    url_base = "http://stats.nba.com/stats/commonplayerinfo/?PlayerID="
    data = json.loads(urllib2.urlopen(url_base+str(player_id)).read())
    return data

def json_to_dict(player_json):
    player_dict = dict(zip(player_json['resultSets'][0]['headers'], player_json['resultSets'][0]['rowSet'][0]))
    return player_dict

def id_to_dict(player_id):
    raw = id_to_json(player_id)
    return json_to_dict(raw)

def main():

    nba_dat = pd.read_csv('nba_data_5-10.csv')
    outfile = "position_data.csv"
    
    with open(outfile, 'wb') as out: 
        dw = DictWriter(out, delimiter= ',', 
                        fieldnames=id_to_dict(203099).keys())
        dw.writeheader()
        for id in nba_dat.PlAYER_ID:
            print id
            dw.writerow(id_to_dict(id))

if __name__ == "__main__":
    main()
