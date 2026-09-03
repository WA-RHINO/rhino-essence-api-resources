#  Post-template repository setup recommendations

## Create a `Team` in the Epi Coders organization and add your teammates
- https://github.com/orgs/DOH-EPI-Coders/teams

## Add collaborators to your repository
- In your repository
- Click `Settings`
- Under `Access` on left side, click `Collaborators and teams`
- Then click `add people` or `add team`
- [Assign them a role](https://docs.github.com/en/organizations/managing-user-access-to-your-organizations-repositories/managing-repository-roles/repository-roles-for-an-organization).

> ℹ️ Recommended: Add your `team` with either `write` or `maintain` by default.

## Add a backup repository `admin`
Recommended: Add a backup admin for your repository via `add people` in 

> ℹ️ Epi Coders [owners](https://github.com/orgs/DOH-EPI-Coders/people?query=role%3Aowner) are also an `admin` for every repository and can assist you or your team as needed.

## Protect the default branch
Protect your default branch with a [branch protection rule](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/managing-a-branch-protection-rule) to prevent accidental writes to your `main` branch.
    
Common Pattern:
- `Add branch ruleset`
- Enforcement Status: `Active`
- Add Bypass: `Repository Admin`
- Add target: `Include default branch`
- Check the box: `Require a pull request before merging` and then set Required approvals: `1`.

## Change your default branch from `main` to `dev`
> ⚠️ Only do this if you know what you are doing

Developers may want to set their default branch to `dev` instead of `main`. This is generally a convenient shortcut in setup for developer workflows that use `dev` before merging to a production branch. It's also a useful way of isolating the main production branch from accidental merges or commits from collaborators without a PR.
