#!/bin/bash
. inputfile.txt
cp -r $DIR .
echo "new file"
#ssh-add $SSH_KEYPATH ~/.ssh/id_rsa

#ssh-keygen -y -f ~/.ssh/harbortest > ~/.ssh/harbortest_com.pub
#ssh-keygen -i -f ~/.ssh/harbortest_com.pub > ~/.ssh/harbortest.pub
#ssh-copy-id -i ~/.ssh/harbortest.pub
#ssh-copy-id -f -i ~/.ssh/harbortest.pub ccpuser@10.32.141.35

#chmod 700 ~/.ssh/
#chmod 600 ~/.ssh/*

#scp $SSH_KEYPATH ccpuser@$HOST_NAME:/home/ccpuser/.ssh


git config --global user.email "Sakshi.Rathore@bgw-online.de"
git config --global user.name "Sakshi Rathore"

git add .

commitMessage="commiting the new file"
echo $commitMessage

#read commitMessage

#git commit -m "$commitMessage"
#git branch -mv origin master
git remote set-url origin https://Sakshi.Rathore%40bgw-online.de:Sherlock%40107@github.com/sakshirathorebgw/GitHubProjeckt.git
#branch=master
#echo $branch
#read branch

git commit -m "$commitMessage"

git push origin master --force

git pull

sleep 10
echo "execute piecebypiece now"

./piecebypiece.sh

echo "script execution done"
