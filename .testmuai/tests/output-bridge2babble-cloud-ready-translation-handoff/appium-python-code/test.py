import os
import testmu_appium
from testmu_appium import var, set_var

testmu_appium.configure(
    kane_run_v4=True,
    platform="ios",
    app="lt://APP10160332171792877410015558",
    device_name="iPhone.*",
    platform_version="27",
    build="6967cfb2-1c66-4c73-aa1b-89ff018923b7",
    name="Verify English-Spanish Translation in Bridge2Babble",
    tc_id="TC-23",
    variables={"english_source_check": "true", "spanish_destination_check": "true"},
    global_variables=[{"id": 464885, "name": "spanish_clinic_phrase", "value": "¿Tiene alergias a algún medicamento?", "session_value": "¿Tiene alergias a algún medicamento?", "is_persist": False, "environment_id": 0, "environment_name": "No Env"}],
    default_action_timeout_ms=10000,
)

@testmu_appium.test
def test(driver):
    with testmu_appium.step('Clicking Download languages button in the top-right language status row', instruction_id='75c98942-d07c-45b1-9099-09c55779bedf'):
        testmu_appium.click(
            driver,
            selectors=[
                {"selector": "downloadLanguagesButton", "score": 80, "isXPath": False, "strategy": "accessibility_id"},
                {"selector": "Download", "score": 60, "isXPath": False, "strategy": "text"},
            ],
            description='Clicking Download languages button in the top-right language status row',
        )
    _condition_met = False
    _until_retries = 0
    while _until_retries < 10:
        print(f"[until-loop] iteration {_until_retries + 1}/10")
        with testmu_appium.step('PRIMARY: wait for English-to-Spanish offline language package readiness', instruction_id='7d62b2ff-407c-4493-8502-8c969423e5db'):
            testmu_appium.wait(
                driver,
                ms=5,
                description='PRIMARY: wait for English-to-Spanish offline language package readiness',
            )
        testmu_appium.wait(driver, ms=500)
        if testmu_appium.check_until_condition(driver, 'the language status shows English to Spanish is ready offline with Apple Translation'):
            _condition_met = True
            break
        _until_retries += 1
    set_var("__result__", {"condition_met": _condition_met, "retries": _until_retries + 1})

    with testmu_appium.step('Clicking the Download button for languages in the top-right of the status row', instruction_id='bf6c504b-97a0-46ce-820a-c89cc11bff3e'):
        testmu_appium.click(
            driver,
            selectors=[
                {"selector": "downloadLanguagesButton", "score": 80, "isXPath": False, "strategy": "accessibility_id"},
                {"selector": "Download", "score": 60, "isXPath": False, "strategy": "text"},
            ],
            description='Clicking the Download button for languages in the top-right of the status row',
        )

    with testmu_appium.step('Waiting for the English-to-Spanish language download to finish loading', instruction_id='6a0bf872-90b7-4472-8a40-37fd9cf36d68'):
        testmu_appium.wait(
            driver,
            ms=5,
            description='Waiting for the English-to-Spanish language download to finish loading',
        )

    with testmu_appium.step('Waiting for the language download to finish', instruction_id='8aa56a16-c638-47a7-83b2-11358a763a0a'):
        testmu_appium.wait(
            driver,
            ms=5,
            description='Waiting for the language download to finish',
        )
    _condition_met = False
    _until_retries = 0
    while _until_retries < 10:
        print(f"[until-loop] iteration {_until_retries + 1}/10")
        with testmu_appium.step('PRIMARY: wait until the language download status reads "Status: Ready"', instruction_id='e4d564a7-fabf-40b3-a05c-2dd608dfd224'):
            testmu_appium.wait(
                driver,
                ms=5,
                description='PRIMARY: wait until the language download status reads "Status: Ready"',
            )
        testmu_appium.wait(driver, ms=500)
        if testmu_appium.check_until_condition(driver, 'the status label shows "Status: Ready"'):
            _condition_met = True
            break
        _until_retries += 1
    set_var("__result__", {"condition_met": _condition_met, "retries": _until_retries + 1})

    with testmu_appium.step('Waiting ten seconds for the active language package download', instruction_id='a80bd57d-0953-4b7c-a571-048bde9d238e'):
        testmu_appium.wait(
            driver,
            ms=5,
            description='Waiting ten seconds for the active language package download',
        )

    with testmu_appium.step('Waiting for the language direction to be confirmed as English to Spanish', instruction_id='53735208-e573-4971-8a47-fad4fff8591d'):
        testmu_appium.wait(
            driver,
            ms=5,
            description='Waiting for the language direction to be confirmed as English to Spanish',
        )

    with testmu_appium.step('English is the source and Spanish is the destination.', instruction_id='3c8e372e-4252-4f5d-9e69-430fa1973b56'):
        testmu_appium.verify_assertion(driver, tree={'operator': ['equals'], 'assertion_operands': [], 'left_operand': None, 'right_operand': None, 'operands': [], 'sub_results': [{'description': 'English is the source.', 'passed': True, 'operator': 'equals', 'transforms': [], 'json_path': None, 'expected': 'true', 'extracted_value': '{{english_source_check}}', 'store_key': 'english_source_check', 'variable_refs': {'{{english_source_check}}': 'true'}}, {'description': 'Spanish is the destination.', 'passed': True, 'operator': 'equals', 'transforms': [], 'json_path': None, 'expected': 'true', 'extracted_value': '{{spanish_destination_check}}', 'store_key': 'spanish_destination_check', 'variable_refs': {'{{spanish_destination_check}}': 'true'}}], 'sub_checks': [{'description': 'English is the source.', 'store_key': 'english_source_check', 'expected_value': 'true', 'extracted_value': '{{english_source_check}}', 'operator': 'equals', 'transforms': []}, {'description': 'Spanish is the destination.', 'store_key': 'spanish_destination_check', 'expected_value': 'true', 'extracted_value': '{{spanish_destination_check}}', 'operator': 'equals', 'transforms': []}], 'composite_operator': 'and', 'claim': 'English is the source and Spanish is the destination.'}, description='English is the source and Spanish is the destination.')

    with testmu_appium.step('Typing the English translation into the text input', instruction_id='5f94889f-a0d0-4b99-85fb-e5d615e25a6f'):
        testmu_appium.type(
            driver,
            selectors=[
                {"selector": "translateTextField", "score": 80, "isXPath": False, "strategy": "accessibility_id"},
            ],
            description='Typing the English translation into the text input',
            text="Do you have any allergies to medication?",
            clear_first=True,
        )

    with testmu_appium.step('Waiting for the language download while keeping your entered phrase', instruction_id='a5c1d624-62ec-44e9-a05d-669d9aa0952e'):
        testmu_appium.wait(
            driver,
            ms=5,
            description='Waiting for the language download while keeping your entered phrase',
        )

    with testmu_appium.step('Pressing Enter to submit the English translation', instruction_id='c73b4b41-fad6-4491-a377-df0bd926b8ca'):
        testmu_appium.keyevent(
            driver,
            "ENTER",
            description='Pressing Enter to submit the English translation',
        )


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

