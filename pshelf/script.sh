#!bin/bash

#if ! command -v java;
#then
#    echo "Java is either not installed or configured properly."
#    echo "Terminating shell"
#    exit
#fi    
 
cleanup () {
    find . -type f -name "*.java" -delete    
    find . -type f -name sed\* -delete
    find . -type f -name "*.class" -delete
} 

cleanup
