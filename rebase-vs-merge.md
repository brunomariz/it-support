# Rebase Vs Merge

This guide shows the difference between git merge and git rebase. Additionally, practical examples of usage of both methods are shown, alongside their benefits, downsides, and perils.

## Updating your own branch with new features from main

*Warning: Be very careful when rebasing, especially using GitHub's UI. If you unintentionally rebase the main branch with changes from a development branch, instead of the opposite, the entire commit history of the main branch will be permanently altered.* Read the instructions below carefully before proceeding with a rebase, and watch this informative video: https://www.youtube.com/watch?v=DkWDHzmMvyg.

When you create your own branch for development, the commit tree will look something like this:


```
m1 - m2 - m3                  <-- commits in the main branch
            \
             - d1 - d2        <-- commits in the development branch
```

Usually, in large teams, the main branch will be updated while you work on your own branch. This is what the commit tree would look like in this scenario:


```
m1 - m2 - m3 - m4 - m5       <-- new commits in the main branch
            \
             - d1 - d2
```

Now, let's say you want to continue developing, but the new changes done in main on commits m4 and m5 are useful for your development. In this case, it would be interesting to update your development branch with the new features from the main branch. To do this, a simple solution is *rebasing* the development branch to the latest commit in main. This will reapply the changes from commits f1 and f2, but starting at the code in m4 and m5:


```
m1 - m2 - m3 - m4 - m5       
                      \
                       - d1' - d2'    <-- rebased development branch
```

Note: The rebased commits will have new hashes, as indicated by the apostrophes in the example above. You can check this by using the command git log before and after rebasing, and comparing the hashes on your commits on the development branch.

To perform a rebase that updates the development branch with changes from the main branch, open a terminal and navigate to your repository, and run the following commands:

```
git checkout main
git pull
git checkout <development-branch-name>

# Optional - visualize the hashes of the development branch commits, and note that the main branch commits are not present
git log

git rebase main

# Optional - visualize the new hashes after rebase, and the added commits from the main branch
git log
```

After rebasing, you may want to send your work to the remote repository.



### Practical rebase example

- New repository: merge-commit

```
git clone git@github.com:brunomariz/merge-rebase.git
cd merge-rebase
```

```
$ git log --graph
* commit d67c70f3104fb89ffd4e425cb431f44e4262104b (HEAD -> main, origin/main, origin/HEAD)
  Author: brunomariz <48870924+brunomariz@users.noreply.github.com>
  Date:   Tue Apr 28 09:28:18 2026 -0300

      Initial commit
```

- Add some commits

```
git commit --allow-empty -m "second commit"
git commit --allow-empty -m "third commit"
```

```
$ git log --graph --oneline --all
* 23e04f7 (HEAD -> main) third commit
* 9bc7d17 second commit
* d67c70f (origin/main, origin/HEAD) Initial commit
```

- Create a new branch and add new commits

```
git checkout -b development
git commit --allow-empty -m "fourth commit"
git commit --allow-empty -m "fifth commit"
```

```
$ git log --graph --oneline --all
* a0e8236 (HEAD -> development) fifth commit
* 29f66d6 fourth commit
* 23e04f7 (main) third commit
* 9bc7d17 second commit
* d67c70f (origin/main, origin/HEAD) Initial commit
```

- Add new commits in main


```
$ git checkout main
Switched to branch 'main'
Your branch is ahead of 'origin/main' by 2 commits.
  (use "git push" to publish your local commits)
$ git commit --allow-empty -m "sixth commit"
$ git commit --allow-empty -m "seventh commit"
```

```
$ git log --graph --oneline --all
* 77f928e (HEAD -> main) seventh commit
* 23dad4b sixth commit
| * a0e8236 (development) fifth commit
| * 29f66d6 fourth commit
|/
* 23e04f7 third commit
* 9bc7d17 second commit
* d67c70f (origin/main, origin/HEAD) Initial commit
```

- Rebase development branch to get new changes from main

```
git checkout development
git rebase main
```

```
$ git log --graph --oneline --all
* d724dbb (HEAD -> development) fifth commit
* 4077adc fourth commit
* 77f928e (main) seventh commit
* 23dad4b sixth commit
* 23e04f7 third commit
* 9bc7d17 second commit
* d67c70f (origin/main, origin/HEAD) Initial commit
```

- Notice that the hashes from "fourth commit" (29f66d6) and "fifth commit" (a0e8236) were altered after rebase (to 4077adc and d724dbb). Let's see what would happen if these commits had already been pushed to the remote repository.

#### Perils of rebasing

- Let's start from scratch, by resetting all changes on our repo

```
$ git reset --hard d67c70f
HEAD is now at d67c70f Initial commit
```

```
git log --graph --oneline --all
* d724dbb (development) fifth commit
* 4077adc fourth commit
* 77f928e seventh commit
* 23dad4b sixth commit
* 23e04f7 third commit
* 9bc7d17 second commit
* d67c70f (HEAD -> main, origin/main, origin/HEAD) Initial commit
```

```
git branch -D development
```

```
$ git log --graph --oneline --all
* d67c70f (HEAD -> main, origin/main, origin/HEAD) Initial commit
```

- Now let's add some commits and create a new branch with new commits

```
git commit --allow-empty -m "second commit"
git commit --allow-empty -m "third commit"
git checkout -b development
git commit --allow-empty -m "fourth commit"
git commit --allow-empty -m "fifth commit"
```

```
$ git log --graph --oneline --all
* c4ac7c1 (HEAD -> development) fifth commit
* db5e501 fourth commit
* cda688e (main) third commit
* 711151d second commit
* d67c70f (origin/main, origin/HEAD) Initial commit
```

- Push the changes on the development branch

```
git push --set-upstream origin development
git checkout main
git push
```

- Add new commits in main and push

```
git commit --allow-empty -m "sixth commit"
git commit --allow-empty -m "seventh commit"
git push
```

```
$ git log --graph --oneline --all
* 1298c3f (HEAD -> main, origin/main, origin/HEAD) seventh commit
* 47854e4 sixth commit
| * c4ac7c1 (origin/development, development) fifth commit
| * db5e501 fourth commit
|/
* cda688e third commit
* 711151d second commit
* d67c70f Initial commit
```

- Now, all the commits are pushed to the remote repository, as indicated by the `(origin/development)` and `(origin/main)` markers on the log above.

- We can rebase again the same way as before. This should reapply commits `c4ac7c1` ("fourth commit") and `db5e501` ("fifth commit") on top of main's most recent commit `1298c3f`

```
git checkout development
git rebase main
```

```
$ git log --graph --oneline --all
* b743484 (HEAD -> development) fifth commit
* c9fd1fd fourth commit
* 1298c3f (origin/main, origin/HEAD, main) seventh commit
* 47854e4 sixth commit
| * c4ac7c1 (origin/development) fifth commit
| * db5e501 fourth commit
|/
* cda688e third commit
* 711151d second commit
* d67c70f Initial commit
```

- We can see that indeed the rebase created the new commits `c9fd1fd` and `b743484` on top of the main branche's latest commit. However, the old commits from the development branch before the rebase (`c4ac7c1` and `db5e501`) are still present in the remote repository on the `origin/development` branch. Because of this, the `development` branch and the remote `origin/developmemnt` branch have diverged, which means we cannot push directly:

```
$ git push
To github.com:brunomariz/merge-rebase.git
 ! [rejected]        development -> development (non-fast-forward)
error: failed to push some refs to 'github.com:brunomariz/merge-rebase.git'
hint: Updates were rejected because the tip of your current branch is behind
hint: its remote counterpart. If you want to integrate the remote changes,
hint: use 'git pull' before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.
```

- One simple and **dangerous** way to fix this issue is to force push, which will rewrite the commits in the remote branch. The problem with this is that if someone else is also working on that branch, they will be working from commits that dont exist anymore, and won't be able to push anymore. If you are sure you are the only person working on your branch, you can force this rewrite with the following command:

```
git push --force
```

```
$ git log --graph --oneline --all
* b743484 (HEAD -> development, origin/development) fifth commit
* c9fd1fd fourth commit
* 1298c3f (origin/main, origin/HEAD, main) seventh commit
* 47854e4 sixth commit
* cda688e third commit
* 711151d second commit
* d67c70f Initial commit
```

- If, however, others may be working on this branch, it's possible to send the rebased commits to a new remote branch, as such:

```
git push -u origin development:development-rebase
```

- The downside of this approach is that it may cause confusion as there'll be a large number of branches for the same feature, which is not ideal. A more adequate approach in this case would be to merge instead of rebase.

- Note: **This whole problem can be avoided if only one person works on a given development branch at a time**.

### Practical merge example

Let's reset the repository again:

```
git checkout main
git reset --hard d67c70f
git branch -D development
git branch -D --remote origin/development
git branch -D --remote origin/development-rebase
git push --force
```

```
git log --graph --oneline --all
* d67c70f (HEAD -> main, origin/main, origin/HEAD) Initial commit
```

And follow the same setup steps from the rebase example:

```
touch c2.txt && git add .
git commit -m "second commit"
touch c3.txt && git add .
git commit -m "third commit"
git checkout -b development
touch c4.txt && git add .
git commit -m "fourth commit"
touch c5.txt && git add .
git commit -m "fifth commit"
git push --set-upstream origin development
git checkout main
touch c6.txt && git add .
git commit -m "sixth commit"
touch c7.txt && git add .
git commit -m "seventh commit"
git push
```

```
$ git log --graph --oneline --all
* 5101c0e (HEAD -> main, origin/main, origin/HEAD) seventh commit
* e9c96fa sixth commit
| * daa7b14 (origin/development, development) fifth commit
| * a4d6177 fourth commit
|/
* d0c4ec9 third commit
* 608e7cd second commit
* d67c70f Initial commit
```

Now let's say that, once again, we want to update the development branch with the new commits from main. As mentioned previously, if someone else is working on the development branch, a rebase followed by a force push could cause problems. The best way to solve this issue is, as mentioned previously, to **have only one person working on a given development branch at a time**. If that is not the case, however, a merge is a safer way to update the development branch with features from main.

To merge the changes from the main branch to a development branch, we can use the following command:

```
git checkout development
git merge main
```

This will prompt the user to enter a commit message on a text editor. After the message is written and the text editor is exited, the merge will be complete.

```
$ git log --graph --oneline --all
*   88b1753 (HEAD -> development) Merge branch 'main' into development
|\
| * 5101c0e (origin/main, origin/HEAD, main) seventh commit
| * e9c96fa sixth commit
* | daa7b14 (origin/development) fifth commit
* | a4d6177 fourth commit
|/
* d0c4ec9 third commit
* 608e7cd second commit
* d67c70f Initial commit
```

Note in the log above that the changes from the main branch were merged into the development branch, so now the development can continue until a future moment when a PR may be opened from the development branch to be merged into the main branch. This strategy, unlike the rebase, did not change the commit history, so there is no divergence between the local `development` branch and the remote `origin/development` branch. This means the merge commit can be pushed without problems:

```
git push
```

However, notice that a new commit (`88b1753`) was created. This can become a problem in real scenarios because this process of updating a development branch with changes from main can occur multiple times during development, causing many merge commits to be created unnecessarily, which pollutes the history. 

This merge commit will show up in the future Pull Request from the development branch to the main branch, however, in "changed files", the changes merged from the main branch will now show on the Pull Request, since these changes from the merge commit are already present in the main branch.

### Resources

To learn more abour rebasing and merging, check out the following links:

- https://git-scm.com/book/en/v2/Git-Branching-Rebasing
- https://git-scm.com/book/en/v2/Git-Branching-Basic-Branching-and-Merging#_basic_merging
- https://www.youtube.com/watch?v=DkWDHzmMvyg
