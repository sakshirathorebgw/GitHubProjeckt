git add .

commitMessage="commiting the new file"
echo 'Enter the commit message:'

read commitMessage

git commit -m "$commitMessage"
git remote set-url origin https://Sakshi.Rathore%40bgw-online.de:Sherlock%40107@github.com/sakshirathorebgw/GitHubProjeckt.git
branch=master
echo 'Enter the name of the branch:'
read branch

git push origin $branch

read

./piecebypiece.sh
