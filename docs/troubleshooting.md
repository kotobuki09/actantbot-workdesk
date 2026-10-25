# ActantBot WorkDesk troubleshooting

Start with the symptom. Check the service that owns the failure before changing configuration.

## The portal returns 502 or 503

1. Check the WorkDesk container state.
2. Read the server logs from the last 15 minutes.
3. Check the server health endpoint from the private network.
4. Check the kernel health endpoint.
5. Confirm that `KERNEL_URL` resolves from the WorkDesk server container.

If the kernel is down, keep new write requests blocked. Do not route them to an unapproved fallback.

## Sign-in returns an OIDC error

Check these values as a set.

- `OIDC_ISSUER` points to the expected realm.
- `OIDC_CLIENT_ID` matches the registered client.
- `OIDC_CLIENT_SECRET` matches the client type.
- The callback URI exactly matches the public URL.
- `SESSION_SECRET` is present and has at least 32 characters.
- The ingress forwards the original host and HTTPS protocol.

Clear the test session and repeat the sign-in flow after correcting one value. Do not change the identity provider and the application at the same time without recording the change.

## The kernel reports `policy_pending` or `kernel_unavailable`

Check kernel health, the private network route, database health, and the configured policy bundle. A pending request is not an allowed request. Wait for a decision or use the manual escalation path.

## A request stays `indeterminate`

The connector may have accepted the operation before the network response was lost. Do not retry blindly. Run reconciliation with the provider and record the final receipt.

## A security report is visible to the wrong role

Stop the affected tenant. Check the access-control decision before the report query, then check the server log for the tenant and subject identifiers. Do not export the report while investigating. Open a private security report with sanitized evidence.

## The portal shows old assets

Check the image digest, the container start time, and the ingress cache. Confirm the release asset version in the served HTML. Purge only the affected cache after recording the current release identifier.

## Database migrations fail

Keep the previous release available. Capture the migration output. Restore the backup into a separate recovery database and test the migration there. Do not delete the production volume to make a migration pass.

## The example Compose file does not start

The public Compose file is a deployment reference. Confirm that all image variables point to approved artifacts. The file does not provide public application images, customer identity configuration, or production secrets.
