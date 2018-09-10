ExUnit.configure exclude: [pending: true], max_cases: 10
{:ok, _} = Application.ensure_all_started(:bamboo)
{:ok, _} = Application.ensure_all_started(:wallaby)
ExUnit.start
Constable.Pact.register(:google_strategy, FakeGoogleStrategy)
Ecto.Adapters.SQL.Sandbox.mode(Constable.Repo, :manual)
