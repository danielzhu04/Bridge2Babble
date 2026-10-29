import os
import testmu_appium
from testmu_appium import var, set_var

testmu_appium.configure(
    kane_run_v4=True,
    platform="ios",
    app="lt://APP10160332171792877410015558",
    device_name="iPhone.*",
    platform_version="18",
    build="7bac8367-93f6-4396-84ab-b2ebdb3cb995",
    name="Verify Offline Translation and Handoff Functionality",
    tc_id="TC-25",
    variables={"language_readiness_label_ready_offline": "Status: Ready", "readiness_message": "Status: Ready"},
    global_variables=[{"id": 464885, "name": "spanish_clinic_phrase", "value": "¿Tiene alergias a algún medicamento?", "session_value": "¿Tiene alergias a algún medicamento?", "is_persist": False, "environment_id": 0, "environment_name": "No Env"}],
    default_action_timeout_ms=10000,
)

@testmu_appium.test
def test(driver):
    if testmu_appium.evaluate_branch(sub_checks=[{"description": "the exact language readiness label says ‘Ready offline · Apple Translation’", "store_key": "language_readiness_label_ready_offline", "expected_value": "Ready offline · Apple Translation", "stored_value": "{{language_readiness_label_ready_offline}}", "operator": "equals", "transforms": ["strip"]}], composite_operator='and'):
        testmu_appium.execute_kane_cli(driver, objective='do not tap any Download control or language preparation control: enter the synthetic phrase, tap Translate, verify the conversation shows the original phrase and a Spanish translation preserving the medication-allergy meaning, then open Handoff and verify the bilingual turn plus the machine-translated and unverified safety notice.')
    else:
        testmu_appium.execute_kane_cli(driver, objective='Get the exact language readiness label and save as {{readiness_message}}. do not tap Download, do not attempt translation, and report this as an environment-readiness result.')


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

