use Test::More tests => 1 + 3*14 + 3 + 6*9 + 9;

BEGIN {
	use_ok "Date::Darian::Mars",
		qw(year_days cmsdn_to_yd yd_to_cmsdn present_yd);
}

use Math::BigInt 1.16;
use Math::BigRat 0.04;

sub match_val($$) {
	my($a, $b) = @_;
	ok ref($a) eq ref($b) && $a == $b;
}

sub match_vec($$) {
	my($a, $b) = @_;
	unless(@$a == @$b) {
		ok 0;
		return;
	}
	for(my $i = 0; $i != @$a; $i++) {
		my $aval = $a->[$i];
		my $bval = $b->[$i];
		unless(ref($aval) eq ref($bval) && $aval == $bval) {
			ok 0;
			return;
		}
	}
	ok 1;
}

my @prep = (
	sub { $_[0] },
	sub { Math::BigInt->new($_[0]) },
	sub { Math::BigRat->new($_[0]) },
);

sub check_days($$) {
	my($y, $yd) = @_;
	foreach my $prep (@prep) {
		match_val year_days($prep->($y)), $yd;
	}
}

check_days(-2000, 669);
check_days(-1999, 669);
check_days(-1998, 668);
check_days(-1997, 669);
check_days(-1996, 668);
check_days(-1990, 669);
check_days(-1900, 668);
check_days(2000, 669);
check_days(2001, 669);
check_days(2002, 668);
check_days(2003, 669);
check_days(2004, 668);
check_days(2010, 669);
check_days(2100, 668);

eval { yd_to_cmsdn(500, 0); };
like $@, qr/\Aday number /;
eval { yd_to_cmsdn(500, 670); };
like $@, qr/\Aday number /;
eval { yd_to_cmsdn(502, 669); };
like $@, qr/\Aday number /;

sub check_conv($$$) {
	my($cmsdn, $y, $d) = @_;
	foreach my $prep (@prep) {
		match_vec [cmsdn_to_yd($prep->($cmsdn))], [$prep->($y), $d];
		match_vec [$prep->($cmsdn)], [yd_to_cmsdn($prep->($y), $d)];
	}
}

check_conv(0, -608, 633);
check_conv(405871, 0, 1);
check_conv(546236, 209, 631);
check_conv(546943, 210, 669);
check_conv(546944, 211, 1);
check_conv(547612, 211, 669);
check_conv(547613, 212, 1);
check_conv(548280, 212, 668);
check_conv(548281, 213, 1);

is present_yd(546236), "0209-631";
is present_yd(209, 631), "0209-631";
is present_yd(548281), "0213-001";
is present_yd(213, 1), "0213-001";

is present_yd(1233, 0), "1233-000";
is present_yd(1233, 670), "1233-670";
is present_yd(1233, 999), "1233-999";
eval { present_yd(1233, -1) }; isnt $@, "";
eval { present_yd(1233, 1000) }; isnt $@, "";
