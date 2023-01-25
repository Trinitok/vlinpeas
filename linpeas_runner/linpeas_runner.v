module linpeas_runner

import linpeas_analyzer.LinpeasFindings
import os

//  will run linpeas and output to a file.
fn run_linpeas() {
	
}

//  Will run linpeas and send the output to a file.
//  Will then try and parse the output into a LinpeasFindings struct
fn run_and_parse_linpeas() LinpeasFindings {
	os.execute_or_panic('curl -L https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh | sh > linpeas.out')
	return LinpeasFindings{}
}