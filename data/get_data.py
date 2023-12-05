import requests
import pandas as pd
from bs4 import BeautifulSoup
import json
import csv
def office_names_and_actions():
    url = 'https://rezerwacje.um.warszawa.pl/'

    response = requests.get(url)

    dfs = pd.read_html(response.text)

    soup = BeautifulSoup(requests.get(url).text, 'html.parser')

    divs_jednostka = soup.find_all('div', class_='jednostka')
        
    office_names = []
    for div in divs_jednostka:
        office_names.append(div.find('span').text)
        
    action_names = []
    for df in dfs:
        if (df.columns.tolist()[0] == 'Nazwa grupy'):
            df = df.iloc[:-1]
            action_names.append(df.iloc[:, 0].tolist())

    my_dict = dict(zip(office_names, action_names))
    # with open('mycsvfile.csv', 'w') as f:  # You will need 'wb' mode in Python 2.x
    #     w = csv.DictWriter(f, my_dict.keys())
    #     w.writeheader()
    #     w.writerow(my_dict)
    with open("Urzedy.json", "w") as outfile:
        json.dump(my_dict, outfile)

office_names_and_actions()