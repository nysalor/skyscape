skyscape
======================
search your local Skype log.

requirement
------
ruby 1.9.x

usage
------
bundle install

bin/skyscape -s -f ~/Library/Application\ Support/Skype/user_name/main.db target_word

option
------
-t output by simple text format.  
(without this option, output XML format messages.)

-f specify Skype database file. (main.db)

-s start date. (YYYY-MM-DD or YYYY-MM-DD-hh-mm-dd)

-e end date. (see above)

-n specify user name. (hundle)

example
------
bin/skyscape -s 2012-03-25-12-00-00 -t -f ~/Library/Application\ Support/Skype/jun/main.db Matz

License
----------
Copyright &copy; 2012 Jun Yokoyama (@nysalor)

Licensed under the Apache License, Version 2.0
