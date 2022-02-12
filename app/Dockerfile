FROM python:3.10-slim

COPY . /app
WORKDIR /app
RUN pip install poetry
RUN poetry config virtualenvs.create false \
  && poetry install $(test "$YOUR_ENV" == production && echo "--no-dev") --no-interaction --no-ansi
RUN chmod +x entrypoint.sh
CMD ["/app/entrypoint.sh"]
