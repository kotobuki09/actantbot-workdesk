# Contributing

Keep this repository safe to copy and easy to audit.

## Documentation rules

- Write in English in the main guide. Keep the Vietnamese guide aligned.
- Use exact commands and paths from the reference deployment.
- Mark lab, mock-tested, not-run, and blocked claims clearly.
- Use `example.com`, `replace-me`, and synthetic identifiers in examples.
- Do not add private source, customer data, credentials, or raw production screenshots.
- Keep screenshots current with the portal release they describe.

## Local checks

Run the public-surface check before opening a pull request.

```powershell
pwsh -File scripts/check-public-surface.ps1
docker compose -f deploy/docker-compose.reference.yml --env-file deploy/.env.example config
```

The Compose check confirms that the reference file parses. It does not prove that placeholder images or external identity configuration are available.
