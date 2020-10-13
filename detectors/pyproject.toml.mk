virtualenvs.in-project: true

poetry.lock: ACTION := update,install
poetry.lock: pyproject.toml
  $(POETRY) $(ACTION)
  #  --no-root in CI

