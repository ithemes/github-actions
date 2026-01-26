# GitHub Actions for SolidWP

GitHub Actions used within the product ecosystem

## Usage

This is a work in progress. The goal is to replace the existing iThemes Build system with GitHub Actions.

## Generate Plugin Zip GitHub Workflow

This GitHub workflow automates the process of generating a plugin zip file for distribution. It is triggered manually through the _workflow_dispatch_ event and supports specifying a custom git commit reference (branch, tag, or hash). If no reference is provided, it uses the current branch.

### Workflow Inputs

- `ref` (optional): The git commit reference (branch, tag, or hash) to be used for generating the plugin zip. Defaults to the current branch.
- `plugin_slug` (required): The slug of the plugin. It's used for naming the generated zip file and pot file.
- `install_composer_packages` (optional): A boolean flag to indicate if the composer dependencies should be installed as part of the build. Defaults to `false`.
- `install_npm_packages` (optional): A boolean flag to indicate if the npm dependencies should be installed and built as part of the build. Defaults to `false`.

### Workflow Steps

1. Calls the reusable workflow `generate-zip.yml` from the `ithemes/github-actions` repository, passing the required inputs.
2. The reusable workflow checks out the specified `ref` from the repository.
3. Runs the plugin LION script.
4. Installs composer dependencies (if `install_composer_packages` is set to `true`).
5. Sets up Node.js and installs npm dependencies (if `install_npm_packages` is set to `true`).
6. Generates a `.pot` file for translations.
7. Generates the plugin zip file, excluding files and directories specified in the `.distignore` file.
8. Uploads the generated plugin zip as an artifact.

To trigger this workflow manually, navigate to the "Actions" tab in your repository, select the "Generate Plugin Zip" workflow, and click the "Run workflow" button. Fill in the required input fields and click the "Run workflow" button again.

## Plugin Release

The `create-release` action (`.github/actions/create-release/action.yml`) automates the full release process for a
plugin. It is designed to be consumed within a plugin's own release workflow.

### Inputs

| Input                   | Required | Description                                 |
|-------------------------|----------|---------------------------------------------|
| `plugin_slug`           | Yes      | The slug of the plugin to release           |
| `ref`                   | Yes      | Git commit reference (branch, tag, or hash) |
| `github_token`          | Yes      | GitHub token for creating releases          |
| `plugin_deploy_key`     | Yes      | Plugin deploy key for api.ithemes.com       |
| `aws_access_key_id`     | Yes      | AWS Access Key ID for S3 upload             |
| `aws_secret_access_key` | Yes      | AWS Secret Access Key for S3 upload         |

### What It Does

1. Extracts version metadata (plugin version, minimum WP version, minimum PHP version) from the plugin's main PHP file.
2. Generates a distributable zip file using the `.distignore` file to exclude unnecessary files.
3. Creates a GitHub release tagged with the plugin version.
4. Uploads the zip file to the GitHub release as an asset.
5. Uploads the zip file to S3 (`downloads.ithemes.com`).
6. Notifies the Solid API about the new plugin version.

### What Happens Next

Solid
API [receives the webhook](https://github.com/ithemes/api-ithemes-com/blob/bf2db53c5ba5e0ac541386b9b5c14c9e5677505e/api/actions/action.product.deploy_plugin_update.php),
stores new plugin version metadata in the `pkg_version` database table and inform Adminber via API. The `updater`
library (included as submodule in the
plugin) refreshes the plugin
metadata [regularly](https://github.com/ithemes/updater/blob/e765b132b6e758a981153ec29d026e2efc780d92/api.txt#L17-L21)
from [Solid API](https://github.com/ithemes/api-ithemes-com/blob/9508fbe8e3e5b8e93601a15d27fb5c9fedc6ae7d/api/actions/action.updater.package_details.php).
If the plugin version
is [higher than the one currently installed](https://github.com/ithemes/updater/blob/4b1f9284b5feadc25ba1a0399c369efccbf39086/updates.php#L57-L181),
the library uses `transient_update_plugins` filter to provide information about the new plugin version
to [WordPress](https://github.com/WordPress/WordPress/blob/ecc9f15d4c66e80c5b99f1bb2455cd55614441c9/wp-admin/includes/update.php#L406-L419).
The plugin is updated using the WordPress update
mechanism ([S3 storage](https://github.com/ithemes/api-ithemes-com/blob/bf2db53c5ba5e0ac541386b9b5c14c9e5677505e/api/logic/logic.product.php#L91-L106)
is used for downloading
the [plugin ZIP](https://github.com/ithemes/api-ithemes-com/blob/9508fbe8e3e5b8e93601a15d27fb5c9fedc6ae7d/api/actions/action.updater.package_details.php#L217-L218)).
