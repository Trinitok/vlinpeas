# What is this?
This is a wrapper for linpeas json files.  The intent of which is to allow for more programability for linpeas output.

I am primarily developing in a linux environment.  So it might not work quite as well for Windows based environments

# Technical Limitations
## Winpeas Uncertainty
I can confirm this will work in both MacOS and Linux using macpeas and linpeas respectively

I am uncertain how effective this will be with winpeas.  I use nix environments at home so I do not know how well this will work when running winpeas and parsing its output. Theoretically it should work as I am only parsing the output unless there is something with the underlying implementation of V right now that makes it difficult to run on Windows.

## JSON Parsing Capabilities
The current V documentation organizes json as structs where each field in a struct is the json key.  

The issue with this is that I will need to explicitly declare every JSON field name.  That can be a long and tedious process, especially when something follows a defined structure in JSON.

The linpeas JSON output seems to follow the following structure:
```
{
    'Scan1': {
        sections: {

        },
        lines: [
            {

            },
        ],
        'infos': []
    },
    'Scan2': {
        sections: {
            'Scan': {
                sections: {},
                lines: [],
                infos: [
                    'string'
                ]
            }
        },
        lines: [
            {
                'raw_text': 'raw text with shell color encoding text',
                'colors': {
                    'DETECTED_COLOR': [
                        'optional text in dark grey, blue, green, redyellow,red.  This will not be here if there is nothing detected',
                    ],
                },
                'clean_text': 'text without shell encoding text'
            },
        ],
        'infos': [
            'URL string'
        ]
    },
}
```

So all in all, it is not the most complex structure.  It is very repetative.  The issue though is that the Scan key will have a different name every time.

There is currently an experimental json library in the core vlib (json2) but it is experimental and is prone to error.

Honestly knowing how V works and how the structure of a JSON file for linpeas is set up, I really probably should just use the abstract syntax tree.  But that would require learning.  Gross.

I also had a shower thought that really all it could be is a map[string]map[string][]string where
1. The first map is the section name
1. The second map is the color
1. The strings array are all the findings of the color
The only problem with this shower thought is if the scan format changes, it isn't exactly the most extensible for other formats.

# Install
1. vpm
> v install trinitok.vlinpeas

# Use
## Prerequisite
1. Run linpeas and send the output to a file
    1. https://github.com/carlospolop/PEASS-ng
1. Use the `peass2json.py` program to turn linpeas into json
## Usage
```
import trinitok.vlinpeas

peass2json_output := 'path_to_peass2json.py_output.text'

// Parse the output
linpeas_out := linpeas_analyzer.decode_linpeas_json(peass2json_output)

// Retrieve all REDYELLOW text (95% PE vectors)
crit_findings := linpeas_out.retrieve_critical_findings()

// Retrieve all BLUE text (because why not?)
blue_findings := linpeas_out.
```
# Testing
You can definitely try running the tests.  They will fail because I did not include a local file from the linpeas output.  You will likely want to add a peass2json output file and change the name in the `analyzer_test.v`

# TODO
1. Return more than just the first instance of the linpeas keywords
1. Rewrite the peass2json in V
1. Allow for more ways to analyze output of lin/mac/win-peas
1. Optimize parser to not be so jank (slightly dependent on V making advancements on json parsing)