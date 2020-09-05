#vi:filetype=perl

use lib 'lib';
use Test::Nginx::Socket;

log_level('error');

repeat_each(1);

plan tests => repeat_each(1) * blocks();
no_root_location();
no_long_string();
$ENV{TEST_NGINX_SERVROOT} = server_root();
run_tests();


__DATA__
=== TEST 1: JSON log quote escape
--- main_config
load_module /tmp/naxsi_ut/modules/ngx_http_naxsi_module.so;
--- http_config
include /tmp/naxsi_ut/naxsi_core.rules;
--- config
set $naxsi_json_log 1;
location / {
     SecRulesEnabled;
     DeniedUrl "/RequestDenied";
     CheckRule "$SQL >= 8" BLOCK;
     CheckRule "$RFI >= 8" BLOCK;
     CheckRule "$TRAVERSAL >= 4" BLOCK;
     CheckRule "$XSS >= 8" BLOCK;
     root $TEST_NGINX_SERVROOT/html/;
         index index.html index.htm;
}
location /RequestDenied {
     return 412;
    # return 412;
}
--- request eval
"GET /\"a?b=<>\\"
--- error_code: 412
--- error_log eval
qr@"uri"\:"\/\\"a"@
=== TEST 1.1: JSON log backslash escape
--- main_config
load_module /tmp/naxsi_ut/modules/ngx_http_naxsi_module.so;
--- http_config
include /tmp/naxsi_ut/naxsi_core.rules;
--- config
set $naxsi_json_log 1;
location / {
     SecRulesEnabled;
     DeniedUrl "/RequestDenied";
     CheckRule "$SQL >= 8" BLOCK;
     CheckRule "$RFI >= 8" BLOCK;
     CheckRule "$TRAVERSAL >= 4" BLOCK;
     CheckRule "$XSS >= 8" BLOCK;
     root $TEST_NGINX_SERVROOT/html/;
         index index.html index.htm;
}
location /RequestDenied {
     return 412;
    # return 412;
}
--- request eval
"GET /\\\\a?b=<>\\"
--- error_code: 412
--- error_log eval
qr@"uri"\:"\/\\\\a"@
=== TEST 1.2: JSON log backslash and quote escape
--- main_config
load_module /tmp/naxsi_ut/modules/ngx_http_naxsi_module.so;
--- http_config
include /tmp/naxsi_ut/naxsi_core.rules;
--- config
set $naxsi_json_log 1;
location / {
     SecRulesEnabled;
     DeniedUrl "/RequestDenied";
     CheckRule "$SQL >= 8" BLOCK;
     CheckRule "$RFI >= 8" BLOCK;
     CheckRule "$TRAVERSAL >= 4" BLOCK;
     CheckRule "$XSS >= 8" BLOCK;
     root $TEST_NGINX_SERVROOT/html/;
         index index.html index.htm;
}
location /RequestDenied {
     return 412;
    # return 412;
}
--- request eval
"GET /\"\\a?b=<>\\"
--- error_code: 412
--- error_log eval
qr@"uri"\:"\/\\"\\\\a"@


