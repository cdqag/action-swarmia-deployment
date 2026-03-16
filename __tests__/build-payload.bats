load "test_helper/bats-support/load"
load "test_helper/bats-assert/load"
load "test_helper/common"

setup() {
	common_setup
	source "$PROJECT_ROOT/build-payload.sh"
}

@test "build_json_payload should create JSON with only required fields" {
	export INPUT_VERSION="v1.0.0"
	export INPUT_APP_NAME="my-app"

	run build_json_payload

	assert_success
	assert_output '{"version":"v1.0.0","appName":"my-app"}'
}

@test "build_json_payload should skip empty optional fields" {
	export INPUT_VERSION="v1.0.0"
	export INPUT_APP_NAME="my-app"
	export INPUT_ENVIRONMENT=""
	export INPUT_DESCRIPTION=""
	export INPUT_COMMIT_SHA=""

	run build_json_payload

	assert_success
	assert_output '{"version":"v1.0.0","appName":"my-app"}'
}

@test "build_json_payload should include a subset of optional fields" {
	export INPUT_VERSION="v1.0.0"
	export INPUT_APP_NAME="cdq-bot-service"
	export INPUT_ENVIRONMENT="production"
	export INPUT_COMMIT_SHA="3fc4a317364fa427cfa8238369eb8535aa1d1670"
	export INPUT_REPOSITORY_FULL_NAME="octocat/example"

	run build_json_payload

	assert_success
	assert_output '{"version":"v1.0.0","appName":"cdq-bot-service","environment":"production","commitSha":"3fc4a317364fa427cfa8238369eb8535aa1d1670","repositoryFullName":"octocat/example"}'
}

@test "build_json_payload should create JSON with all fields" {
	export INPUT_VERSION="v2.0.5"
	export INPUT_APP_NAME="frontend"
	export INPUT_ENVIRONMENT="production"
	export INPUT_DEPLOYED_AT="2022-04-11T02:22:47Z"
	export INPUT_DESCRIPTION="Release with new widget"
	export INPUT_COMMIT_SHA="3fc4a317364fa427cfa8238369eb8535aa1d1670"
	export INPUT_REPOSITORY_FULL_NAME="octocat/example"
	export INPUT_INCLUDED_COMMIT_SHAS='["aaa111","bbb222"]'
	export INPUT_FILE_PATH_FILTER="src/frontend/"

	run build_json_payload

	assert_success
	assert_output '{"version":"v2.0.5","appName":"frontend","environment":"production","deployedAt":"2022-04-11T02:22:47Z","description":"Release with new widget","commitSha":"3fc4a317364fa427cfa8238369eb8535aa1d1670","repositoryFullName":"octocat/example","includedCommitShas":["aaa111","bbb222"],"filePathFilter":"src/frontend/"}'
}
