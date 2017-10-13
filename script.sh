#!bin/bash
#!bin/sh

if ! command -v java;
then
    echo "Java is either not installed or configured properly."
    echo "Terminating shell"
    exit
fi    
 
cleanup () {
    rm -f ./replsh.java
    if [ -f ./replsh.class ]
    then
        rm -f ./replsh.class
    fi    
    echo "\nExiting shell."
    exit
}

touch ./replsh.java
destFile=~/Desktop/Projects/repel/replsh.java 
templateFile=~/Desktop/Projects/repel/template.txt
progName=replsh.java

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
        head -n -2 replsh.java > temp.txt; mv temp.txt replsh.java
        sed -i '/System.out/d' $destFile

        echo "$input" >> "$destFile"
        echo "}" >> "$destFile"
        echo "}" >> "$destFile"
            
        if javac -classpath "." $progName;
        then
            if ! java replsh;
            then
                grep  -v "$input" "$destFile" > temp.txt; mv temp.txt replsh.java
                #sed -i "/$input/d" $destFile
            fi 
        else
            sed -i "/$input/d" $destFile           
        fi
    fi    
done    

rm -f ./replsh.java
exit