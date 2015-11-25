use Bio::SeqIO;
use Bio::Perl;

if($#ARGV == -1) {
	print "Please provide one or more fasta files\n";
	exit;
}

$i = 0;
$numArgs = $#ARGV + 1;
@inputFiles;

while($i != $numArgs) {
	$inputFiles[$i] = Bio::SeqIO->new(-file => $ARGV[$i], -format => 'Fasta');
	
	while($sequence = $inputFiles[$i]->next_seq()) {
		
		# Extracted from http://doc.bioperl.org/releases/bioperl-1.5.1/Bio/Perl.html
		# If the computer has Internet accessibility, blasts the sequence using the NCBI BLAST server against nrdb.
		$blast = blast_sequence($sequence);
		
		write_blast(">../outputs/blast$i.out",$blast);
	}

	$i++;
}


