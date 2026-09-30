#!/usr/bin/perl
# Rewrites the slide table between <!-- slides:start/end --> in README.md from
# slides/slide-<n>.svg (one per PDF page, from `typst compile ... {p}.svg`).
# Exits non-zero if the slides or the markers are missing, so CI fails loudly.
use strict;
use warnings;
use FindBin;
chdir "$FindBin::Bin/../.." or die "chdir: $!";

opendir my $dh, 'slides' or die "update-readme: no slides/ dir\n";
my @pages = sort { $a <=> $b } map { /slide-(\d+)\.svg$/ ? $1 : () } readdir $dh;
@pages or die "update-readme: no slides/slide-*.svg found\n";

my $table = '| Slides (' . @pages . ") |\n| --- |\n"
    . join '', map { "| ![Slide $_](slides/slide-$_.svg) |\n" } @pages;

local $/;
open my $in, '<', 'README.md' or die $!;
my $text = <$in>;
my ($pre, $post) = $text =~ /\A(.*?<!-- slides:start -->\n).*?(<!-- slides:end -->.*)\z/s
    or die "update-readme: markers missing from README.md\n";
my $new = $pre . $table . $post;

if ($new eq $text) {
    print 'update-readme: README already up to date (', scalar(@pages), " slides)\n";
} else {
    open my $out, '>', 'README.md' or die $!;
    print {$out} $new;
    print 'update-readme: README updated with ', scalar(@pages), " slides\n";
}
