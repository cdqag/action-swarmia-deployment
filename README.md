# action-swarmia-deployment

A GitHub Action for registering deployments in [Swarmia](https://www.swarmia.com/) via the [Deployment API](https://help.swarmia.com/getting-started/configuration/configuring-deployments-in-swarmia/generate-deployments-via-the-deployment-api).

## Example usage

```yaml
- name: Send deployment to Swarmia
  uses: cdqag/action-swarmia-deployment@master
  with:
    auth_header: ${{ secrets.SWARMIA_DEPLOYMENTS_AUTHORIZATION }}
    version: ${{ github.sha }}
    app_name: my-app
    environment: production
    commit_sha: ${{ github.sha }}
    repository_full_name: ${{ github.repository }}
```

## Inputs

| Name | Required | Description |
|------|----------|-------------|
| `auth_header` | **yes** | Authorization header value for Swarmia API. Pass from a GitHub secret. |
| `version` | **yes** | Identifier for the deployed version (e.g. semantic version, release tag, or commit SHA). |
| `app_name` | **yes** | Identifier for the component being deployed. |
| `environment` | no | Deployment environment. Defaults to `default` on the Swarmia side. |
| `deployed_at` | no | Timestamp in ISO 8601 format. Defaults to current time. |
| `description` | no | Description for the deployment (max 2048 characters). |
| `commit_sha` | no | Full SHA of the latest commit in the deployment. Used to associate PRs. |
| `repository_full_name` | no | Repository full name. Required if `commit_sha` is provided. |
| `included_commit_shas` | no | JSON array of commit SHAs (e.g. `["sha1","sha2"]`). For monorepo setups. |
| `file_path_filter` | no | File path filter for monorepo setups. |

## Error handling

If the Swarmia API returns an HTTP status code >= 400, the action fails and prints the error response so the reason is clear in the workflow logs.

## License

[Apache-2.0](LICENSE)
