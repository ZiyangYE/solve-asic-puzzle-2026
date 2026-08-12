from pathlib import Path

from gate_sat import Model, replay, show

model = Model(1)
blocked = []
found = []

while solution := model.formula.solve(blocked):
    character = model.byte(solution, model.outputs[0])
    found.append((character, model.sequence(solution)))
    blocked += model.differs(model.outputs, bytes([character]))

messages = replay([sequence for _, sequence in found])
found = sorted((*item, message) for item, message in zip(found, messages))

lines = [
    "first bytes: " + " ".join(f"{character:02x}" for character, _, _ in found),
    "complete: UNSAT",
    "",
]
for character, sequence, message in found:
    lines += [
        f"0x{character:02x} {chr(character)}",
        f"input  {sequence}",
        f"output {show(message)}",
        "",
    ]

result = "\n".join(lines)
Path("output/step9.txt").write_text(result)
print(result, end="")
