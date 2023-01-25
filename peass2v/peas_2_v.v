module peass2v

import linpeas_analyzer.LinpeasFindings


fn convert_linpeas_output_file(filename string) {
	// TODO
	println('TODO')
}

fn convert_linpeas_output_str(out_str string) {
	TITLE1_PATTERN = "══════════════╣"
	TITLE2_PATTERN = "╔══════════╣"
	TITLE3_PATTERN = "══╣"
	INFO_PATTERN = "╚ "
	TITLE_CHARS = ['═', '╔', '╣', '╚']
	COLORS = {
		"REDYELLOW": ['\x1b[1;31;103m'],
		"RED": ['\x1b[1;31m'],
		"GREEN": ['\x1b[1;32m'],
		"YELLOW": ['\x1b[1;33m'],
		"BLUE": ['\x1b[1;34m'],
		"MAGENTA": ['\x1b[1;95m', '\x1b[1;35m'],
		"CYAN": ['\x1b[1;36m', '\x1b[1;96m'],
		"LIGHT_GREY": ['\x1b[1;37m'],
		"DARKGREY": ['\x1b[1;90m'],
	}

	// Final JSON structure
	FINAL_JSON = {}

	// Constructing the structure
	C_SECTION = FINAL_JSON
	C_MAIN_SECTION = FINAL_JSON
	C_2_SECTION = FINAL_JSON
	C_3_SECTION = FINAL_JSON


}

// Returns true if the line contains the pattern, else false
fn is_section(line string, pattern string) bool {
	return line.contains(pattern)
}

fn get_colors(line string) map[string][]string {
	colors := map[string][]string
	return colors
}

fn main_entry() {
	out_file := os.read_file('linpeas.out') or {
		panic('There was an error reading the linpeas out file')
	}

	lines := out_file.split_into_lines()

	for line in lines {
		mut curr_line := line.strip()
		if curr_line.len == 0 {
			continue
		}

		parse_line(line)
	}

	print('i have finished')
}