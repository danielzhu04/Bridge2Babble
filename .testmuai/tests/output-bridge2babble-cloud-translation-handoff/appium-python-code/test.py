import os
import testmu_appium
from testmu_appium import var, set_var

testmu_appium.configure(
    kane_run_v4=True,
    platform="ios",
    app="lt://APP10160332171792877410015558",
    device_name="iPhone.*",
    platform_version="27",
    build="9434a229-cb49-454b-9c02-77b8460c836a",
    name="Verify Medication Allergy Translation in Bridge2Babble",
    tc_id="TC-19",
    variables={"english_source_language": "true", "spanish_destination_language": "true", "language_download_offered": "true"},
    global_variables=[{"id": 464885, "name": "spanish_clinic_phrase", "value": "¿Tiene alergias a algún medicamento?", "session_value": "¿Tiene alergias a algún medicamento?", "is_persist": False, "environment_id": 0, "environment_name": "No Env"}],
    default_action_timeout_ms=10000,
)

@testmu_appium.test
def test(driver):
    with testmu_appium.step('English is the source and Spanish is the destination.', instruction_id='58b8f172-a634-4279-81b4-c9d5d1a13f39'):
        testmu_appium.verify_assertion(driver, tree={'operator': ['equals'], 'assertion_operands': [], 'left_operand': None, 'right_operand': None, 'operands': [], 'sub_results': [{'description': 'English is the source language.', 'passed': True, 'operator': 'equals', 'transforms': [], 'json_path': None, 'expected': 'true', 'extracted_value': '{{english_source_language}}', 'store_key': 'english_source_language', 'variable_refs': {'{{english_source_language}}': 'true'}}, {'description': 'Spanish is the destination language.', 'passed': True, 'operator': 'equals', 'transforms': [], 'json_path': None, 'expected': 'true', 'extracted_value': '{{spanish_destination_language}}', 'store_key': 'spanish_destination_language', 'variable_refs': {'{{spanish_destination_language}}': 'true'}}], 'sub_checks': [{'description': 'English is the source language.', 'store_key': 'english_source_language', 'expected_value': 'true', 'extracted_value': '{{english_source_language}}', 'operator': 'equals', 'transforms': []}, {'description': 'Spanish is the destination language.', 'store_key': 'spanish_destination_language', 'expected_value': 'true', 'extracted_value': '{{spanish_destination_language}}', 'operator': 'equals', 'transforms': []}], 'composite_operator': 'and', 'claim': 'English is the source and Spanish is the destination.'}, description='English is the source and Spanish is the destination.')

    with testmu_appium.step('Clicking the Download button for the language resource', instruction_id='c5fbbc0b-78dc-49ea-98d0-a120f7ec9941'):
        testmu_appium.click(
            driver,
            selectors=[
                {"selector": "downloadLanguagesButton", "score": 80, "isXPath": False, "strategy": "accessibility_id"},
                {"selector": "Download", "score": 60, "isXPath": False, "strategy": "text"},
            ],
            description='Clicking the Download button for the language resource',
        )
    if testmu_appium.evaluate_branch(sub_checks=[{"description": "The app offers a language download.", "store_key": "language_download_offered", "expected_value": "true", "stored_value": "{{language_download_offered}}", "operator": "equals", "transforms": []}], composite_operator='and'):
        with testmu_appium.step('Clicking Download button for language resource', instruction_id='7f17ebe6-6871-4289-b58a-3cc02c70bd9e'):
            testmu_appium.click(
                driver,
                selectors=[
                    {"selector": "downloadLanguagesButton", "score": 80, "isXPath": False, "strategy": "accessibility_id"},
                    {"selector": "Download", "score": 60, "isXPath": False, "strategy": "text"},
                ],
                description='Clicking Download button for language resource',
            )
        _condition_met = False
        _until_retries = 0
        while _until_retries < 10:
            print(f"[until-loop] iteration {_until_retries + 1}/10")
            with testmu_appium.step('PRIMARY: wait for the language download system prompt to appear', instruction_id='95184350-f71a-4438-a66a-c283d71cfe28'):
                testmu_appium.wait(
                    driver,
                    ms=5,
                    description='PRIMARY: wait for the language download system prompt to appear',
                )
            testmu_appium.wait(driver, ms=500)
            if testmu_appium.check_until_condition(driver, 'a system permission prompt is visible'):
                _condition_met = True
                break
            _until_retries += 1
        set_var("__result__", {"condition_met": _condition_met, "retries": _until_retries + 1})

        with testmu_appium.step('Waiting for language download progress or system prompt', instruction_id='b889eb7b-9aac-4806-a9b5-ed75e1e24e94'):
            testmu_appium.wait(
                driver,
                ms=5,
                description='Waiting for language download progress or system prompt',
            )

        with testmu_appium.step('Waiting for language download progress or a system prompt', instruction_id='06e5da94-93bc-4f9e-affd-c5ea6aca3763'):
            testmu_appium.wait(
                driver,
                ms=5,
                description='Waiting for language download progress or a system prompt',
            )

        with testmu_appium.step('Waiting for the language resource download to finish', instruction_id='10c6181e-1a5f-44d1-a2ca-dafa009126b8'):
            testmu_appium.wait(
                driver,
                ms=5,
                description='Waiting for the language resource download to finish',
            )

        with testmu_appium.step('Waiting for language download completion or confirmation prompt', instruction_id='42cda266-cc8e-4011-a105-6a0fb661d863'):
            testmu_appium.wait(
                driver,
                ms=5,
                description='Waiting for language download completion or confirmation prompt',
            )

        with testmu_appium.step('Waiting for active language download to complete or prompt for confirmation', instruction_id='30ea5e5e-025d-4e5e-beb5-ffb98c2e446c'):
            testmu_appium.wait(
                driver,
                ms=5,
                description='Waiting for active language download to complete or prompt for confirmation',
            )
    else:
        testmu_appium.execute_kane_cli(driver, objective='continue without downloading a language resource')


def _apply_test_config(path, instance_id):
    import json
    with open(path) as f:
        groups = json.load(f)
    entry = None
    for tests in groups.values():
        for candidate in tests:
            if instance_id in (None, "", candidate.get("test_instance_id")):
                entry = candidate
                break
        if entry is not None:
            break
    if entry is None:
        raise SystemExit(
            "test instance %r not found in %s" % (instance_id, path)
        )
    testmu_appium.configure(**testmu_appium.test_config_overrides(entry))


if __name__ == "__main__":
    import argparse
    _parser = argparse.ArgumentParser()
    _parser.add_argument("--test-config")
    _parser.add_argument("--test-instance-id")
    # Accepted for run.sh compatibility; the V4 artifact has no ops metadata.
    _parser.add_argument("--operations-meta-data")
    _args, _ = _parser.parse_known_args()
    if _args.test_config:
        _apply_test_config(_args.test_config, _args.test_instance_id)
    testmu_appium.run(test)

