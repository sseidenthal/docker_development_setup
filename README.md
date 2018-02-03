Generic Development Setup for Docker on Mac

I am testing a generic docker development setup for mac

##Prerequisites
brew install supervisor
brew install fsevents-tools

`
git clone https://github.com/sseidenthal/docker_development_setup.git my_project
cd my_project
`

`
make
make start
make ps
male log.unison
`
