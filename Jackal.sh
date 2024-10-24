#!/bin/bash

# Color codes
red='\e[0;31m'
grn='\e[0;32m'
norm='\e[0;0m'
yel='\e[0;33m'
cyan='\e[0;36m'


function banner() {
    echo -e "${grn}"
    figlet "Jackal://"
    echo -e "${norm}Dorks based web scraper with evasion capabilities\n"
    sleep 1
}
banner

#define mode - social accounts or files search
function type(){
    echo -e "select target type ::\n[1] File\n[2] Social accounts\n\n"
    read mode
    if [ $mode -eq 1 ]; then 
        echo -e "File mode selected"
    fi
    if [ $mode -eq 2 ]; then
        echo -e "Social Accounts mode selected"
    fi
}
type


function set_targets(){
    if [ $mode -eq 1 ]; then
        echo -e "select target/s site, for multiple sites have space between them"
        read -p ":: " targets
        echo "$targets" > ./targets.txt
        echo "$(cat ./targets.txt |  sed 's/ /+/g' | awk '{print "\"" $0 "\""}')" > ./targets.txt
    fi
    #relevant to social accounts mode only
    if [ $mode -eq 2 ]; then
        echo -e "please enter POI name, pseudoname or Email"
        read name
        POI=$(echo "$name" | sed 's/ /+/g' | awk '{print "\"" $0 "\""}')
    fi
}
set_targets

#file type selection
function set_variables(){
if [ $mode -eq 1 ]; then
    echo -e "${yel}what type of documents are you looking for${norm}?
    [1] text.
    [2] pictures.
    [3] charts.
    [4] presentations.
    [5] anything!"
    read -p ":: " type

    if [ $type -eq 1 ]; then
        echo -e "${yel}[*]dorking for text${norm}
        [1] PDF
        [2] DOC/X
        [3] CSV 
        [4] TXT
        [5] LST
        [6] ALL"
        read -p ":: " type2
    fi
    if [ $type -eq 2 ]; then
        echo -e "${yel}[*]Dorking for pictures${norm}
        [1] JP/E/G
        [2] IMG
        [3] GIF
        [4] PNG
        [5] BMP
        [6] WEBP
        [7] HEIF
        [8] TIF/F
        [9] ALL"
        read -p ":: " type2
    fi
    if [ $type -eq 3 ]; then
        echo -e "${yel}[*]Dorking for charts${norm}
        [1] XLS/M
        [2] SVG
        [3] PDF
        [4] JSON
        [5] TWB/X
        [6] VSDX
        [7] CSV
        [8] ALL"
        read -p ":: " type2
    fi
    if [ $type -eq 4 ]; then
        echo -e "${yel}[*]Dorking for presentations${norm}
        [1] PPT/X
        [2] PDF
        [3] ODP
        [4] KEY
        [5] HTML
        [6] SWF
        [7] ALL"
        read -p ":: " type2
    fi
fi
}
set_variables

function compiler() {
    # Initialize query - relevant to FILE MODE only
    type=${type:-0}
    type2=${type2:-0}
if [ $mode -eq 1 ]; then
    # Compiler for text files
    if [ "$type" -eq 1 ]; then
        case "$type2" in
            1) query="inurl:pdf" ;;
            2) query="inurl:doc OR inurl:docx" ;;
            3) query="inurl:csv" ;;
            4) query="inurl:txt" ;;
            5) query="inurl:lst" ;;
            6) query="inurl:pdf OR inurl:doc OR inurl:docx OR inurl:csv OR inurl:txt OR inurl:lst" ;;
        esac
    fi

    # Compiler for picture files
    if [ "$type" -eq 2 ]; then
        case "$type2" in
            1) query="inurl:jpg OR inurl:jpeg" ;;
            2) query="inurl:img" ;;
            3) query="inurl:gif" ;;
            4) query="inurl:png" ;;
            5) query="inurl:bmp" ;;
            6) query="inurl:webp" ;;
            7) query="inurl:heif OR inurl:heic" ;;
            8) query="inurl:tif OR inurl:tiff" ;;
            9) query="inurl:jpg OR inurl:jpeg OR inurl:img OR inurl:gif OR inurl:png OR inurl:bmp OR inurl:webp OR inurl:heif OR inurl:heic OR inurl:tif OR inurl:tiff" ;;
        esac
    fi

    # Compiler for chart files
    if [ "$type" -eq 3 ]; then
        case "$type2" in
            1) query="inurl:xls OR inurl:xlsm" ;;
            2) query="inurl:svg" ;;
            3) query="inurl:pdf" ;;
            4) query="inurl:json" ;;
            5) query="inurl:twb OR inurl:twbx" ;;
            6) query="inurl:vsdx" ;;
            7) query="inurl:xls OR inurl:xlsm OR inurl:svg OR inurl:pdf OR inurl:json OR inurl:twb OR inurl:twbx OR inurl:vsdx OR inurl:csv" ;;
        esac
    fi

    # Compiler for presentation files
    if [ "$type" -eq 4 ]; then
        case "$type2" in
            1) query="inurl:ppt OR inurl:pptx" ;;
            2) query="inurl:pdf" ;;
            3) query="inurl:odp" ;;
            4) query="inurl:key" ;;
            5) query="inurl:html" ;;
            6) query="inurl:swf" ;;
            7) query="inurl:ppt OR inurl:pptx OR inurl:pdf OR inurl:odp OR inurl:key OR inurl:html OR inurl:swf" ;;
        esac
    fi

    # Compiler for all files
    if [ "$type" -eq 5 ]; then
        type2="inurl:pdf OR inurl:doc OR inurl:docx OR inurl:csv OR inurl:txt OR inurl:lst OR inurl:jpg OR inurl:jpeg OR inurl:img OR inurl:gif OR inurl:png OR inurl:bmp OR inurl:webp OR inurl:heif OR inurl:heic OR inurl:tif OR inurl:tiff OR inurl:xls OR inurl:xlsm OR inurl:svg OR inurl:json OR inurl:twb OR inurl:twbx OR filetype:vsdx OR inurl:odp OR inurl:key OR inurl:html OR inurl:swf"
    fi
    echo "$query" | sed 's/ /+/g' | sed 's/:/%3A/g' > ./query.txt
    query=$(cat ./query.txt | sed 's/ /+/g' | awk '{print "\"" $0 "\""}')
fi
}
compiler

#define key word to narrow results
function key_word(){
    echo -e "insert keyword/expression"
    read -p ":: " expression
    if [ $kword -z ]; then
        kword="$POI"
    else
    kword=$(echo "$expression" | sed 's/ /+/g' | awk '{print "\"" $0 "\""}')
    fi

}
key_word

    echo "$targets"
    echo "$query"
    echo "$kword"

function curl_request() {
    if [ "$mode" -eq 1 ]; then
        echo "https://www.google.com/search?q=site%3A$targets+$query+insite%3A$kword"
        
        # send request
        curl --http1.1 -G -A "$(shuf -n 1 ./user_agents.txt)" \
            -H "Accept-Language: en-US,en;q=0.5" \
            -H "Connection: keep-alive" \
            "https://www.google.com/search?q=site%3A$targets+$query+$kword" > ./results.txt
        
        # Process the results and remove generic irrelevant results
        {
            sed 's/ /\n/g' ./results.txt | 
            grep http | 
            grep -v "https://encrypted" |
            grep -v refresh |
            grep -v 'faviconV2' | 
            grep -v google | 
            grep -v 'www.w3' |   
            grep -v maps.google | 
            grep -v policies.google | 
            grep -v support.google | 
            grep -v google.com/preferences | 
            awk -F'&amp' '{print $1}' |
            sort |
            uniq |
            awk -F'http' '{print "[*] http" $2}' 
            
        } > ./final.txt
        
        cat ./final.txt

    elif [ "$mode" -eq 2 ]; then
        echo "https://www.google.com/search?q=inurl%3A$POI"
        
        # send request
        curl --http1.1 -G -A "$(shuf -n 1 ./user_agents.txt)" \
            -H "Accept-Language: en-US,en;q=0.5" \
            -H "Connection: keep-alive" \
            "https://www.google.com/search?q=inurl%3A$POI+$kword" > ./results.txt
        
        # Process the results and remove generic irrelevant results
        {
            sed 's/ /\n/g' ./results.txt | 
            grep http | 
            grep -v refresh | 
            grep -v "https://encrypted" |
            grep -v google | 
            grep -v 'www.w3' |  
            grep -v "gstatic" | 
            grep -v maps.google | 
            grep -v policies.google | 
            grep -v support.google | 
            grep -v google.com/preferences | 
            sort |
            uniq |
            awk -F'http' '{print "[*] http" $2}' 
        } > ./final.txt
        
        cat ./final.txt
    fi
}

# Call the function
curl_request

#extract all files

if [ $mode -eq 1 ]; then 
    function extraction (){
        echo -e "Extract files?\n[Y]es\n[N]o"
        read extract
        if [ $extract == "y" ]; then
            for link in $(cat ./final.txt | grep $targets | awk '{print $2}'); do
                echo "wget -P ./$targets $link"
                wget -P ./$targets $link
                sleep 3
               
            done
        fi
    }
    extraction
fi


function profile_saver(){
    echo -e "saving results"
    mkdir -p "$(echo "$name" | sed 's/ /_/g')" && cat ./final.txt > "$(echo "$name" | sed 's/ /_/g')/results.txt"
}
if [ $mode -eq 2 ]; then 
    profile_saver
fi



