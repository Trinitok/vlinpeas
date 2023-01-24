module tests

import linpeas_analyzer

fn test_parse_and_crit_findings() {
	linpeas_out_file := 'linpeas.json'
	
	linpeas_out := linpeas_analyzer.decode_linpeas_json(linpeas_out_file)
	crit_findings := linpeas_out.retrieve_critical_findings()
	
	println('here are the critical linpeas findings: ${crit_findings}')
}