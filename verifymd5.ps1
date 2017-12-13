function verify_file_checksum($filename, $checksumfile){
    # Use the Windows get-filehash method to grab our file's md5.
    $filehash = get-filehash -Algorithm MD5 $filename
    # Grab just the Hash column from the file hash.
    $filehash = $filehash | Select Hash | Out-String
    # Split the multiple lines.
    $filehash = ($filehash -split '\n') | Ft -autosize -wrap 
    # We want Line #3
    $filehash = $filehash[3] | Out-String

    # Get-Content of our Unix checksum file.
    $checksumfile_content = get-content $checksumfile
    # Upper our unix checksum and get just the first part
    $checksumfile_content = ($checksumfile_content.ToUpper() -split "\s+")[0]

    # If there's no diff..
    if (-not (diff $filehash.trim() $checksumfile_content.trim())){
        return 0
    }

    else{
        return 1
    }
}
