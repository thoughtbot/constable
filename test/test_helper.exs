:erlang.system_flag :backtrace_depth, 50
ExUnit.configure exclude: [pending: true]
{:ok, _} = Application.ensure_all_started(:wallaby)
ExUnit.start
{:ok, _} = Application.ensure_all_started(:bamboo)
{:ok, _} = Application.ensure_all_started(:wallaby)
Pact.put(:google_strategy, FakeGoogleStrategy)

# Create the database, run migrations, and start the test transaction.
Mix.Task.run "ecto.drop", ["--quiet"]
Mix.Task.run "ecto.create", ["--quiet"]
Mix.Task.run "ecto.migrate", ["--quiet"]
Ecto.Adapters.SQL.begin_test_transaction(Constable.Repo)
