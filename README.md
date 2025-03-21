# Styra-Init-Action

This is a reusable action that tries to enforce some common standards easily.

## How to use

Add the action to your workflow defintions:

```diff
jobs:
+  prereqs:
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
2. Every job needs to depend on the init job, directly or indirectly.

More policies may be added in the future.
