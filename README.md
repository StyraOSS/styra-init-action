# Styra-Init-Action

This is a reusable action that tries to enforce some common standards easily.

> [!IMPORTANT]
> This action is created by Styra for internal use.
> **Please don't use it as-is in your own projects**, as there are no guarantees for stability, and extra checks maybe be introduced that will end up breaking your workflows.
> However, it is shared publicly for inspiration! Feel free to fork and adjust to your organization's requirements.


## How to use

Add the action to your workflow definitions:

```diff
jobs:
+  prereqs: # any name is fine, as long as it's consistent with "needs:" below
+   name: Prereqs
+   runs-on: ubuntu-24.04
+   steps:
+     - uses: StyraInc/styra-init-action@main

  lint:
    name: Analysis & Linting
+   needs: prereqs
    runs-on: ubuntu-22.04
```

Note that all other jobs need to depend on the new job, directly or transitively.


## What does it do?

Right now, it

1. installs conftest
2. runs `conftest check` on all workflow files

The conftest policies check these things:

1. Every "uses" value in a job's steps needs to use a pinned ref, no tags or branches.
2. Every job _of every workflow_ needs to depend on the init job, directly or indirectly.

More policies may be added in the future.


## Remediation (How do I fix what it complains about?)


### Use a pinned ref

Wrong:

```yaml
- uses: third-party/some-thing@v4
```

Correct:

```yaml
- uses: third-party/some-thing@11bd71901bbe5b1630ceea73d27597364c9af683
```


#### Why?

Using pinned refs is a measure against repository takeovers.
If, for some reason, someone manages to commit malicious code, and updates the tags, a pinned ref would **not be affected**.


#### How to fix:

No need to undertake the daunting task of manually replacing tags with SHAs.
There are tools that automate pinning refs that make it very easy to do; a couple of the more popular ones are:

- [`pinact`](https://github.com/suzuki-shunsuke/pinact)
- [`ratchet`](https://github.com/sethvargo/ratchet)

Pinning refs is, however, not a one time task.
You will want to update your refs occasionally — whether pinned or not — as new legitimate versions become available.
Both `pinact` and `ratchet` make maintenance easy as well with an available update option.

Furthermore, dependabot will update pinned-ref actions in much the same way as it does for tags, so there's no downside to pinning.


## Community

For questions, discussions and announcements related to Styra products, services and open source projects, please join
the Styra community on [Slack](https://inviter.co/styra)!
