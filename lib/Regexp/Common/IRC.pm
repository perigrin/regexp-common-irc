package Regexp::Common::IRC;
$VERSION = 0.01;
use strict;
use Regexp::Common qw(pattern clean no_defaults);

# based upon Section 2.3.1 of RFC 2812 (http://www.irchelp.org/irchelp/rfc/rfc2812.txt)
=pod 

=head EBNF for IRC

    target     =  nickname / server
    msgtarget  =  msgto *( "," msgto )
    msgto      =  channel / ( user [ "%" host ] "@" servername )
    msgto      =/ ( user "%" host ) / targetmask
    msgto      =/ nickname / ( nickname "!" user "@" host )
    channel    =  ( "#" / "+" / ( "!" channelid ) / "&" ) chanstring
                  [ ":" chanstring ]
    servername =  hostname
    host       =  hostname / hostaddr
    hostname   =  shortname *( "." shortname )
    shortname  =  ( letter / digit ) *( letter / digit / "-" )
                 *( letter / digit ); as specified in RFC 1123 [HNAME]
    hostaddr   =  ip4addr / ip6addr
    ip4addr    =  1*3digit "." 1*3digit "." 1*3digit "." 1*3digit
    ip6addr    =  1*hexdigit 7( ":" 1*hexdigit ) / "0:0:0:0:0:" ( "0" / "FFFF" ) ":" ip4addr
    
    nickname   =  ( letter / special ) *8( letter / digit / special / "-" )
    targetmask =  ( "$" / "#" ) mask; see details on allowed masks in section 3.3.1
    chanstring =  %x01-07 / %x08-09 / %x0B-0C / %x0E-1F / %x21-2B / %x2D-39 / %x3B-FF
              ; any octet except NUL, BELL, CR, LF, " ", "," and ":"
    channelid  = 5( %x41-5A / digit )   ; 5( A-Z / 0-9 )
    user       =  1*( %x01-09 / %x0B-0C / %x0E-1F / %x21-3F / %x41-FF )
              ; any octet except NUL, CR, LF, " " and "@"
    key        =  1*23( %x01-05 / %x07-08 / %x0C / %x0E-1F / %x21-7F )
              ; any 7-bit US_ASCII character,
              ; except NUL, CR, LF, FF, h/v TABs, and " "
    letter     =  %x41-5A / %x61-7A       ; A-Z / a-z
    digit      =  %x30-39                 ; 0-9
    hexdigit   =  digit / "A" / "B" / "C" / "D" / "E" / "F"
    special    =  %x5B-60 / %x7B-7D
               ; "[", "]", "\", "`", "_", "^", "{", "|", "}"

=cut

my $letter = '[A-Za-z]';
pattern name => [qw(IRC letter -keep)],
	create => qq/(?k:$letter)/,
;

my $special = '[\[\]\\\'\_\^\{\|\}]';
pattern name => [qw(IRC special -keep)],
	create => qq/(?k:$special)/,
;

my $digit = '[0-9]';
pattern name => [qw(IRC digit -keep)],
	create => qq/(?k:$digit)/,
;

my $chanstring = '(?:[^\s,:\a\f\r]){1,29}';
pattern name => [qw(IRC chanstring -keep)],
	create => qq/(?k:$chanstring)/,
;

my $channelid = "(?:[A-Z]|$digit){5}";
pattern name => [qw(IRC channelid -keep)],
	create => qq/(?k:$channelid)/,
;

my $user = '';
my $key = '';


my $hexdigit = "(?:$digit|[A-F])";
pattern name => [qw(IRC hexdigit -keep)],
	create => qq/(?k:$hexdigit)/,
;


my $nick = "(?:$letter|$special)(?:$letter|$digit|$special){0,8}";
pattern name  => [qw(IRC nick -keep)],
	create => qq/(?k:$nick)/, 
; 

my $channel =  "(?:[#+&]|(?:!$channelid)):?$chanstring";
pattern name => [qw(IRC channel -keep)],
	create => qq/(?k:$channel)/,
; 

1;
