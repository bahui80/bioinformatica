use Bio::SearchIO;
use Bio::DB::GenBank;
use Bio::SeqIO;
use Bio::Seq;
use Bio::Perl;

if($#ARGV != 1) {
	print "Please provide a blast file and a pattern to search\n";
	exit;
}

$blastFile = new Bio::SearchIO('-format' => 'blast', '-file' => $ARGV[0]);
$textPattern = lc $ARGV[1];

$i = 1;

print "Hits coincidence with the pattern: ", $ARGV[1],"\n";
# $result is a Bio::Search::Result::ResultI compliant object
while($result = $blastFile->next_result) {
  	# $hit is a Bio::Search::Hit::HitI compliant object
  	while($hit = $result->next_hit) {
  		
  		$accesionNumber = $hit->accession;
  		$descriptionHit = lc $hit->description;
  		if(index($descriptionHit, $textPattern) != -1) {
			print $hit->name, $hit->description, "\n";

	       	$genBankFile = Bio::DB::GenBank->new(-retrievaltype => 'tempfile' , -format => 'Fasta');
	       	
	       	# Gets the entire stream with the sequence with the accession number
	       	$sequence = $genBankFile->get_Stream_by_acc($accesionNumber);

			$outputFile = Bio::SeqIO->new(-file => ">>../outputs/hitsCoincidence.fas", -format => 'Fasta');
			
			while ($seq = $sequence->next_seq) {
  				$outputFile->write_seq($seq);	
			}
  		}
	$i += 1;
 	}
}