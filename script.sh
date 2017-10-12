#!bin/bash

destFile=~/Desktop/Projects/repel/templateJava.java 
templateFile=~/Desktop/Projects/repel/template.txt
progName=templateJava

cat $templateFile > $destFile

echo "Hello World!!!"
echo "You should begin typing your code now. Press Ctrl-C to exit."

counter=0
while [ $counter -le 1000 ]
do 
    #echo $counter
    echo -n '>'
    counter=$((counter+=1))
    read input
    if [ -f "$destFile" ]
    then
        head -n -2 templateJava.java > temp.txt; mv temp.txt templateJava.java
        sed -i '/System.out/d' $destFile

        if command -v java; 
        then
            echo "$input" >> "$destFile"
            echo "}" >> "$destFile"
            echo "}" >> "$destFile"
            
            if javac -classpath "." $progName;
            then
                if java templateJava;
                then
                    echo ""
                else
                    sed -i "/$input/d" $destFile
                fi 
            else
                sed -i "/$input/d" $destFile           
            fi
        else
            echo "Java is either not installed or configured properly."
            echo "Terminating shell"
            exit    
        fi
    fi    
done    
