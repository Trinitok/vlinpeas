module peass2v

import os

// import linpeas_analyzer.LinpeasFindings

struct LinpeasScanNode {
mut:
	name string
	sections LinpeasSectionNode
	lines LinpeasLineNode
	infos []string
}

struct LinpeasSectionNode {
mut:
	sub_scan []LinpeasScanNode
}

struct LinpeasLineNode {
mut:
	raw_text string
	colors map[string][]string
	clean_text string
}

struct FINAL_JSON {
mut:
	json map[string][]LinpeasLineNode = {}
}

struct COLOR_MAP {
	colors map[string][]string = {
		"REDYELLOW": [r'\x1b[1;31;103m'],
		"RED": [r'\x1b[1;31m'],
		"GREEN": [r'\x1b[1;32m'],
		"YELLOW": [r'\x1b[1;33m'],
		"BLUE": [r'\x1b[1;34m'],
		"MAGENTA": [r'\x1b[1;95m', r'\x1b[1;35m'],
		"CYAN": [r'\x1b[1;36m', r'\x1b[1;96m'],
		"LIGHT_GREY": [r'\x1b[1;37m'],
		"DARKGREY": [r'\x1b[1;90m'],
	}
}

struct C_SECTIONS {
mut:
	c_section LinpeasScanNode = LinpeasScanNode{}
	c_main_section LinpeasScanNode = LinpeasScanNode{}
	c_2_section LinpeasScanNode = LinpeasScanNode{}
	c_3_section LinpeasScanNode = LinpeasScanNode{}
}

struct PATTERNS {
	title1_pattern string = "══════════════╣"
	title2_pattern string = "╔══════════╣"
	title3_pattern string = "══╣"
	info_pattern string = "╚ "
	title_chars []string = ['═', '╔', '╣', '╚']
}

// Returns true if the line contains the pattern, else false
fn is_section(line string, pattern string) bool {
	return line.contains(pattern)
}

// Given a line return the colored strings
fn get_colors(line string, patterns PATTERNS, color_map COLOR_MAP ) map[string][]string {
    mut colors := map[string][]string{}
	color_map_vals := color_map.colors.values()
	for i := 0; i < color_map_vals.len; i ++ {
		// println('color map vals: ${color_map_vals}')
		// current_regex := color_map_vals[i]

		// colors[current_regex] = []string{}

		// for j := 0; j < current_regex.len; j ++ {
		// 	reg := current_regex[j]
		// 	mut split_color := line.split(reg)

		// 	if split_color.len > 1 {
		// 		split_color = split_color[1..]

		// 		for k := 0; k < split_color.len; k ++ {
		// 			potential_color_str := split_color[k]
		// 		}
		// 	}
		// }

		// println('current color regex: ${current_regex}')
	}
    // for c,regexs in color_map.colors.values() {
    //     colors[regexs] = []string{}
    //     for reg in regexs {
    //         mut split_color := line.split(reg)
            
            // Start from the index 1 as the index 0 isn't colored
        //     if split_color && len(split_color) > 1 {
        //         split_color = split_color[1..]
                
        //         // For each potential color, find the string before any possible color terminatio
        //         for potential_color_str in split_color {
        //             mut color_str1 := potential_color_str.split('\x1b')[0]
        //             mut color_str2 := potential_color_str.split(r"\[0")[0]
        //             mut color_str := color_str1  // if len(color_str1) < len(color_str2) else color_str2
		// 			if color_str1.len >= color_str2.len {
		// 				color_str = color_str2
		// 			}

        //             if color_str.len > 0 {
		// 				stripped_color_str := color_str.replace('\n',"")
        //                 color_str = clean_colors(stripped_color_str)
        //                 // Avoid having the same color for the same string
        //                 if color_str { // && !any(color_str in values for values in colors.values()) {
        //                     colors[c].append(color_str)
		// 				}
		// 			}
		// 		}
		// 	}
		// }
        
        // if !colors[c] {
        //     del colors[c]
		// }
	// }
    
    return colors
}

// Given a title clean it
fn clean_title(line string, patterns PATTERNS) string {
	mut no_pattern := line
    for i := 0; i < patterns.title_chars.len; i ++ {
		curr_pattern := patterns.title_chars[i]
        no_pattern = no_pattern.replace(curr_pattern,"")
	}

	// line = line.replace(patterns.title_chars[0],"")
    
	mut ascii_only := ''

	for i := 0; i < line.len; i ++ {
		curr_char := line[i].ascii_str()
		if curr_char.is_ascii() {
			ascii_only = ascii_only + curr_char
		}
	}

    // line = line.encode("ascii", "ignore").decode() // Remove non ascii chars
    line_no_newlines := ascii_only.trim_space()

	// println('clean title ret line: ${line_no_newlines}')
    return line_no_newlines
}

// Given a line clean the colors inside of it
fn clean_colors(line string) string {

	mut tested_str := ''

	for i := 0; i < line.len; i ++ {
		curr_char := line[i].ascii_str()
		if curr_char.is_ascii() {
			tested_str = tested_str + curr_char
		}
	}

	// println('here is the cleaned test_str: ${tested_str}')

	replaced_non_alpha := tested_str.replace(r'\x1b\[[^a-zA-Z]+\dm', "")
    
    line_no_bytes := replaced_non_alpha.replace('\x1b',"").replace("[0m", "").replace("[3m", "") // Sometimes that byte stays
    line_no_newlines := line_no_bytes.trim_space()
    return line_no_newlines
}

// Given a title, clean it
fn parse_title(line string, pattern PATTERNS) string {
    return clean_colors(clean_title(line, pattern))
}

//  parses a given line and adds it to the final json struct
fn parse_line(line string, final_json FINAL_JSON, color_map COLOR_MAP, mut c_sections C_SECTIONS, patterns PATTERNS) {
	if line.contains("Cron jobs") {
        a := 1
	}

	if is_section(line, patterns.title1_pattern) {
        println('title line: ${line}')
		
		title := parse_title(line, patterns)
		println('parsed title title_line: ${title}')
		
        c_sections.c_main_section = LinpeasScanNode {
			name: title 
			sections: LinpeasSectionNode{}, 
			lines: LinpeasLineNode{}, 
			infos: [] 
		}
        c_sections.c_section = c_sections.c_main_section
	}
	else if is_section(line, patterns.title2_pattern) {
        println('title 2 line: ${line}')
		
		title := parse_title(line, patterns)
		println('parsed title2 title_line: ${title}')
        
		// c_sections.c_main_section.sections = LinpeasScanNode { 
		// 	name: title
		// 	sections: {}, 
		// 	lines: [], 
		// 	infos: [] 
		// }
		println('here is c_sections.c_main_section: ${c_sections.c_main_section}')
		println('here is c_sections.c_2_section: ${c_sections.c_2_section}')
		println('here is c_sections.c_section: ${c_sections.c_section}')
        // c_sections.c_2_section = c_sections.c_main_section.sections
        // c_sections.c_section = c_sections.c_2_section
	}
	else if is_section(line, patterns.title3_pattern) {
        println('title 3 line: ${line}')
		
		title := parse_title(line, patterns)
		println('parsed title3 title_line: ${title}')
		mut sections_arr := []LinpeasScanNode{}
		// sections_arr << 
        c_sections.c_2_section.sections = LinpeasSectionNode{
			sub_scan: sections_arr
		}
        c_sections.c_3_section.sections = c_sections.c_2_section.sections
        c_sections.c_section = c_sections.c_3_section
	}

    else if is_section(line, patterns.info_pattern) {
        title := parse_title(line, patterns)

        c_sections.c_section.infos << title
	}
    
    // If here, then it's text
    else {
        // If no main section parsed yet, pass
        if c_sections.c_section == LinpeasScanNode{} {
            return
		}

        c_sections.c_section.lines = LinpeasLineNode {
            raw_text: clean_title(clean_colors(line), patterns),
            colors: get_colors(line, patterns, color_map),
            clean_text: line
        }
	}
}

pub fn main_entry() {
	final_json := FINAL_JSON{}
	color_map := COLOR_MAP{}
	mut c_sections := C_SECTIONS{}
	patterns := PATTERNS{}

	out_file := os.read_file('test_linpeas.out') or {
		panic('There was an error reading the linpeas out file')
	}

	mut lines := out_file.split_into_lines()

	// println(lines)

	for line in lines {
		mut curr_line := line.trim_space()
		if curr_line.len == 0 {
			continue
		}

		parse_line(line, final_json, color_map, mut c_sections, patterns)
	}

	print('i have finished with final c_section: ${c_sections}')
}
