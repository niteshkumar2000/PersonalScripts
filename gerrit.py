from pygerrit2 import GerritRestAPI, Anonymous
import requests, json
import os

def getChanges():
    url = 'http://freakyos.xyz'
    auth = Anonymous()
    rest = GerritRestAPI(url=url, auth=auth)
    return rest.get('/changes/?q=status:open')

def getCommitMessage(changes, number):
    for change in changes:
        if change['_number'] == number:
            return change['subject']
    return None

def prepareCherrypickCommands(changes):
    cherrypicks = {}
    for change in changes:
        response = requests.get("http://freakyos.xyz/changes/FreakyOS%2F{}~{}/detail?O=916314".format(change['project'].split('/')[-1], change['_number']))
        response = json.loads(response.text[5:])
        try:
            if not cherrypicks[change['project']]:
                cherrypicks[change['project']] = []
        except:
            cherrypicks[change['project']] = []
        cherrypicks[change['project']].append(("git fetch \"http://freakyos.xyz/{}\" refs/changes/{}/{}/{} && git cherry-pick FETCH_HEAD").format(change['project'], str(change['_number'])[1:], change['_number'], len(response['revisions'])))
    return cherrypicks

def pickChanges(changes,cherrypicks):
    for repo, commands in cherrypicks.items():
        if repo == 'FreakyOS/build':
            repo = 'FreakyOS/build_make'
        repo_list = ''.join(repo.split('/')[1:]).split('_')
        print('Entering {} directory!'.format(repo))
        os.system('cd ' + '/'.join(repo_list))
        commands.reverse()
        for command in commands:
            number = int(command.split('/')[7])
            ans = input(f'Do you want to pick the change - {getCommitMessage(changes, number)}? (Y/N)')
            if ans.lower() == 'y':
                print('Picking the change!')
                os.system(command)
            else:
                print('Moving on to next change!')
        print('Leaving the directory and return to home directory!')
        os.system('cd ' + '../'*len(repo_list))

if __name__ == '__main__':
    changes = getChanges()
    cherrypicks = prepareCherrypickCommands(changes)
    pickChanges(changes, cherrypicks)
