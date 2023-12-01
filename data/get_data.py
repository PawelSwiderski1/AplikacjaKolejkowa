import requests
import pandas as pd
from bs4 import BeautifulSoup
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
            action_names.append(df.iloc[:, 0].tolist())
    
    return dict(zip(office_names, action_names))