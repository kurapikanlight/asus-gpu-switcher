var GPU_MODES = [
    { name: "Integrated", dgpu: "1", mux: "1" },
    { name: "Hybrid", dgpu: "0", mux: "1" },
    { name: "NVIDIA", dgpu: "0", mux: "0" }
];

function currentValue(output, controlName) {
    var lines = output.split("\n");
    var insideControl = false;

    for (var i = 0; i < lines.length; i++) {
        var line = lines[i];

        if (line.trim() === controlName + ":") {
            insideControl = true;
            continue;
        }

        if (
            insideControl &&
            line.trim().endsWith(":") &&
            !line.includes("current:")
        ) {
            insideControl = false;
        }

        if (insideControl) {
            var match = line.match(/current:\s*.*\(([-]?\d+)\)/);
            if (match)
                return parseInt(match[1]);

            var bracketMatch = line.match(/current:\s*.*\[([-]?\d+)\]/);
            if (bracketMatch)
                return parseInt(bracketMatch[1]);
        }
    }

    return null;
}

function detectMode(output) {
    var dgpu = currentValue(output, "dgpu_disable");
    var mux = currentValue(output, "gpu_mux_mode");

    if (dgpu === 1 && mux === 1)
        return "Integrated";

    if (dgpu === 0 && mux === 1)
        return "Hybrid";

    if (dgpu === 0 && mux === 0)
        return "NVIDIA";

    return "Unknown";
}

function mode(name) {
    for (var i = 0; i < GPU_MODES.length; i++) {
        if (GPU_MODES[i].name === name)
            return GPU_MODES[i];
    }

    return null;
}