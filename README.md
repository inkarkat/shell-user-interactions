# Shell User Interactions

_A collection of shell scripts that help implement user interactions like asking for confirmation or notifying that a longer operation is taking place and the user has to be patient._

With the offered reusable commands, these typical interactions can be dealt with in a consistent way and with more powerful functionality than when this is re-implemented over and over again.

### Dependencies

* Bash, GNU `awk`, GNU `sed`
* [inkarkat/miniDB](https://github.com/inkarkat/miniDB) for the `durationMessage` command
* automated testing is done with _bats - Bash Automated Testing System_ (https://github.com/bats-core/bats-core)

### Installation

* The `./bin` subdirectory is supposed to be added to `PATH`.
