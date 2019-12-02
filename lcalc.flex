/*
  This example comes from a short article series in the Linux 
  Gazette by Richard A. Sevenich and Christopher Lopes, titled
  "Compiler Construction Tools". The article series starts at

  http://www.linuxgazette.com/issue39/sevenich.html

  Small changes and updates to newest JFlex+Cup versions 
  by Gerwin Klein
*/

/*
  Commented By: Christopher Lopes
  File Name: lcalc.flex
  To Create: > jflex lcalc.flex

  and then after the parser is created
  > javac Lexer.java
*/
   
/* --------------------------Usercode Section------------------------ */
   
import java_cup.runtime.*;
      
%%
   
/* -----------------Options and Declarations Section----------------- */
   
/* 
   The name of the class JFlex will create will be Lexer.
   Will write the code to the file Lexer.java. 
*/
%class Lexer

/*
  The current line number can be accessed with the variable yyline
  and the current column number with the variable yycolumn.
*/
%line
%column
    
/* 
   Will switch to a CUP compatibility mode to interface with a CUP
   generated parser.
*/
%cup
   
/*
  Declarations
   
  Code between %{ and %}, both of which must be at the beginning of a
  line, will be copied letter to letter into the lexer class source.
  Here you declare member variables and functions that are used inside
  scanner actions.  
*/
%{   
    /* To create a new java_cup.runtime.Symbol with information about
       the current token, the token will have no value in this
       case. */
    private Symbol symbol(int type) {
        return new Symbol(type, yyline, yycolumn);
    }
    
    /* Also creates a new java_cup.runtime.Symbol with information
       about the current token, but this object has a value. */
    private Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline, yycolumn, value);
    }
%}
   

/*
  Macro Declarations
  
  These declarations are regular expressions that will be used latter
  in the Lexical Rules Section.  
*/
   
/* A line terminator is a \r (carriage return), \n (line feed), or
   \r\n. */
LineTerminator = \r|\n|\r\n
   
/* White space is a line terminator, space, tab, or line feed. */
WhiteSpace     = {LineTerminator} | [ \t\f]
   
/* A literal integer is a number beginning with a number between
   one and nine followed by zero or more numbers between zero and nine
   or just a zero.  */
dec_int_lit = 0 | [1-9][0-9]*

dec_float_lit = [0-9]+\.[0-9]*
   
/* A identifier integer is a word beginning a letter between A and
   Z, a and z, or an underscore followed by zero or more letters
   between A and Z, a and z, zero and nine, or an underscore. */
dec_int_id = [A-Za-z_][A-Za-z_0-9]*

commentinicio   = \/\*
commentfim      = \*\/
naocommentfim   = [^\*\/]
commentbody     = {naocommentfim}*
comment =  {commentinicio}{commentbody}{commentfim} | \/\/[a-zA-Z0-9 \t]*

%%
/* ------------------------Lexical Rules Section---------------------- */
   
/*
   This section contains regular expressions and actions, i.e. Java
   code, that will be executed when the scanner matches the associated
   regular expression. */
   
   /* YYINITIAL is the state at which the lexer begins scanning.  So
   these regular expressions will only be matched if the scanner is in
   the start state YYINITIAL. */
   
<YYINITIAL> {
   
    /* Return the token SEMI declared in the class sym that was found. */
     //";"                { return symbol(sym.SEMI); }                 
   
    /* Print the token found that was declared in the class sym and then
       return it. */
    ";"                {  return symbol(sym.SEMI);     }
    "+"                {  return symbol(sym.PLUS);     }
    "-"                {  return symbol(sym.MINUS);    }
    "*"                {  return symbol(sym.TIMES);    }
    "div"                {  return symbol(sym.DIVIDE);   }
    "("                {  return symbol(sym.LPAREN);   }
    ")"                {  return symbol(sym.RPAREN);   }
    "["                {  return symbol(sym.LBRCKT);   }
    "]"                {  return symbol(sym.RBRCKT);   }
    "<-"               {  return symbol(sym.ATTRIB);   }
    "="                {  return symbol(sym.EQUALS);   }
    ">"                {  return symbol(sym.GREATER);  }
    "<"                {  return symbol(sym.LESS);     }
    "escreva"          {  return symbol(sym.WRITELINE);}
    "leia"             {  return symbol(sym.READLINE); }
    "programa"         {  return symbol(sym.PROGRAM);  }
    "inicio"           {  return symbol(sym.STARTPRG); }
    "fim"              {  return symbol(sym.ENDPRG);   }
    "inteiro"          {  return symbol(sym.DECLINT);  }
    "flutuante"        {  return symbol(sym.DECLFLOAT);}
    "se"               {  return symbol(sym.IFF);      }
    "nao"               {  return symbol(sym.NAO);       }
    "entao"            {  return symbol(sym.THENN);    }
    "senao"            {  return symbol(sym.ELSEE);    }
    "fimse"            {  return symbol(sym.ENDELSE);  }
    "para"             {  return symbol(sym.PARA);     }
    "de"               {  return symbol(sym.DE);       }
    "ate"              {  return symbol(sym.ATE);      }
    "passo"            {  return symbol(sym.PASSO);    }
    "faca"             {  return symbol(sym.FACA);     }
    "fimpara"          {  return symbol(sym.FIMPARA);  }
    "enquanto"         {  return symbol(sym.ENQUANTO); }
    "fimenquanto"      {  return symbol(sym.FIMENQUANTO);}
    "e"                {  return symbol(sym.E);        }
    "ou"               {  return symbol(sym.OU);       }
    "funcao"           {  return symbol(sym.FUNCAO);   }
    "funcaoinicio"     {  return symbol(sym.STARTFUNC);}
    "funcaofim"        {  return symbol(sym.ENDFUNC);  }
    "retorno"          {  return symbol(sym.RETORNO);  }

   
    /* If an integer is found print it out, return the token NUMBER
       that represents an integer and the value of the integer that is
       held in the string yytext which will get turned into an integer
       before returning */
    {dec_int_lit}      { /* System.out.print(yytext()); */
                         return symbol(sym.INTT,yytext()); }
   
    {dec_float_lit}      { /* System.out.print(yytext()); */
                         return symbol(sym.FLOATT, yytext()); }
   
    /* If an identifier is found print it out, return the token ID
       that represents an identifier and the default value one that is
       given to all identifiers. */
    {dec_int_id}       { /* System.out.print(yytext()); */
                         return symbol(sym.ID, yytext());} /* change here */
   
    /* Don't do anything if whitespace is found */
    {WhiteSpace}       { /* just skip what was found, do nothing */ }   

    {comment}          { /* just skip what was found, do nothing */ }   
}


/* No token was found for the input so through an error.  Print out an
   Illegal character message with the illegal character that was found. */
[^]                    { throw new Error("Illegal character <"+yytext()+">"); }
