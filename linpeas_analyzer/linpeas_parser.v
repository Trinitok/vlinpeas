module linpeas_analyzer

import os
import x.json2

struct LinpeasFindings {
	scans []LinpeasScanNode
}

struct LinpeasScanNode {
	name string
	sections LinpeasSectionNode
	lines LinpeasLineNode
	infos []string
}

struct LinpeasSectionNode {
	sub_scan []LinpeasScanNode
}

struct LinpeasLineNode {
	colors map[string][]string
	clean_text string
}

// fn init() {
// 	println('probably want to install this here')
// 	os.execute_or_panic('curl -L https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh | sh > linpeas.out')
// }

pub fn decode_linpeas_json(filename string) LinpeasFindings {
	buf := os.read_file(filename) or {
		println('error reading linpeas.json file')
		panic(err)
	}

	test_out := json2.raw_decode(buf) or {
		println('issue trying to decode linpeas.json file')
		unsafe { buf.free() }
		panic(err)
	}
	unsafe { buf.free() }
	product := test_out.as_map()
	data := product as map[string]json2.Any
	linpeas_out := parse_scan_nodes(data)
	
	return LinpeasFindings {
		scans: linpeas_out
	}
}

fn parse_json_str_to_map(json_str string) map[string]json2.Any {
	test_basic_info_values := json2.raw_decode(json_str) or {
		println('error trying to decode values for json string: ${json_str}')
		panic(err)
	}
	product_sections := test_basic_info_values.as_map()
	data_sections := product_sections as map[string]json2.Any

	return data_sections
}

fn parse_scan_nodes(scan_node map[string]json2.Any) []LinpeasScanNode {
	mut ret_arr := []LinpeasScanNode {}
	for scan_key in scan_node.keys() {
		// convert to json str
		scan_children_str := scan_node[scan_key].str()
		mapped_scan_node_children := parse_json_str_to_map(scan_children_str)
		new_scan_node := LinpeasScanNode {
			name: scan_key
			sections: process_sections(mapped_scan_node_children['sections'])
			lines: process_lines(mapped_scan_node_children['lines'])
			infos: process_infos(mapped_scan_node_children['infos'])
		}
		ret_arr << new_scan_node
	}

	return ret_arr
}

fn process_sections(scan_section json2.Any) LinpeasSectionNode {
	mapped_section_json := scan_section.as_map()
	if mapped_section_json.len == 0 {
		return LinpeasSectionNode {}
	}
	else {
		return LinpeasSectionNode {
			sub_scan: parse_scan_nodes(mapped_section_json)
		}
	}
}

fn process_lines_colors(mapped_value_colors map[string]json2.Any) map[string][]string {
	mut ret_map := map[string][]string
	//  for each string key in the colors take the color map key, then for the array loop over that and convert each value to string
	for key in mapped_value_colors.keys() {
		colors_arr := mapped_value_colors[key].arr()
		mut transformed_colors_arr := []string
		//  loop over each json2.Any value and convert each individually to string
		for i := 0; i <  colors_arr.len; i ++ {
			orig_item := colors_arr[i]
			transformed_colors_arr << orig_item.str()
		}
		ret_map[key] << transformed_colors_arr
	}

	return ret_map
}

fn process_lines(scan_lines json2.Any) LinpeasLineNode {
	lines := scan_lines.as_map()
	mut ret_map := map[string][]string
	mut ret_clean_text := ''
	//  reeeee super inefficient
	//  for each value in lines
	for value in lines.values() {
		//  []json2.Any cannot convert to []string so I have to go over every array and every value in the array and convert them to an array of strings
		mapped_values := value.as_map()
		mapped_value_colors := mapped_values['colors'].as_map()
		ret_clean_text = mapped_values['clean_text'].str()
		//  get the colors
		ret_map = process_lines_colors(mapped_value_colors)
	}
	return LinpeasLineNode {
		colors: ret_map
		clean_text: ret_clean_text
	}
}

fn process_infos(scan_infos json2.Any) [] string {
	scan_infos_arr := scan_infos.arr()
	mut ret_arr := []string
	for value in scan_infos_arr {
		ret_arr << scan_infos_arr.str()
	}
	return ret_arr
}