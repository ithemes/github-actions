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
