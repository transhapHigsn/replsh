#!bin/bash

if ! command -v java;
then
    echo "Java is either not installed or configured properly."
    echo "Terminating shell"
    exit
fi    
 
cleanup () {
    find . -type f -name replsh\* -delete    
    find . -type f -name sed\* -delete
    find . -type f -name "*.class" -delete
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
    read -e input
    history -s "$input"

    trap cleanup INT TERM QUIT

    if [ -f "$destFile" ]
    then
        head -n -2 $destFile > temp.txt; mv temp.txt $destFile
        sed -i '/System.out/d' $destFile

        #if [[ $input =~ .*import.* ]] only for bash
        
        if echo "$input" | grep -q "import"
        then
            sed -i "/\/\/import/a $input" $destFile
        elif echo "$input" | grep -q "interface"
        then
            sed -i "/\/\/interface/a $input" $destFile
        elif echo "$input" | grep -q "function"
        then
            sed -i "/\/\/function/a $input" $destFile
        elif echo "$input" | grep -q "constructor"
        then
            sed -i "/\/\/constructor/a $input" $destFile           
        else    
            echo "$input" >> "$destFile"
        fi

        #cat $destFile    
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