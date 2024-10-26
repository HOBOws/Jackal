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
            1) query="filetype:pdf" ;;
            2) query="filetype:doc OR docx" ;;
            3) query="filetype:csv" ;;
            4) query="filetype:txt" ;;
            5) query="filetype:lst" ;;
            6) query="filetype:pdf OR doc OR docx OR csv OR txt OR lst" ;;
        esac
    fi

    # Compiler for picture files
    if [ "$type" -eq 2 ]; then
        case "$type2" in
            1) query="filetype:jpg" ;;
            2) query="filetype:img" ;;
            3) query="filetype:gif" ;;
            4) query="filetype:png" ;;
            5) query="filetype:bmp" ;;
            6) query="filetype:webp" ;;
            7) query="filetype:heif OR heic" ;;
            8) query="filetype:tif OR tiff" ;;
            9) query="filetype:jpg OR jpeg OR img OR gif OR png OR bmp OR webp OR heif OR heic OR tif OR tiff" ;;
        esac
    fi

    # Compiler for chart files
    if [ "$type" -eq 3 ]; then
        case "$type2" in
            1) query="filetype:xls OR inurl:xlsm" ;;
            2) query="filetype:svg" ;;
            3) query="filetype:pdf" ;;
            4) query="filetype:json" ;;
            5) query="filetype:twb OR inurl:twbx" ;;
            6) query="filetype:vsdx" ;;
            7) query="filetype:xls OR xlsm OR svg OR pdf OR json OR twb OR twbx OR vsdx OR csv" ;;
        esac
    fi

    # Compiler for presentation files
    if [ "$type" -eq 4 ]; then
        case "$type2" in
            1) query="filetype:ppt OR pptx" ;;
            2) query="filetype:pdf" ;;
            3) query="filetype:odp" ;;
            4) query="filetype:key" ;;
            5) query="filetype:html" ;;
            6) query="filetype:swf" ;;
            7) query="filetype:ppt OR pptx OR pdf OR odp OR key OR html OR swf" ;;
        esac
    fi

    # Compiler for all files
    if [ "$type" -eq 5 ]; then
        type2="filetype:pdf OR doc OR docx OR csv OR txt OR lst OR jpg OR jpeg OR img OR gif OR png OR bmp OR webp OR heif OR heic OR tif OR tiff OR xls OR xlsm OR svg OR json OR twb OR twbx OR vsdx OR odp OR key OR html OR swf"
    fi
    unquery=$(echo "$query" | sed 's/+/ /g' | sed 's/:/%3A/g' | sed 's/filetype:/ /g' | sed 's/OR/ /g' | sed 's/filetype%3A/ /g')
    echo "$query" | sed 's/ /+/g' | sed 's/:/%3A/g' > ./query.txt
    query=$(cat ./query.txt | sed 's/ /+/g')
    
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
    kword=$(echo "$expression" | sed 's/ /+/g')
    fi

}
key_word

    echo "$targets"
    echo "$query"
    echo "$kword"

function curl_request() {
    if [ "$mode" -eq 1 ]; then
        echo "https://www.google.com/search?q=site%3A$targets+$query"
        
        # send request
        curl --http1.1 -G -A "$(shuf -n 1 ./user_agents.txt)" \
            -H "Accept-Language: en-US,en;q=0.5" \
            -H "Connection: keep-alive" \
            "https://www.google.com/search?q=site%3A$targets+$query" > ./results.txt
        
        # Process the results and remove generic irrelevant results
        {
            sed 's/ /\n/g' ./results.txt | 
            grep -e http -e $targets | 
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
            awk -F'http' '{print "[*] http" $2}' |
            grep -v -w "http" 
            
            
        } > ./final.txt
            
        
        Downloadready=$(cat ./final.txt | grep -Eo 'https?://[^"]+\.[a-zA-Z0-9]{3,4}' | sort | uniq)
        echo "$Downloadready" > ./final.txt 
        echo "$Downloadready"
    
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
            for link in $(cat ./final.txt | grep -v 'gstatic'); do
                echo "wget -P ./$targets $link"
                wget -P ./$targets $link
                sleep 2
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



