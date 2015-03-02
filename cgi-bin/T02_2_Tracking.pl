#!/usr/bin/perl -w
$| = 1;

use CGI qw(param);
use CGI::Carp;
use File::Basename;
$CGI::POST_MAX = 1024 * 50000; # 50mb file max
my $query = new CGI;
my $safe_filename_characters = "a-zA-Z0-9_.-";

my $filename = $query->param('file');
my $project = $query->param('project');
my $Decimate = $query->param('Decimate');

if (defined ($project)) {
    if  ($project) {
        $project="/".$project;
        }
    else  {
        $project="";
        }
}
else {
    $project="";
}



if ( !$filename )
{
    print $query->header ( );
    print "There was a problem uploading your GNSS file, or not file not selected\n";
    exit;
}


$filename=~m/^.*(\\|\/)(.*)/; # strip the remote path and keep the filename

if ( defined ($2) ) {
   $filename = $2;
   }


my ( $name, $path, $extension ) = fileparse ( $filename, '\..*' );
$filename = $name . $extension;


$filename =~ tr/ /_/;
$filename =~ s/[^$safe_filename_characters]//g;

if ( $filename =~ /^([$safe_filename_characters]+)$/ )
{
    $filename = $1;
}
else
{
    die "Filename contains invalid characters";

}

print $query->header ( );
#print "Content-type: text/html\n\n";
print "<html><head>";
print '<link rel="stylesheet" type="text/css" href="/css/tcui-styles.css">';
print "<meta http-equiv=\"refresh\" content=\"5; url=/results/Tracking$project/$name\">";
print "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=iso-8859-1\" />";
print "<title>Plotting GNSS Tracking Data</title></head><body><h1>Processing $filename:</h1>\n";

#print "Project: *$project*";

#print $filename."\n";
my $TrimbleTools=0;
my $upload_file="";

if ($TrimbleTools) {
    $upload_file = "/home8/trimblet/public_html/cgi-bin/tmp/".$filename;
}
else {
    $upload_file = "/run/shm/".$filename;
}
#my $upload_file = $filename;
my $upload_filehandle = $query->upload("file");

#print $upload_file;
if (!open ( UPLOADFILE, ">$upload_file" )) {
    print "\n could not open output file".$upload_file;
    die "$!";
}
# or die "$!";
binmode UPLOADFILE;

while ( <$upload_filehandle> )
{
    print UPLOADFILE;
}

close UPLOADFILE;

#Content-type: text/html
#application/vnd.google-earth.kml+xml

print "Data is being processed: This will normally takes a few seconds but can take longer for very large files.<br>";
print "The graphs will be at \<a href=\"/results/Tracking$project/$name\"\>/results/Tracking$project/$name/\</a\>\n";
print "<p/>Processing will continue if you navigate away from this page<br/>";
print "<pre>\n";
system "./start_single.sh",$upload_file,$extension,$TrimbleTools,$Decimate,$project
