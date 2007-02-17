use ExtUtils::MakeMaker;

WriteMakefile(
	NAME => "Date::Darian::Mars",
	VERSION_FROM => "lib/Date/Darian/Mars.pm",
	PREREQ_PM => {
		"Math::BigInt" => "1.64",
		"Math::BigRat" => "0.08",
	},
);
