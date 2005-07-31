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

my $digit = '[0-9]';
pattern name => [qw(IRC digit -keep)],
	create => qq/(?k:$digit)/,
;

my $hexdigit = "(?:$digit|[A-F])";
pattern name => [qw(IRC hexdigit -keep)],
	create => qq/(?k:$hexdigit)/,
;

my $special = '[\x{5B}-\x{60}\x{7B}\x{7D}]';
pattern name => [qw(IRC special -keep)],
	create => qq/(?k:$special)/,
;

my $chanstring = '(?:[^\s,:\a\f\r]){1,29}';
pattern name => [qw(IRC chanstring -keep)],
	create => qq/(?k:$chanstring)/,
;

my $channelid = "(?:[A-Z]|$digit){5}";
pattern name => [qw(IRC channelid -keep)],
	create => qq/(?k:$channelid)/,
;

my $user = '(?:[\x{01}-\x{09}\x{0B}-\x{0C}\x{0E}-\x{1F}\x{21}-\x{3F}\x{41}-\x{FF}])?';
pattern name => [qw(IRC user -keep)],
	create => qq/(?k:$user)/,
;

my $key = '(?:[\x{01}-\x{05}\x{07}-\x{08}\x{0C}\x{0E}-\x{1F}\x{21}-\x{7F}]{1,23})';
pattern name => [qw(IRC key -keep)],
	create => qq/(?k:$key)/,
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
