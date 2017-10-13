#!bin/bash
#!bin/sh

if ! command -v java;
then
    echo "Java is either not installed or configured properly."
    echo "Terminating shell"
    exit
fi    
 
cleanup () {
    find . -type f -name replsh\* -delete    
    find . -type f -name sed\* -delete
    echo "\nExiting shell."
    exit
}

destFile=~/Desktop/Projects/repel/src/replsh.java 
templateFile=~/Desktop/Projects/repel/templates/template.txt
progName=replsh.java

cat $templateFile > $destFile

echo "\nHello World!!!"
echo "You should begin typing your code now. Press Ctrl-C to exit.\n"

counter=0
while [ $counter -le 1000 ]
do 
    echo -n '>'
    counter=$((counter+=1))
    read input

    trap cleanup INT TERM QUIT

    if [ -f "$destFile" ]
    then
        head -n -2 $destFile > temp.txt; mv temp.txt $destFile
        sed -i '/System.out/d' $destFile

        echo "$input" >> "$destFile"
        echo "}" >> "$destFile"
        echo "}" >> "$destFile"
            
        if javac -cp ./src -d ./build ./src/$progName;
        then
            if ! java -cp ./build replsh;
            then
                grep  -v "$input" "$destFile" > temp.txt; mv temp.txt $destFile
                echo ""
            fi 
        else
            sed -i "/$input/d" $destFile
            echo ""           
        fi
    fi    
done    

cleanup