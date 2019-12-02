#!/bin/bash
rm *.class
rm parser.java
rm Lexer.java
rm sym.java
rm *.java~
java -jar JFlex.jar lcalc.flex
java -jar java-cup-11b.jar ycalc.cup
javac -cp java-cup-11b.jar:JFlex.jar:. *.java 
java -cp java-cup-11b.jar:JFlex.jar:. Main test.simples > teste.c
