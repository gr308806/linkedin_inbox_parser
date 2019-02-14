# linkedin_inbox_parser
Finding which messages in my Linkedin inbox need a follow up (i.e. were not answered)


# How to run parse_linkedin_messages.pl script
1. Install perl on your system (if not already installed).
2. Log on to linkedin.com and under account->settings&privacy find an option called: "Download your data" select connections and messages and click Request-Archive. After a few minutes you will get an email from linkedin with a download link. After you downloaded it you will get 2 .csv files.
3. Open both .csv files with Excel and do a global search in replace (in excel) to search for "," and substitute it with ";".
4. save the files after the global substitutions.
Now you're ready to run the script:
from a prompt type:
./parse_linkedin_messages.pl "Path to Messages.csv" > ./follow_up_messages.csv

This will create a file called follow_up_messages.csv in your local directory. It will contain the messages you last sent to someone but never got a reply for. This can be used by you to know which messages to follow up on if needed.

Enjoy and feel free to add features and correct bugs in the scripts
