# test_semgrep.py
import os

# -----------------------------
# Safe code
# -----------------------------
def greet(name):
    print(f"Hello, {name}!")

# -----------------------------
# Insecure code (Semgrep should catch this)
# -----------------------------
def get_secret():
    # Hard-coded password - Semgrep will detect this as a secret
    password = "SuperSecret123!"
    return password

def execute_user_input():
    user_input = "print('hello')"
    eval(user_input)  # Semgrep can detect unsafe eval usage
