.. _devguide-worflow_edf:

########################
EDF development workflow
########################


This section describes the adopted workflow for the continuous integration
in the EDF repository.


Rules for EDF continuous integration
====================================

- The master branch is ``asterxx``.
  Developers must not commit revisions in this branch.

- Developers must use their own branch for commit: ``asterxx/XY`` (use your
  initials for XY).

- Commit message must refers the an existing issue.

- Some of branches are automatically and continuously integrated.


Configure your repository
=========================

.. note:: In the examples, the repositories paths are
    :file:`$HOME/dev/codeaster-xx/src` for *src* and
    :file:`$HOME/dev/codeaster/devtools` for *devtools* (only one *devtools*
    repository is sufficient).

- Update the devtools repository:

  .. code-block:: sh

        cd $HOME/dev/codeaster/devtools && hg pull && hg update default

- Configure the URL of the remote repositories:

  .. code-block:: sh

        cd $HOME/dev/codeaster-xx/src
        install_env
        # or
        $HOME/dev/codeaster/devtools/bin/install_env

  It should print something like:

  .. code-block:: none

        Configuring 'src' repository...
        INFO     checking repository $HOME/data/dev/codeaster-xx/src
        INFO     settings added into $HOME/data/dev/codeaster-xx/src/.hg/hgrc
        INFO     checking repository $HOME/data/dev/codeaster-xx/data
        INFO     settings added into $HOME/data/dev/codeaster-xx/data/.hg/hgrc
        INFO     checking repository $HOME/data/dev/codeaster-xx/validation
        INFO     settings added into $HOME/data/dev/codeaster-xx/validation/.hg/hgrc
        INFO     checking repository $HOME/data/dev/codeaster-xx/devtools
        INFO     checking asrun preferences...
        Do you want to automatically configure and build code_aster (y/n)? n
        INFO     Instructions to build code_aster:
        . $HOME/dev/codeaster/devtools/etc/env_unstable.sh
        cd $HOME/data/dev/codeaster-xx/src
        ./waf configure
        ./waf install


Development workflow
====================

See the example below (time is botton-up):

.. code-block:: none

    @    8:6f14c26b8c70 asterxx: merge 'asterxx/mc'
    |\
    | o  7:0793faaeb163 asterxx/mc: [#45678] Other fixes.
    | |
    | o  6:9c0af2ba8f71 asterxx/mc: [#45678] Add changes for the same feature
    | |
    o |  5:2a2addf7b938 asterxx: merge 'asterxx/mc'
    |\|
    | o  4:90eb433b033c asterxx/mc: [#45678] Reopen same developer branch for new feature
    |/
    o    3:f8f46913a29e asterxx: merge 'asterxx/mc'
    |\
    | o  2:ecd673612c7b asterxx/mc: [#12345] Continue development for feature 12345
    | |
    | o  1:4e177336ac01 asterxx/mc: [#12345] Start feature for 12345
    |/
    o  0:8b5355e95334 asterxx: Main branch: asterxx

.. Commands to create this sample tree
.. hg init
.. echo 1 > hello
.. hg add
.. hg branch asterxx
.. hg ci -m "Main branch: asterxx"
.. hg branch asterxx/mc
.. echo 1 >> hello
.. hg ci -m '[#12345] Start feature for 12345'
.. echo 1 >> hello
.. hg ci -m '[#12345] Continue development for feature 12345'
.. hg update asterxx
.. hg merge asterxx/mc
.. hg ci -m "merge 'asterxx/mc'"
.. hg branch -f asterxx/mc
.. echo 1 >> hello
.. hg ci -m "[#45678] Reopen same developer branch for new feature"
.. hg update asterxx
.. hg merge asterxx/mc
.. hg ci -m "merge 'asterxx/mc'"
.. hg up asterxx/mc
.. echo 1 >> hello
.. hg ci -m "[#45678] Add changes for the same feature"
.. echo 1 >> hello
.. hg ci -m "[#45678] Other fixes."
.. hg up asterxx
.. hg merge asterxx/mc
.. hg ci -m "merge 'asterxx/mc'"
.. hg log -G --template="{rev}:{node|short} {branch}: {desc|firstline}\n"

#. Start branch (``hg branch asterxx/mc``) and hack code.

#. Continue hacking and submit your work (``hg submit``).

#. **If the checkings pass, the robot automatically merges in the master branch.**

#. Reopen the branch from master for a new feature
   (``hg up asterxx && hg branch -f asterxx/mc``).
   Code and submit changes (``hg submit``).

#. **If the checkings pass, the robot automatically merges in the master branch.**

#. Additional developments are required, continue from the same branch.

#. More changes and submission (``hg submit``).

#. **If the checkings pass, the robot automatically merges in the master branch.**


Memo:

- Reuse the same branch name.

- Continue on the same branch if you continue on the same feature.

- Reopen the branch from master for new feature (``hg branch -f ...``).


List of checkings
=================

To be accepted, the developments must pass the following checkings.

- Merge with master branch (``asterxx``) should be trivial
  (checked by ``check_automerge.sh``).
  *In case of conflicts you have to merge master branch in yours first.*

- Check sequential and parallel builds.

- Check build of the embedded documentation (checked by ``check_docs.sh``).

- Check that sequential testcases are passed (``asterxx`` testlist).

- Check that parallel testcases are passed (``asterxx`` testlist).


``hg submit`` checks the same steps except the parallel build and the parallel
testcases.

Source files are checked by *aslint*.
Issues must be validated and changed documents must be submitted.
