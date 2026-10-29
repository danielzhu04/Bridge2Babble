import os
import testmu_appium
from testmu_appium import var, set_var

testmu_appium.configure(
    kane_run_v4=True,
    platform="ios",
    app="lt://APP1016040991792873567451356",
    device_name="iPhone.*",
    platform_version="27",
    build="4787738a-e3a2-4ae8-8003-43b601b7dcc2",
    name="Translate Phrase Using Bridge2Babble Without Apple Resources",
    tc_id="TC-15",
    variables={"english_source_language_check": "English", "spanish_destination_language_check": "Spanish", "spanish_translation_appears": "false", "spanish_translation_apple_intelligence_label": "false", "apple_intelligence_availability_or_translation_error": "Status: Error: Translation failed. English → Spanish needs a download, and Apple Intelligence is still downloading."},
    global_variables=[{"id": 464885, "name": "spanish_clinic_phrase", "value": "¿Tiene alergias a algún medicamento?", "session_value": "¿Tiene alergias a algún medicamento?", "is_persist": False, "environment_id": 0, "environment_name": "No Env"}],
    default_action_timeout_ms=10000,
)

@testmu_appium.test
def test(driver):
    with testmu_appium.step('English is the source and Spanish is the destination.', instruction_id='72255cd4-1e2b-4591-a30f-208fd5dd607a'):
        testmu_appium.verify_assertion(driver, tree={'operator': ['equals'], 'assertion_operands': [], 'left_operand': None, 'right_operand': None, 'operands': [], 'sub_results': [{'description': 'English is the source.', 'passed': True, 'operator': 'equals', 'transforms': [], 'json_path': None, 'expected': 'English', 'extracted_value': '{{english_source_language_check}}', 'store_key': 'english_source_language_check', 'variable_refs': {'{{english_source_language_check}}': 'English'}}, {'description': 'Spanish is the destination.', 'passed': True, 'operator': 'equals', 'transforms': [], 'json_path': None, 'expected': 'Spanish', 'extracted_value': '{{spanish_destination_language_check}}', 'store_key': 'spanish_destination_language_check', 'variable_refs': {'{{spanish_destination_language_check}}': 'Spanish'}}], 'sub_checks': [{'description': 'English is the source.', 'store_key': 'english_source_language_check', 'expected_value': 'English', 'extracted_value': '{{english_source_language_check}}', 'operator': 'equals', 'transforms': []}, {'description': 'Spanish is the destination.', 'store_key': 'spanish_destination_language_check', 'expected_value': 'Spanish', 'extracted_value': '{{spanish_destination_language_check}}', 'operator': 'equals', 'transforms': []}], 'composite_operator': 'and', 'claim': 'English is the source and Spanish is the destination.'}, description='English is the source and Spanish is the destination.')

    with testmu_appium.step('Typing in English source text field', instruction_id='b74f8189-5248-4d62-b6f1-703783f47fa5'):
        testmu_appium.type(
            driver,
            selectors=[
                {"selector": "translateTextField", "score": 80, "isXPath": False, "strategy": "accessibility_id"},
            ],
            description='Typing in English source text field',
            text="Do you have any allergies to medication?",
            clear_first=True,
        )

    with testmu_appium.step('Clicking Translate button', instruction_id='9fae723d-7ab6-4ed2-ab12-94e76e37c115'):
        testmu_appium.click(
            driver,
            selectors=[
                {"selector": "translateButton", "score": 80, "isXPath": False, "strategy": "accessibility_id"},
                {"selector": "Translate", "score": 60, "isXPath": False, "strategy": "text"},
            ],
            description='Clicking Translate button',
        )
    _condition_met = False
    _until_retries = 0
    while _until_retries < 10:
        print(f"[until-loop] iteration {_until_retries + 1}/10")
        with testmu_appium.step('Waiting for the translation result status', instruction_id='182b3efe-1d55-4cb9-bf3a-b7c18776fe91'):
            testmu_appium.wait(
                driver,
                ms=5,
                description='Waiting for the translation result status',
            )
        testmu_appium.wait(driver, ms=500)
        if testmu_appium.check_until_condition(driver, 'the status message "Translation failed. English → Spanish needs a download, and Apple Intelligence is still downloading." is visible'):
            _condition_met = True
            break
        _until_retries += 1
    set_var("__result__", {"condition_met": _condition_met, "retries": _until_retries + 1})
    if testmu_appium.evaluate_branch(sub_checks=[{"description": "A Spanish translation appears.", "store_key": "spanish_translation_appears", "expected_value": "true", "stored_value": "{{spanish_translation_appears}}", "operator": "equals", "transforms": []}, {"description": "The Spanish translation is labeled or reported as using Apple Intelligence.", "store_key": "spanish_translation_apple_intelligence_label", "expected_value": "true", "stored_value": "{{spanish_translation_apple_intelligence_label}}", "operator": "equals", "transforms": []}], composite_operator='and'):
        testmu_appium.execute_kane_cli(driver, objective='continue after confirming the Spanish translation is labeled or reported as using Apple Intelligence')
    else:
        testmu_appium.execute_kane_cli(driver, objective='record the exact visible Apple Intelligence availability or translation error. Get the exact visible Apple Intelligence availability or translation error and save it as {{apple_intelligence_availability_or_translation_error}}.')


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

