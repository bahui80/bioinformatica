use Bio::SeqIO;
use Bio::SeqUtils;
use Try::Tiny;

# If the number of arguments is invalid, throw a message and exit
$numArgs = $#ARGV + 1;
if($numArgs != 1) {
	print "Incorrect number of parameters. Please provide the genbank file\n";
	exit;
}

# Open the genbank file. If the file doesn't exists, throw a message and exit
try {
	$inputFile = Bio::SeqIO->new(-file => "$ARGV[0]", -format => 'Genbank');
	
	# Reading the 6 frames and translating them to amino
	my @frames = Bio::SeqUtils->translate_6frames($inputFile->next_seq());


	try {
		# Generate each output file for each reading frame
		$outputFile1 = Bio::SeqIO->new(-file => ">../outputs/seq-0F.fas", -format => 'Fasta');
		$outputFile1->write_seq($frames[0]);
		print "File seq-0F.fas created succesfully\n";
		
		$outputFile2 = Bio::SeqIO->new(-file => ">../outputs/seq-1F.fas", -format => 'Fasta');
		$outputFile2->write_seq($frames[1]);
		print "File seq-1F.fas created succesfully\n";
	
		$outputFile3 = Bio::SeqIO->new(-file => ">../outputs/seq-2F.fas", -format => 'Fasta');
		$outputFile3->write_seq($frames[2]);
		print "File seq-2F.fas created succesfully\n";
	
		$outputFile4 = Bio::SeqIO->new(-file => ">../outputs/seq-0R.fas", -format => 'Fasta');
		$outputFile4->write_seq($frames[3]);
		print "File seq-0R.fas created succesfully\n";
	
		$outputFile5 = Bio::SeqIO->new(-file => ">../outputs/seq-1R.fas", -format => 'Fasta');
		$outputFile5->write_seq($frames[4]);
		print "File seq-1R.fas created succesfully\n";
	
		$outputFile6 = Bio::SeqIO->new(-file => ">../outputs/seq-2R.fas", -format => 'Fasta');
		$outputFile6->write_seq($frames[5]);
		print "File seq-2R.fas created succesfully\n";
	} catch {
		print "There was an error creating some of the files\n";
		exit;
	}
} catch {
 	print "File not found. Please provide a genbank file\n";
	exit;
}