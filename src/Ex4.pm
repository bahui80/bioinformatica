use Bio::SeqIO;
use File::Slurp;

if($#ARGV != 0) {
	print "Please provide a genBank file\n";
	exit;
}

# Make the system call to the program getorf to generate the orf file
$systemCallOrf = "getorf -sequence " . $ARGV[0] . " -outseq ../outputs/orfFile.orf";
system($systemCallOrf);

# As patmatmotifs doesn't iterate over the whole orf document, we must iterate
open($fh, "<", "../outputs/orfFile.orf");
$i = 0;
$lineAcum = "";

while($line = <$fh>) {
	if($line =~ m/^>/) {
		if($i != 0) {
			open($fh2,">", "../outputs/auxFile");
			print $fh2 $lineAcum;
			close $fh2;
			$systemCallPatmatmotifs = "patmatmotifs -sequence " . "../outputs/auxFile" . " -outfile ../outputs/report" . $i . ".patmatmotifs";
			system($systemCallPatmatmotifs);
			$lineAcum = "";
		}
		$i++;
	} 
	$lineAcum = $lineAcum . $line;
}

if($lineAcum ne "") {
	open($fh2,">", "../outputs/auxFile");
	print $fh2 $lineAcum;
	close $fh2;
	$systemCallPatmatmotifs = "patmatmotifs -sequence " . "../outputs/auxFile" . " -outfile ../outputs/report" . $i . ".patmatmotifs";
	system($systemCallPatmatmotifs);
	
	open($fh3,">>", "../outputs/report.patmatmotifs");

	for($j = 1; $j <= $i; $j++) {
		$fh3->print(read_file("../outputs/report" . $j . ".patmatmotifs") . "\n");
		unlink "../outputs/report" . $j . ".patmatmotifs";
	}

	close $fh;
	close $fh2;
	close $fh3;
	unlink "../outputs/auxFile";	
}
