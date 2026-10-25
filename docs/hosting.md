# Host ActantBot WorkDesk

This guide takes an operator from an approved release artifact to a private WorkDesk deployment. It assumes Docker Compose, a PostgreSQL-capable host, and an OIDC identity provider.

## 1. Prepare the host

Use a Linux host with Docker Engine and the Docker Compose plugin. Place the deployment directory on encrypted storage with a backup policy.

Allow inbound traffic only to the public HTTPS ingress. Keep the WorkDesk server, kernel, PostgreSQL, and Keycloak ports on the private network.

Create a dedicated deployment account. Do not run the stack from a shared home directory.

## 2. Obtain approved artifacts

The public repository contains the deployment contract. It does not contain the application source or application images.

Obtain these artifacts from the release owner.

| Artifact | Required for |
| --- | --- |
| WorkDesk server image | Portal server, OIDC callback, API, and orchestration |
| WorkDesk portal asset or server image | User interface |
| ActantOS kernel image | Policy evaluation, decision signing, execution, and audit |
| Approved runbook catalog | ActantBot IT procedures |
| Keycloak realm or OIDC client configuration | Workforce sign-in |

Record the release identifier and checksum in the change record. Do not deploy an image tagged only `latest`.

## 3. Create the operator configuration

```bash
cp deploy/.env.example deploy/.env
chmod 600 deploy/.env
```

Set every `replace-me` value. Use a password manager or a secret manager for the real values. Do not commit `deploy/.env`.

The minimum production values are:

- `WORKDESK_SERVER_IMAGE`.
- `KERNEL_IMAGE`.
- `WORKDESK_PUBLIC_URL`.
- `OIDC_ISSUER`.
- `OIDC_CLIENT_ID` and `OIDC_CLIENT_SECRET`.
- `SESSION_SECRET` with at least 32 random characters.
- `ACTANTOS_HMAC_SECRET` when the release uses HMAC decision verification.
- `POSTGRES_PASSWORD` and `KERNEL_POSTGRES_PASSWORD`.
- `WORKDESK_DATABASE_URL` and `KERNEL_DATABASE_URL`.

Use the Ed25519 public key path when the approved kernel release uses asymmetric decision tokens. Keep the private signing key inside the kernel boundary.

## 4. Configure identity

Register one OIDC client for WorkDesk.

Set the exact callback URI to:

```text
https://workdesk.example.com/auth/callback
```

Set the allowed web origin to the WorkDesk public URL. Map the identity groups used by your organization to the WorkDesk roles. Keep the mapping narrow. Start with one employee account, one IT approver, one security owner, and one knowledge owner.

Require multi-factor authentication in the identity provider. Do not put passwords or one-time passcodes in a runbook or chat message.

## 5. Render and inspect the Compose plan

Run the config check before starting any container.

```bash
docker compose -f deploy/docker-compose.reference.yml --env-file deploy/.env config
```

Inspect the output for these properties.

- Public ports terminate at the ingress.
- PostgreSQL ports bind to the private network only.
- Kernel traffic uses the private service name.
- Production mode is enabled.
- No example secret remains.
- Persistent volumes exist for both databases.

## 6. Start the stack

```bash
docker compose -f deploy/docker-compose.reference.yml --env-file deploy/.env pull
docker compose -f deploy/docker-compose.reference.yml --env-file deploy/.env up -d
docker compose -f deploy/docker-compose.reference.yml --env-file deploy/.env ps
```

If the release requires database migrations, run the release migration command before opening the portal to employees. Keep the previous image available until the new release passes the smoke check.

## 7. Verify the user path

Run the checks below from a trusted operator workstation.

```bash
curl -fsS "${WORKDESK_PUBLIC_URL}/healthz"
docker compose -f deploy/docker-compose.reference.yml --env-file deploy/.env exec kernel wget -qO- http://localhost:3100/healthz
```

Then complete this smoke path.

1. Sign in with the employee test account.
2. Open **ActantBot IT**.
3. Submit a harmless request that matches an approved runbook.
4. Confirm the exact request content before approval.
5. Verify the kernel decision and receipt.
6. Open **ActantBot Access** and confirm the timeline.
7. Submit a synthetic security report in the approved test tenant.
8. Confirm that the report is visible only to the security role.

Stop the release if the portal shows a successful action without a receipt, a user can cross the tenant boundary, or a request can bypass approval.

## 8. Put the portal behind HTTPS

Terminate TLS at the approved ingress. Forward the original host and protocol headers. Configure the WorkDesk public URL to use HTTPS. Set secure cookies in production.

Do not expose the kernel health endpoint outside the private network. If an external monitor needs health data, expose a separate authenticated probe or use an internal monitor.

## 9. First production handoff

Record these values in the operator change record.

- Release identifier and image digests.
- OIDC issuer and client identifier.
- Database backup location and restore owner.
- Policy bundle identifier.
- Approved runbook catalog version.
- Smoke-check timestamp and result.
- Escalation owner and support hours.

The public guide does not prove a live provider integration. Confirm the connector and reconciliation behavior in the target environment before making that claim.
