:erlang.system_flag :backtrace_depth, 50
ExUnit.configure exclude: [pending: true]
ExUnit.start
Application.ensure_all_started(:bamboo)
Application.ensure_all_started(:ex_machina)
Pact.put(:google_strategy, FakeGoogleStrategy)

# Create the database, run migrations, and start the test transaction.
Mix.Task.run "ecto.drop", ["--quiet"]
Mix.Task.run "ecto.create", ["--quiet"]
Mix.Task.run "ecto.migrate", ["--quiet"]
Ecto.Adapters.SQL.begin_test_transaction(Constable.Repo)
