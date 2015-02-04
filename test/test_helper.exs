# Ensures test DB is empty and fully migrated
Mix.Tasks.Ecto.Rollback.run(["--all"])
Mix.Tasks.Ecto.Migrate.run(["--all"])
ExUnit.start
