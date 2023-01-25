module peass2v

import linpeas_analyzer.LinpeasFindings


struct FINAL_JSON {
mut:
	json map[string][]string = {}
}

struct COLOR_MAP {
	COLORS map[string][]string = {
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
}

struct C_SECTIONS {
mut:
	C_SECTION FINAL_JSON = FINAL_JSON{}
	C_MAIN_SECTION FINAL_JSON = FINAL_JSON{}
	C_2_SECTION FINAL_JSON = FINAL_JSON{}
	C_3_SECTION FINAL_JSON = FINAL_JSON{}
}

struct PATTERNS {
	TITLE1_PATTERN string = "══════════════╣"
	TITLE2_PATTERN string = "╔══════════╣"
	TITLE3_PATTERN string = "══╣"
	INFO_PATTERN string = "╚ "
	TITLE_CHARS string = ['═', '╔', '╣', '╚']
}

fn convert_linpeas_output_file(filename string) {
	// TODO
	println('TODO')
}

fn convert_linpeas_output_str(out_str string) {
	// Constructing the structure
	C_SECTION = FINAL_JSON{}
	C_MAIN_SECTION = FINAL_JSON{}
	C_2_SECTION = FINAL_JSON{}
	C_3_SECTION = FINAL_JSON{}


}

// Returns true if the line contains the pattern, else false
fn is_section(line string, pattern string) bool {
	return line.contains(pattern)
}

fn get_colors(line string) map[string][]string {
	colors := map[string][]string
	return colors
}

//  parses a given line and adds it to the final json struct
fn parse_line(line string) {
	if "Cron jobs" in line:
        a := 1
}

fn main_entry() {
	final_json := FINAL_JSON{}
	color_map := COLOR_MAP{}
	c_sections := C_SECTIONS{}
	patterns := PATTERNS{}

	out_file := os.read_file('linpeas.out') or {
		panic('There was an error reading the linpeas out file')
	}

	lines := out_file.split_into_lines()

	for line in lines {
		mut curr_line := line.strip()
		if curr_line.len == 0 {
			continue
		}

		parse_line(line, final_json, color_map, c_sections, patterns)
	}

	print('i have finished with final json: ${FINAL_JSON}')
}