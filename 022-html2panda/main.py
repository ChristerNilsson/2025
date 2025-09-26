import pandas as pd
import json

def html_tables_to_json(path):
    dfs = pd.read_html(path)
    return [df.to_dict(orient="records") for df in dfs]

if __name__ == "__main__":
    tables = html_tables_to_json("https://member.schack.se/ShowTournamentServlet?id=13664&listingtype=2")
    print(json.dumps(tables, ensure_ascii=False, indent=2))
