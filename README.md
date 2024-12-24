# Shell User Interactions

_A collection of shell scripts that help implement user interactions like asking for confirmation or notifying that a longer operation is taking place and the user has to be patient._

![Build Status](https://github.com/inkarkat/shell-user-interactions/actions/workflows/build.yml/badge.svg)

With the offered reusable commands, these typical interactions can be dealt with in a consistent way and with more powerful functionality than when this is re-implemented over and over again.

### Dependencies

* Bash, GNU `awk`, GNU `sed`
* [inkarkat/miniDB](https://github.com/inkarkat/miniDB) for the `durationMessage` command
* [inkarkat/shell-basics](https://github.com/inkarkat/shell-basics) for the `invocationNotification` command
* automated testing is done with _bats - Bash Automated Testing System_ (https://github.com/bats-core/bats-core)
* [inkarkat/shell-filters](https://github.com/inkarkat/shell-filters) for automated tests

### Installation

* The `./bin` subdirectory is supposed to be added to `PATH`.
