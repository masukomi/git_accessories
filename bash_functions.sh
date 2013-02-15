# A collection of bash functions to help you use git better.


# Public: gpup - Git Push to UPstream
#         Setting a tracking branch only affects git pull.
#         This will perform a git push to wherever git pull
#         would come from, or just do "git pull" (at your command).
#
#         Most people don't encounter the problem because it'll 
#         default to pushing to a repo of the same name as your 
#         local one on origin, which is how most people's branches
#         are configured. If your local name differs from the corresponding
#         branch on origin, or you are tracking a separate repo, 
#         subtle problems can creep in if you're not paying attention.
#
#         So, always use gpup and you won't have issues.
#
# args - any arguments you pass to gpup will be passed on to git push
#
# Requirement: current_git_branch function
#         current_git_branch is expected to return the name of 
#         the current git branch.
function gpup {
	CURRENT_GIT_BRANCH=$(current_git_branch)
	REMOTE=$(git config --get "branch.$CURRENT_GIT_BRANCH.remote")
	if [ "$REMOTE" != "" ]; then
		MERGE=$(git config --get "branch.$CURRENT_GIT_BRANCH.merge" | sed -e 's/.*\///g')
		if [ "$MERGE" != "" ]; then
			if [ $# -gt 0 ]; then
				echo "running: git push $@ $REMOTE $MERGE"
				git push $@ $REMOTE $MERGE
			else
				echo "running: git push $REMOTE $MERGE"
				git push $REMOTE $MERGE
			fi
		else
			echo "Umm... you've got a remote configured but not a merge. quitting"
		fi
	else
		echo "No branch specific upstream. Continue with default? [enter for yes|q for quit]"
		read RESPONSE
		if [ "$RESPONSE" == "" ]; then 
			if [ $# -gt 0 ]; then
				echo "running: git push $@ origin $CURRENT_GIT_BRANCH"
				git push $@ $REMOTE $MERGE
			else
				echo "running: origin $CURRENT_GIT_BRANCH"
				git push origin $CURRENT_GIT_BRANCH
			fi
		else
			echo "quitting"
		fi
	fi
}

