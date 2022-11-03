fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios submit_build

```sh
[bundle exec] fastlane ios submit_build
```



### ios change_app_icon

```sh
[bundle exec] fastlane ios change_app_icon
```



### ios test

```sh
[bundle exec] fastlane ios test
```

Running project tests

### ios update_devices

```sh
[bundle exec] fastlane ios update_devices
```

Add devices present on devices.txt to provisioning profile

### ios match_development

```sh
[bundle exec] fastlane ios match_development
```

Sync iOS keys and profiles used for development signing

### ios match_appstore

```sh
[bundle exec] fastlane ios match_appstore
```

Sync iOS keys and profiles used for AppStore signing

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
