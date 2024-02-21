#!/bin/sh

echo "Cleaning existing classes..." 
rm -f *.class
# This command looks for matching files and runs the rm command for each file
# Note that {} are replaced with each file name
find . -name \*.class -exec rm {} \;

echo "Compiling source code and unit tests..."
# Changes here include adding references to the new input paths as well as the output path. I believe you had this more or less correct
javac -classpath .:lib/junit-4.12.jar:lib/hamcrest-core-1.3.jar src/main/java/*.java src/test/java/*.java -d build
if [ $? -ne 0 ] ; then echo BUILD FAILED!; exit 1; fi

echo "Running unit tests..."
# Note that :build is added before the junit core reference. Adding it to the EdgeConnectorTest directly causes it to not find the class file
java -cp .:lib/junit-4.12.jar:lib/hamcrest-core-1.3.jar:build org.junit.runner.JUnitCore EdgeConnectorTest
if [ $? -ne 0 ] ; then echo TESTS FAILED!; exit 1; fi


echo "Running application..."
# Make sure that you add :build here as well so java knows where to find the new output location for classes
java -classpath .:build RunEdgeConvert
