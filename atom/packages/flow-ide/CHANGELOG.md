#### 1.3.0

- Terminate flow servers on deactivate
- Fix path.dirname deprecation by ignoring autocomplete requests on files not yet saved

#### 1.2.4

- Had to bump version because of some issues in deployment (network)

#### 1.2.2

- Handle coverage count zero (#52)

#### 1.2.1

- Fix flow type checking (#49)

#### 1.2

- Add Flow coverage view

#### 1.1.10
- Provide a default .flowconfig file if onlyIfAppropriate is enabled and a .flowconfig file is not found already

#### 1.1.9

- Fix autocompletion for properties (#33)
- Remove types from function params (#8)

#### 1.1.8

- APM was having hiccups back then so didn't publish properly

#### 1.1.7

- Fix a bug in last release

#### 1.1.6

- Workaround a Atom's builtin babel bug

#### 1.1.5

- Just another patch to catch more flow errors gracefully

#### 1.1.4

- Handle flow crashes/respawns gracefully

#### 1.1.3

- Show entire linter error message

#### 1.1.1-1.1.2

- Fix a bug introduced in 1.1.0 where autocomplete wouldn't work
- Fix a reference to undefined variable in case of error ( Fixes #12 )

#### 1.1.0

- Add support for locally installed flow bins
- Bump `atom-linter` to v5

#### 1.0.6

- Show a correct type for Objects in autocomplete
- Only run autocomplete at appropriate times ( Fixes #3 )

#### 1.0.5

- Fix a bug in retrying for server
- Fix a bug where deep nested objects would mess up autocomplete

#### 1.0.4

- Bump `atom-package-deps` version

#### 1.0.3

- Bump `atom-linter` dependency to include fix for projects that don't have a `.flowcofig`

#### 1.0.2

- Improve handling of fatal errors

#### 1.0.1

- Implement smart sorting and filtering of autocomplete suggestions
- Make linter messages more user friendly

#### 1.0.0

- Linting support added
- Autocomplete support added
