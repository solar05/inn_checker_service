# InnCheckerService
![CI](https://github.com/solar05/inn_checker_service/workflows/CI/badge.svg)

[Heroku link](https://inn-checker.herokuapp.com)


# Commands
To setup project:
```bash
$ mix deps.get
$ mix compile
$ mix ecto.setup
```

To run project: 
```bash
$ make run
```
and after that visit [`localhost:4000`](http://localhost:4000)

To run test use: 
```bash
$ make tests
```

To run linter-check: 
```bash
$ make format-check
```
To run linter fixes:
```bash
$ make format
```

# Description
A service, that validates your INN.
Creditionals locates at priv/repo/seeds.exs