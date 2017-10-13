#!bin/bash
#!bin/sh

if ! command -v gcc;
then
    echo "C compiler is either not installed or configured properly."
    echo "Terminating shell"
    exit
fi    
 
cleanup () {
    rm -f ./replsh.c
    if [ -f ./a.out ]
    then
        rm -f ./a.out
    fi    
    echo "\nExiting shell."
    exit
}

touch ./replsh.c
destFile=~/Desktop/Projects/repel/replsh.c 
templateFile=~/Desktop/Projects/repel/templates/templateC.txt
progName=replsh.c

cat $templateFile > $destFile

echo "\nHello World!!!"
echo "You should begin typing your code now. Press Ctrl-C to exit.\n"

counter=0
while [ $counter -le 1000 ]
do 
    #echo $counter
    echo -n '>'
    counter=$((counter+=1))
    read input

    trap cleanup INT TERM QUIT 

    if [ -f "$destFile" ]
    then
        head -n -2 replsh.c > temp.txt; mv temp.txt replsh.c
        sed -i '/printf/d' $destFile

        echo "$input" >> "$destFile"
        echo "return 0;" >> "$destFile"
        echo "}" >> "$destFile"
            
        if gcc $destFile;
        then
            if ! ./a.out;
            then
                grep  -v "$input" "$destFile" > temp.txt; mv temp.txt replsh.c
                echo ""
                #sed -i "/$input/d" $destFile
            fi 
        else
            sed -i "/$input/d" $destFile
            echo ""           
        fi
    fi    
done    

cleanup