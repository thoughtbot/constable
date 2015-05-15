:erlang.system_flag :backtrace_depth, 25
ExUnit.configure exclude: [pending: true]
ExUnit.start

# Create the database, run migrations, and start the test transaction.
Mix.Task.run "ecto.drop", ["--quiet"]
Mix.Task.run "ecto.create", ["--quiet"]
Mix.Task.run "ecto.migrate", ["--quiet"]
Ecto.Adapters.SQL.begin_test_transaction(Constable.Repo)
