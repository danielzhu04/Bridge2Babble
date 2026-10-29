import os
import testmu_appium
from testmu_appium import var, set_var

testmu_appium.configure(
    kane_run_v4=True,
    platform="ios",
    app="lt://APP1016040991792873567451356",
    device_name="iPhone.*",
    platform_version="26",
    build="8eaa60c5-b92e-4407-89a7-ae97c5e17fc3",
    name="Test Translation Functionality in Bridge2Babble",
    tc_id="TC-10",
    variables={"english_source_language_selected": "true", "spanish_destination_language_selected": "true", "translation_or_readiness_status": "Status: Error: Translation failed. English → Spanish needs a download, and Turn on Apple Intelligence in Settings."},
    global_variables=[{"id": 464885, "name": "spanish_clinic_phrase", "value": "¿Tiene alergias a algún medicamento?", "session_value": "¿Tiene alergias a algún medicamento?", "is_persist": False, "environment_id": 0, "environment_name": "No Env"}],
    default_action_timeout_ms=10000,
)

@testmu_appium.test
def test(driver):
    with testmu_appium.step('Waiting 500 ms on the Bridge2Babble translation screen', instruction_id='4fded7b4-77a6-4bf2-ba92-0b058e89a6a7'):
        testmu_appium.wait(
            driver,
            ms=5,
            description='Waiting 500 ms on the Bridge2Babble translation screen',
        )

    with testmu_appium.step('English is selected as the source language and Spanish is selected as the destination language.', instruction_id='cfc6491e-5999-4c87-85f2-0ffc2841b119'):
        testmu_appium.verify_assertion(driver, tree={'operator': ['equals'], 'assertion_operands': [], 'left_operand': None, 'right_operand': None, 'operands': [], 'sub_results': [{'description': 'English is selected as the source language.', 'passed': True, 'operator': 'equals', 'transforms': [], 'json_path': None, 'expected': 'true', 'extracted_value': '{{english_source_language_selected}}', 'store_key': 'english_source_language_selected', 'variable_refs': {'{{english_source_language_selected}}': 'true'}}, {'description': 'Spanish is selected as the destination language.', 'passed': True, 'operator': 'equals', 'transforms': [], 'json_path': None, 'expected': 'true', 'extracted_value': '{{spanish_destination_language_selected}}', 'store_key': 'spanish_destination_language_selected', 'variable_refs': {'{{spanish_destination_language_selected}}': 'true'}}], 'sub_checks': [{'description': 'English is selected as the source language.', 'store_key': 'english_source_language_selected', 'expected_value': 'true', 'extracted_value': '{{english_source_language_selected}}', 'operator': 'equals', 'transforms': []}, {'description': 'Spanish is selected as the destination language.', 'store_key': 'spanish_destination_language_selected', 'expected_value': 'true', 'extracted_value': '{{spanish_destination_language_selected}}', 'operator': 'equals', 'transforms': []}], 'composite_operator': 'and', 'claim': 'English is selected as the source language and Spanish is selected as the destination language.'}, description='English is selected as the source language and Spanish is selected as the destination language.')

    with testmu_appium.step('Typing in the translation input', instruction_id='39d37745-88ae-4776-843d-ff7e038819d3'):
        testmu_appium.type(
            driver,
            selectors=[
                {"selector": "translateTextField", "score": 80, "isXPath": False, "strategy": "accessibility_id"},
            ],
            description='Typing in the translation input',
            text="Do you have any allergies to medication?",
            clear_first=True,
        )

    with testmu_appium.step('Clicking Translate button', instruction_id='5bf0f619-7214-45a8-b4e5-3c1b33df78e9'):
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
        with testmu_appium.step('Waiting for translation result status to update', instruction_id='aa010bba-717b-4445-b72a-accb702742a6'):
            testmu_appium.wait(
                driver,
                ms=5,
                description='Waiting for translation result status to update',
            )
        testmu_appium.wait(driver, ms=500)
        if testmu_appium.check_until_condition(driver, 'the status line "Error: Translation failed" is visible'):
            _condition_met = True
            break
        _until_retries += 1
    set_var("__result__", {"condition_met": _condition_met, "retries": _until_retries + 1})


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

