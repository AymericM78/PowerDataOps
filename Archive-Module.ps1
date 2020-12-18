$comment = Read-Host "Git comment";

git add .
& "git commit -m $comment"
git push