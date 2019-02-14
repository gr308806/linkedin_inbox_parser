#!/usr/bin/perl

$file = shift;

open (EMAILS,"$file");

%incoming = {};
%done = {};

sub date_time_string {
   my ($date) = @_;
   my ($m,$d,$Y,$H,$M,$AM) = $date =~ m{^([0-9]{1,2})/([0-9]{1,2})/([0-9]{1,2}); ([0-9]{1,2}):([0-9]{1,2}) ([A-Z]{2})} or die;
   $H+=12 if (($AM eq "PM") && ($H ne "12"));
   $d = "0$d" if (length($d)==1);
   $m = "0$m" if (length($m)==1);
   $Y = "20$Y" if (length($Y)==2);
   $H = "0$H" if (length($H)==1);
   $m = "0$M" if (length($M)==1);
   return "$Y$m$d$H$M";
}

#the following logic is assuming the file is sorted by date with the newest message on top, which is the way it comes out of linkedin
#another assumption is that the incoming messages come before the outgoing messages in the CSV generated by linkedin. this is now true @Feb 12, 2019
while (<EMAILS>) {
        @array = split ",", $_; 
        local $/ = "\r\n";
        chomp ($array[6]);
        #if (($array[5] eq "OUTGOING") && ($array[6] eq "SENT")) {
        if (($array[5] eq "INCOMING") && ($array[6] eq "INBOX")) {
                @names = split ";",$array[0];
                foreach $name (@names) {
			$date = &date_time_string($array[2]);
			if ((!(exists $incoming{$name})) || (${$incoming{$name}}[0] lt $date)) {
				#leaving the date less than condition just in case linkedin ever change the file newest-date-on-top order
				$incoming{$name}=[$date,$array[4]];
			}
				
                }   
        }   
        if (($array[5] eq "OUTGOING") && ($array[6] eq "SENT")) {
                @names = split ";",$array[1];
                foreach $name (@names) {
			$date = &date_time_string($array[2]);
			if (((${$incoming{$name}}[0] lt $date)) || (!(exists $incoming{$name}))) {
				if (!(exists $done{$name})) {
					($date = $array[2]) =~ s/;//;
                        		print "$name,$date,$array[4]\n";
					$done{$name}=1;
				}
			}
                }   
        }   

}

close (EMAILS);

