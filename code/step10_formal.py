from pathlib import Path

from gate_sat import Model, replay, show

known = [
    b"(* TWO STARS *)\0",
    b"BIG BANG\0",
    b"EMPTY SKY\0",
    b"TRY AGAIN\0",
]
model = Model(9)
results = []

for message in known:
    constraints = model.is_byte(model.outputs[0], message[0])
    constraints += model.differs(model.outputs[1:], message[1:9])
    found = []

    while solution := model.formula.solve(constraints):
        sequence = model.sequence(solution)
        prefix = bytes(model.byte(solution, byte) for byte in model.outputs)
        found.append([sequence, prefix])
        constraints += model.differs(model.outputs[1:], prefix[1:])
    results.append((message, found))

sequences = [sequence for _, found in results for sequence, _ in found]
messages = iter(replay(sequences))

lines = []
for known_message, found in results:
    lines += [f"0x{known_message[0]:02x} {chr(known_message[0])}",
              f"known  {show(known_message)}"]
    for sequence, _ in found:
        lines += [f"input  {sequence}", f"new    {show(next(messages))}"]
    lines += ["remaining UNSAT", ""]

result = "\n".join(lines)
Path("output/step10.txt").write_text(result)
print(result, end="")
