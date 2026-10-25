# ActantBot WorkDesk operations guide

Use this guide after the stack passes the hosting smoke check.

## Check service health

```bash
docker compose -f deploy/docker-compose.reference.yml --env-file deploy/.env ps
docker compose -f deploy/docker-compose.reference.yml --env-file deploy/.env logs --since=15m workdesk
docker compose -f deploy/docker-compose.reference.yml --env-file deploy/.env logs --since=15m kernel
```

Check the public WorkDesk health endpoint and the private kernel health endpoint from their allowed networks. A healthy container is not enough. The sign-in, runbook, approval, and receipt path must also work.

## Backup PostgreSQL

Run a logical backup for each database. Store the files outside the host and encrypt them at rest.

```bash
docker compose -f deploy/docker-compose.reference.yml --env-file deploy/.env exec -T workdesk-db \
  pg_dump -U "$POSTGRES_USER" -d "$POSTGRES_DB" > workdesk-$(date +%Y%m%d-%H%M%S).sql

docker compose -f deploy/docker-compose.reference.yml --env-file deploy/.env exec -T kernel-db \
  pg_dump -U "$KERNEL_POSTGRES_USER" -d "$KERNEL_POSTGRES_DB" > kernel-$(date +%Y%m%d-%H%M%S).sql
```

The shell must receive the database variables from the operator environment. Do not put the password on the command line. Test restore on a separate host before relying on the backup.

## Restore procedure

1. Stop writes at the ingress.
2. Create a clean recovery database.
3. Restore the WorkDesk dump.
4. Restore the kernel dump.
5. Start the approved release against the recovery databases.
6. Reconcile request, receipt, and audit counts.
7. Run the sign-in and harmless-request smoke path.
8. Record the restore result before reopening writes.

Never restore over the only copy of a production database.

## Upgrade procedure

1. Read the release notes and migration notes.
2. Capture backups and image digests.
3. Render the new Compose plan with `docker compose config`.
4. Start the new release in a staging tenant.
5. Run the full smoke path.
6. Apply the migration during the approved change window.
7. Roll the server and kernel together when their contracts changed.
8. Monitor health, sign-in, receipt creation, and reconciliation.
9. Keep the previous image available until the rollback window closes.

## Degraded operation

If the kernel is unavailable, do not run a new write action. Leave the request in a pending or blocked state and show the approved manual escalation path.

If a connector times out, keep the request indeterminate. Reconcile it against the provider before reporting success or failure.

If the identity provider is unavailable, do not bypass OIDC with a hidden demo login. Restore the identity path or use the documented emergency process.

## Incident evidence

Collect the release identifier, affected tenant, request identifier, relevant timestamps, health output, and sanitized logs. Remove access tokens, cookies, email addresses, and customer content before sharing the record.

An incident record must distinguish these states.

- **Verified** means the system produced direct evidence.
- **Mock-tested** means a mock connector or test fixture produced the result.
- **Not run** means no evidence exists.
- **Blocked** means an external owner, integration, or environment is required.
