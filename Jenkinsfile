node('docker-centos7-puppet') {
    checkout scm

    stage 'Getting module name from JOB_NAME'
    sh 'echo ${JOB_NAME##*/} > .jobname'
    def JOBNAME = readFile('.jobname').trim()
    env.JOBNAME = JOBNAME


    stage 'Getting GIT_URL variable'
    sh 'cat .git/config | grep url | awk -F \' = \' \'{print $2}\' > .git_url'
    def GIT_URL = readFile('.git_url').trim()
    env.GIT_URL = GIT_URL
    sh 'cat .git/config | grep url | awk -F \'//\' \'{print $2}\' > .git_url-stripped'
    def STRIPPED_URL = readFile('.git_url-stripped').trim()
    env.STRIPPED_URL = STRIPPED_URL

    stage 'Setting fixtures'
    withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'Puppet_Puppet', usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_PASSWORD']]) {
        sh "test -f .fixtures.yml && sed -i \'s#git://#https://${env.GIT_USERNAME}:${env.GIT_PASSWORD}@#g\' .fixtures.yml || true"
    }

    stage 'Running unit tests'
    sh 'FUTURE_PARSER=yes bundle exec rake validate lint strings:generate'
    publishHTML(target: [allowMissing: false, alwaysLinkToLastBuild: true, keepAll: false, reportDir: 'doc', reportFiles: 'index.html', reportName: 'module docs'])
    sh "[[ ${env.JOBNAME} == ing-* ]] && bundle exec rake spec || true"

    stage 'Getting new version variable'
    sh 'jq \'(.version)\' metadata.json | sed -e \'s/^"//\'  -e \'s/"$//\' > .version '
    sh 'BNUMBER=$(git tag | { egrep -v -i [a-z] || true ; } | sort -V | awk -F- \'{print $2} END { if (NR==0) print "0"}\' | tail -1) ;  ((BNUMBER++)) || true ; echo $BNUMBER > .bnumber'
    sh 'VERSION=$(cat .version) ; BNUMBER=$(cat .bnumber) ; NEWVERSION=$(echo ${VERSION}-${BNUMBER}) ; echo $NEWVERSION > .newversion'
    def NEWVERSION = readFile('.newversion').trim()
    env.NEWVERSION = NEWVERSION
    echo "New version will be $NEWVERSION"

    stage 'Tagging source repo with new version tag'
    withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: '2215c2a6-0dca-44ae-8cf8-8f89747c630e', usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_PASSWORD']]) {
        sh 'git config --global user.email "Jenkins@build.paas.intranet" ; \
            git config --global user.name "Jenkins" '
        sh "git tag -m \"Tagging with new version\" -a ${env.NEWVERSION}"
        sh "git push --tags https://${env.GIT_USERNAME}:${env.GIT_PASSWORD}@${STRIPPED_URL}"
    }

    stage 'Updating control repo with new module version'
    echo "MODULE =  $JOBNAME"
    echo "GIT_URL = $GIT_URL"
    echo "NEWVERSION = $NEWVERSION"
    build job: 'Workflow/task-update-module-version-in-ing-puppet-control', parameters: [[$class: 'StringParameterValue', name: 'NEWVERSION', value: NEWVERSION], [$class: 'StringParameterValue', name: 'GIT_URL', value: GIT_URL], [$class: 'StringParameterValue', name: 'MODULE_NAME', value: JOBNAME]]
}
