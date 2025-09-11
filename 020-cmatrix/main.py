import os, sys, random, time

cols = os.get_terminal_size().columns
lines = os.get_terminal_size().lines
chars = "abcdefghijklmnopqrstuvwxyz0123456789@#$%^&*()"

try:
    while True:
        x = random.randrange(cols)
        y = random.randrange(lines)
        c = random.choice(chars)
        sys.stdout.write(f"\033[{y};{x}H\033[32m{c}\033[0m")
        sys.stdout.flush()
        time.sleep(0.01)
except KeyboardInterrupt:
    pass
