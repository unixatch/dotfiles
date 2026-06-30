{
    # Gets only the minor version number
    # and it increases it
    minorNumber = gensub(\
        /"version": "[0-9]*.[0-9]*.([0-9]*).*/, \
        "\\1", \
        1 \
    )
    minorNumber += AMOUNT

    # Updates the file
    version = gensub(\
        /("version": "[0-9]*.[0-9]*.)[0-9]*(.*)/, \
        "\\1" minorNumber "\\2", \
        1 \
    )
    print version
}

