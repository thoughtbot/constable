# Ensures test DB is empty and fully migrated
Mix.Tasks.Ecto.Drop.run([])
Mix.Tasks.Ecto.Create.run([])
Mix.Tasks.Ecto.Migrate.run(["--all"])
ExUnit.start
