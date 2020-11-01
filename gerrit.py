from pygerrit2 import GerritRestAPI, Anonymous
if __name__ == "__main__":
    url = 'http://freakyos.xyz'
    auth = Anonymous()
    rest = GerritRestAPI(url=url, auth=auth)
    changes = rest.get("/changes/?q=status:open")
    cherrypicks = {}
    for change in changes:
        try:
            if not cherrypicks[change['project']]:
                cherrypicks[change['project']] = []
        except:
            cherrypicks[change['project']] = []
        cherrypicks[change['project']].append(("git fetch \"http://freakyos.xyz/{}\" refs/changes/{}/{}/1 && git cherry-pick FETCH_HEAD").format(change['project'], str(change['_number'])[1:], change['_number']))
    for repo, commands in cherrypicks.items():
        for command in commands:
            print(repo, command)
