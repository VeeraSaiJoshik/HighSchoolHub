import requests
from bs4 import BeautifulSoup

req = requests.get("https://blog.prepscholar.com/list-of-extracurricular-activities-examples")
soup = BeautifulSoup(req.content, "html.parser")
clubs = soup.find_all("li")
for club in clubs : 
    print(club.text)