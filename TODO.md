- introduce a new command `hacklets_project_work` which can be run after
  fetching a hacklet, which creates a local clone of the local backend .git
  repository, as a way to work on projects which are not hacklets.
  This will basically also start a new subshell with appropiate environmental
  commands, triggering a signal. Signal handlers can be installed by hacklets.
- introduce a new command `hacklets_generate_superproject` which generates a
  sepparate project with an install.sh script which, when run on an empty
  directory, it initializes that directory as an exact mirror of the current
  container, turning that directory into a container as well.
  This would be useful to deploy "work spaces", within a group, organization
  or across machines.
