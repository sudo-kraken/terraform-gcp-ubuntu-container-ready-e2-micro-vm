# How to contribute

**First:** if you're unsure or afraid of _anything_, ask for help! You can
submit a work in progress (WIP) pull request, or file an issue with the parts
you know. We'll do our best to guide you in the right direction, and let you
know if there are guidelines we will need to follow. We want people to be able
to participate without fear of doing the wrong thing.

## Commit message conventions

We expect that all commit messages follow the
[Conventional Commits](https://www.conventionalcommits.org/) specification.
Please use the `feat`, `fix` or `chore` types for your commits.

### Developer Certificate of Origin

In order for a code change to be accepted, you'll also have to accept the
Developer Certificate of Origin (DCO).
It's very lightweight, and you can find it [here](https://developercertificate.org).
Accepting is accomplished by signing off on your commits, you can do this by
adding a `Signed-off-by` line to your commit message, like here:

```commit
feat: add support for the XXXX operation

Signed-off-by: Random Developer <random@developer.example.org>
```

Please use your real name and a valid email address.

## Submitting changes

Please create a new PR against the `main` branch which must be based on the
project's [pull request template](.github/PULL_REQUEST_TEMPLATE.md).

We usually squash all PRs commits on merge, and use the PR title as the commit
message. Therefore, the PR title should follow the
[Conventional Commits](https://www.conventionalcommits.org/) specification as well.