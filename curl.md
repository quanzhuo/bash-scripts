# frequency used curl options
* -u, --user <user:password>  
Specify the user name and password to use for server authentication. Overrides -n, --netrc and --netrc-optional.
 
* --noproxy <no-proxy-list>  
Comma-separated list of hosts which do not use a proxy, if one is specified. The only wildcard is a single * character, which matches all hosts, and effectively disables the proxy.

* --url <URL\>  
Specify a URL to fetch. This option is mostly handy when you want to specify URL(s) in a config file. 	

* -d, --data <data\>  
(HTTP) Sends the specified data in a POST request to the HTTP server.

* -c, --cookie-jar <file name\>  
(HTTP) Specify to which file you want curl to write all cookies after a completed operation.	

* -b, --cookie <name=data\>  
(HTTP) Pass the data to the HTTP server as a cookie.	

* --anyauth  
(HTTP) Tells curl to figure out authentication method by itself, and use the most secure one the remote site claims to support.	

* -A, --user-agent <agent string\>  
(HTTP) Specify the User-Agent string to send to the HTTP server.	

* -F, --form <name=content\>  
(HTTP) This lets curl emulate a filled-in form in which a user has pressed the submit button.	
	
* -H, --header <header\>  
(HTTP) Extra header to include in the request when sending HTTP to a server.
	
* -K, --config <config file\>  
Specify which config file to read curl arguments from. The config file is a	text file in which command line arguments can be written which then will be used as if they were written on the actual command line. 	
	
* -o, --output <file\>  
Write output to <file\> instead of stdout.	
	
* --retry <num\>  
If a transient error is returned when curl tries to perform a transfer, it will retry this number of times before giving up.
	
* -s, --silent  
Silent or quiet mode. Don't show progress meter or error messages. Makes Curl mute. It will still output the data you ask for, potentially even to the terminal/stdout unless you redirect it. 	

* -D, --dump-header <file\>  
Write the protocol headers to the specified file. 
	
* -v, --verbose  
Be more verbose/talkative during the operation. Useful for debugging and seeing what's going on "under the hood". A line starting with '>' means "header data" sent by curl, '<' means "header data" received by curl that	is hidden in normal cases, and a line starting with '*' means additional info provided by curl. 	
	
* -i, --include  
(HTTP) Include the HTTP-header in the output. The HTTP-header includes things like server-name.		

* --trace <file\>  
Enables a full trace dump of all incoming and outgoing data, including descriptive information, to the given output file. Use "-" as filename to have the output sent to stdout. 	
