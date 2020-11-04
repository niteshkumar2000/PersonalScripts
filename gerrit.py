from pygerrit2 import GerritRestAPI, Anonymous
import requests, json

if __name__ == "__main__":
    url = 'http://freakyos.xyz'
    auth = Anonymous()
    rest = GerritRestAPI(url=url, auth=auth)
    changes = rest.get("/changes/?q=status:open")
    cherrypicks = {}
    for change in changes:
        response = requests.get("http://freakyos.xyz/changes/FreakyOS%2F{}~{}/detail?O=916314".format(change['project'].split('/')[-1], change['_number']))
        response = json.loads(response.text[5:])
        try:
            if not cherrypicks[change['project']]:
                cherrypicks[change['project']] = []
        except:
            cherrypicks[change['project']] = []
        cherrypicks[change['project']].append(("git fetch \"http://freakyos.xyz/{}\" refs/changes/{}/{}/{} && git cherry-pick FETCH_HEAD").format(
            change['project'], str(change['_number'])[1:], change['_number'], len(response['revisions'])))
    for repo, commands in cherrypicks.items():
        for command in commands:
            print(repo, command)
