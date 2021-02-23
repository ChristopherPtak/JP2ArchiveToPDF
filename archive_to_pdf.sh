#! /usr/local/bin bash

##
## Function definitions
##

bold_echo ()
{
    tput bold
    echo "$1"
    tput sgr0
}

fail ()
{
    bold_echo "Error: $1" 1>&2
    cleanup
    exit 1
}

setup ()
{
    WORKING_DIRECTORY=$(mktemp -d)
}

archive_to_pdf ()
{
    INPUT_FILENAME="$1"
    OUTPUT_FILENAME="${1%.*}.pdf"

    bold_echo "Unzipping file ${INPUT_FILENAME}"
    unzip -j "${INPUT_FILENAME}" -d "${WORKING_DIRECTORY}" \
        1>/dev/null || fail "Unable to unzip file $1"

    ls -1q "${WORKING_DIRECTORY}" | while read FILENAME
    do

        case "${FILENAME}" in

            *.jp2)
                bold_echo "Converting file ${FILENAME}"
                # For some reason, opj_decompress prints a newline on stderr
                # so we suppress stderr here; this may result in hidden errors
                opj_decompress -i "${WORKING_DIRECTORY}/${FILENAME}" \
                               -o "${WORKING_DIRECTORY}/${FILENAME}.png" \
                               &>/dev/null || fail "Unable to convert file ${FILENAME} to PNG"
                ;;

            *)
                # Ignore any extra files
                bold_echo "Warning: Non-JPEG2000 file ${FILENAME}"
                ;;

        esac
    done

    bold_echo "Converting all images to file ${OUTPUT_FILENAME}"
    convert "${WORKING_DIRECTORY}"/*.png "${OUTPUT_FILENAME}" \
        1>/dev/null || "Unable to convert images to PDF"

    # Delete containing files to clear up space for next round
    rm "${WORKING_DIRECTORY}"/*

    bold_echo "Finished converting ${INPUT_FILENAME} to ${OUTPUT_FILENAME}"
}

cleanup ()
{
    rmdir "${WORKING_DIRECTORY}"
}


##
## Main actions
##

if [[ "$1" == "-h" || "$1" == "--help" ]]
then

    echo "Usage: $0 [FILES]"
    echo "       $0 --help"

else

    setup

    while (( "$#" ))
    do
        archive_to_pdf "$1"
        shift
    done

    cleanup

fi

