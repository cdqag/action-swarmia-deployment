# action-swarmia-deployment

![GitHub License](https://img.shields.io/github/license/cdqag/action-swarmia-deployment)
![GitHub Release](https://img.shields.io/github/v/release/cdqag/action-swarmia-deployment)

A GitHub Action for registering deployments in [Swarmia](https://www.swarmia.com/) via the [Deployment API](https://help.swarmia.com/getting-started/configuration/configuring-deployments-in-swarmia/generate-deployments-via-the-deployment-api).

## Example usage

```yaml
- name: Send deployment to Swarmia
  uses: cdqag/action-swarmia-deployment@v1
  with:
    auth-header: ${{ secrets.SWARMIA_DEPLOYMENTS_AUTHORIZATION }}
    version: ${{ github.sha }}
    app-name: my-app
    environment: production
```

## Inputs

| Name | Required | Description |
|------|----------|-------------|
| `auth-header` | **yes** | Authorization header value for Swarmia API. Pass from a GitHub secret. |
| `version` | **yes** | Identifier for the deployed version (e.g. semantic version, release tag, or commit SHA). |
| `app-name` | **yes** | Identifier for the component being deployed. |
| `environment` | no | Deployment environment. Defaults to `default` on the Swarmia side. |
| `deployed-at` | no | Timestamp in ISO 8601 format. Defaults to current time. |
| `description` | no | Description for the deployment (max 2048 characters). |
| `commit-sha` | no | Full SHA of the latest commit in the deployment. Used to associate PRs (defualt `${{ github.sha }}`). |
| `repository-full-name` | no | Repository full name. Required if `commit_sha` is provided (defualt `${{ github.repository }}`). |
| `included-commit-shas` | no | JSON array of commit SHAs (e.g. `["sha1","sha2"]`). For monorepo setups. |
| `file-path-filter` | no | File path filter for monorepo setups. |

## Error handling

If the Swarmia API returns an HTTP status code >= 400, the action fails and prints the error response so the reason is clear in the workflow logs.

## License

[Apache-2.0](LICENSE)
