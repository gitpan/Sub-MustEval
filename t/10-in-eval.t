
use Test::More tests => 2;

use Sub::MustEval;


sub foo :MustEval { 1 }
sub a { foo };
sub b { a   };
sub c { b   };
sub d { c   };
sub e { d   };
sub f { e   };
sub g { f   };
sub h { g   };
sub i { h   };

ok eval { foo }, 'Works in eval';
ok eval { i   }, 'Works in nested eval';
