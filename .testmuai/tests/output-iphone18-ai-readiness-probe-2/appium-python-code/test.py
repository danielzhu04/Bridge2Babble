import os
import testmu_appium
from testmu_appium import var, set_var

testmu_appium.configure(
    kane_run_v4=True,
    platform="ios",
    app="lt://APP1016040991792873567451356",
    device_name="iPhone.*",
    platform_version="27",
    build="a0ae4c37-c210-46e5-9988-73b3a481d909",
    name="Test Apple Translation Readiness in Bridge2Babble",
    tc_id="TC-17",
    variables={"spanish_translation_produced": "false", "apple_intelligence_spanish_translation_absent": "false", "readiness_message": "Status: Error: Translation failed. English → Spanish needs a download, and Apple Intelligence is still downloading."},
    global_variables=[{"id": 464885, "name": "spanish_clinic_phrase", "value": "¿Tiene alergias a algún medicamento?", "session_value": "¿Tiene alergias a algún medicamento?", "is_persist": False, "environment_id": 0, "environment_name": "No Env"}],
    default_action_timeout_ms=10000,
)

@testmu_appium.test
def test(driver):
    with testmu_appium.step('Typing in the English source text field', instruction_id='78ec2798-cc81-4666-9d0c-6c6f65a45ce4'):
        testmu_appium.type(
            driver,
            selectors=[
                {"selector": "translateTextField", "score": 80, "isXPath": False, "strategy": "accessibility_id"},
            ],
            description='Typing in the English source text field',
            text="Do you have any allergies to medication?",
            clear_first=True,
        )

    with testmu_appium.step('Clicking Translate button', instruction_id='0c76755b-7e87-4c86-b986-ea10405e9393'):
        testmu_appium.click(
            driver,
            selectors=[
                {"selector": "translateButton", "score": 80, "isXPath": False, "strategy": "accessibility_id"},
                {"selector": "Translate", "score": 60, "isXPath": False, "strategy": "text"},
            ],
            description='Clicking Translate button',
        )
    if testmu_appium.evaluate_branch(sub_checks=[{"description": "Apple Intelligence does not produce a Spanish translation", "store_key": "apple_intelligence_spanish_translation_absent", "expected_value": "false", "stored_value": "{{apple_intelligence_spanish_translation_absent}}", "operator": "equals", "transforms": []}], composite_operator='and'):
        testmu_appium.execute_kane_cli(driver, objective='record the exact readiness message. Get the exact readiness message and save it as {{readiness_message}}.')
    else:
        testmu_appium.execute_kane_cli(driver, objective='continue without recording a readiness message')


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

