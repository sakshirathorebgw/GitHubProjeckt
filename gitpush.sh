cp -r $DIR .
git config --global user.email "Sakshi.Rathore@bgw-online.de"
git config --global user.name "Sakshi Rathore"

git add .

commitMessage="commiting the new file"
echo $commitMessage

#read commitMessage

git commit -m "$commitMessage"
git remote set-url origin https://Sakshi.Rathore%40bgw-online.de:Sherlock%40107@github.com/sakshirathorebgw/GitHubProjeckt.git
branch=master
echo $branch
#read branch

git push origin master

sleep 10
echo "execute piecebypiece now"

./piecebypiece.sh

echo "script execution done"
