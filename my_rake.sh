rm ./build -rf

# http://stackoverflow.com/questions/6588674/what-does-bundle-exec-rake-mean
bundle exec rake assets:compile VERSION=latest
