
# JP2ArchiveToPDF

This is a simple script to convert archives of JP2 files into a single PDF
file. This is useful for converting downloads of books from `archive.org` into
PDF format, without the reduced quality of 

## Usage

This script is written in Bash, and requires the commands `unzip`,
`opj_decompress`, and `convert`. When those are all installed, the script can
be called as follows.

<pre>
$ ls<br>
Archive.zip<br>
$ bash archive_to_pdf.sh Example.zip<br>
<b>Unzipping file Example.zip</b><br>
<b>Converting file Example_0.jp2</b><br>
<b>Converting file Example_1.jp2</b><br>
<b>Converting file Example_2.jp2</b><br>
<b>Converting file Example_3.jp2</b><br>
<b>Converting all images to file Example.pdf</b><br>
<b>Finished converting Example.zip to Example.pdf</b><br>
$ ls<br>
Example.pdf Example.zip<br>
</pre>

