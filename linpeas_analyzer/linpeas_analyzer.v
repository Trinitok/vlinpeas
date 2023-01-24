module linpeas_analyzer

struct LinpeasRetrievedFindings {
	name string
	clean_text string
	findings []string
}

//  Retrieve all the text from linpeas findings that were 
//   marked as redyellow output in the terminal
pub fn (linpeas_findings LinpeasFindings) retrieve_critical_findings() []LinpeasRetrievedFindings {
	scans := linpeas_findings.scans
	crit_findings := 
		retrieve_linpeas_finding_lines_with_color('REDYELLOW', scans)
	return crit_findings
}

//  Retrieve all lines of text from linpeas findings that match the color_id passed.
//    Must match a valid color from Linpeas
pub fn (linpeas_findings LinpeasFindings) retrieve_findings_with_color_id(color_id string) []LinpeasRetrievedFindings {
	scans := linpeas_findings.scans
	crit_findings := 
		retrieve_linpeas_finding_lines_with_color(color_id, scans)
	return crit_findings
}

// Uses depth first search in order to obtain all the color_name texts from LinpeasLinesNode
fn retrieve_linpeas_finding_lines_with_color(color_name string, scan_nodes []LinpeasScanNode) []LinpeasRetrievedFindings {
	mut ret_arr := []LinpeasRetrievedFindings
	for scan in scan_nodes {
		sections := scan.sections
		if sections.sub_scan.len > 0 {
			ret_arr << retrieve_linpeas_finding_lines_with_color(color_name, sections.sub_scan)
		}
		lines := scan.lines
		if color_name in lines.colors.keys() {
			ret_arr << LinpeasRetrievedFindings {
				name: scan.name
				clean_text: lines.clean_text
				findings: lines.colors[color_name]
			}
		}
	}

	return ret_arr
}