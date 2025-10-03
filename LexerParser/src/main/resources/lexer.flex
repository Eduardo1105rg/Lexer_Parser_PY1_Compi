
/* Esta es la seccion de encabezados u configuracion: eso de la directiva cup podria dar problemas. */
import java_cup.runtime.*;
import java.io.*;

/**
 * Analizador lexico jflex tomando en cuenta gramatica propia
 */
%%


%class Lexer
%unicode
%cup
%line   /* Estos de aqui son los que nos ayudan a la hora de saber en que posicion esta un token. */
%column

/* Esta es la parte de los codigos de usuario */
%{
    StringBuffer string = new StringBuffer(); // De la parte original
    
    // Contador de linea para errores
    public int getLine() { return yyline + 1; }
    public int getColumn() { return yycolumn + 1; }
    
    // De la parte original
    private Symbol symbol(int type) {
        return new Symbol(type, yyline + 1, yycolumn + 1);
    }
    
    // De la parte original
    private Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline + 1, yycolumn + 1, value);
    }
    
    // Errores lexicos
    public void reportError(String message) {
        System.err.println("Error léxico en línea " + (yyline + 1) + 
                          ", columna " + (yycolumn + 1) + ": " + message);
    }
%}


/* Definicion de macros: En esta parte va todo lo que es definido con expresiones regulares*/
LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
WhiteSpace     = {LineTerminator} | [ \t\f]

/* comentarios */
CommentLine    = "|" {InputCharacter}* {LineTerminator}?
CommentBlock   = "¡" [^!]* "!"

/* Definicion de numeros (hacer algunas correcciones por que creo que definimos mal en el original.) */
Entero = 0 | [-]?[1-9][0-9]*
EnteroPositivo = [1-9][0-9]* | 0
Flotante = (0\.0) | [-]?0\.[0-9]*[1-9]+ | [-]?[1-9][0-9]*\.([0-9]*[1-9]+|0)

/* Identificadores */
Identifier = [a-zA-Z][a-zA-Z0-9_]*

/* Caracteres especiales para strings y chars */
CaracterSimple = [^'\n\r\t]
StringSimple = [^"\n\r\t\\]

%state STRING
%state CHAR

%%

/* Palabras reservadas definidas */
<YYINITIAL> "let"                { return symbol(sym.LET); }
<YYINITIAL> "global"             { return symbol(sym.GLOBAL); }
<YYINITIAL> "void"               { return symbol(sym.VOID); }
<YYINITIAL> "principal"          { return symbol(sym.PRINCIPAL); }
<YYINITIAL> "decide"             { return symbol(sym.DECIDE); }
<YYINITIAL> "of"                 { return symbol(sym.OF); }
<YYINITIAL> "else"               { return symbol(sym.ELSE); }
<YYINITIAL> "end"                { return symbol(sym.END); }
<YYINITIAL> "loop"               { return symbol(sym.LOOP); }
<YYINITIAL> "exit"               { return symbol(sym.EXIT); }
<YYINITIAL> "when"               { return symbol(sym.WHEN); }
<YYINITIAL> "for"                { return symbol(sym.FOR); }
<YYINITIAL> "step"               { return symbol(sym.STEP); }
<YYINITIAL> "to"                 { return symbol(sym.TO); }
<YYINITIAL> "downto"             { return symbol(sym.DOWNTO); }
<YYINITIAL> "do"                 { return symbol(sym.DO); }
<YYINITIAL> "return"             { return symbol(sym.RETURN); }
<YYINITIAL> "break"              { return symbol(sym.BREAK); }
<YYINITIAL> "output"             { return symbol(sym.OUTPUT); }
<YYINITIAL> "input"              { return symbol(sym.INPUT); }
<YYINITIAL> "true"               { return symbol(sym.TRUE); }
<YYINITIAL> "false"              { return symbol(sym.FALSE); }

/* Tipos de datos */
<YYINITIAL> "int"                { return symbol(sym.INT); }
<YYINITIAL> "float"              { return symbol(sym.FLOAT); }
<YYINITIAL> "boolean"            { return symbol(sym.BOOLEAN); }
<YYINITIAL> "char"               { return symbol(sym.CHAR); }
<YYINITIAL> "string"             { return symbol(sym.STRING); }

<YYINITIAL> {
    /* Literales */
    {Flotante}                   { return symbol(sym.FLOAT_LITERAL, Double.parseDouble(yytext())); }
    {Entero}                     { return symbol(sym.INT_LITERAL, Integer.parseInt(yytext())); }
    {Identifier}                 { return symbol(sym.IDENTIFIER, yytext()); }
    
    /* Strings */
    \"                           { string.setLength(0); yybegin(STRING); }
    
    /* Caracteres */
    \'                           { yybegin(CHAR); }
    
    /* Operadores aritmeticos */
    "+"                          { return symbol(sym.PLUS); }
    "-"                          { return symbol(sym.MINUS); }
    "*"                          { return symbol(sym.MULTIPLY); }
    "/"                          { return symbol(sym.DIVIDE); }
    "//"                         { return symbol(sym.INT_DIVIDE); }
    "%"                          { return symbol(sym.MODULO); }
    "^"                          { return symbol(sym.POWER); }
    "++"                         { return symbol(sym.INCREMENT); }
    "--"                         { return symbol(sym.DECREMENT); }
    
    /* Operadores relacionales */
    "=="                         { return symbol(sym.EQUAL); }
    "!="                         { return symbol(sym.NOT_EQUAL); }
    "<="                         { return symbol(sym.LESS_EQUAL); }
    ">="                         { return symbol(sym.GREATER_EQUAL); }
    "<"                          { return symbol(sym.LESS); }
    ">"                          { return symbol(sym.GREATER); }
    
    /* Operadores logicos */
    "@"                          { return symbol(sym.AND); }
    "~"                          { return symbol(sym.OR); }
    "Σ"                          { return symbol(sym.NOT); }
    
    /* Asignacion */
    "="                          { return symbol(sym.ASSIGN); }
    
    /* Delimitadores y separadores */
    "$"                          { return symbol(sym.DELIMITER); }
    ","                          { return symbol(sym.COMMA); }
    ";"                          { return symbol(sym.SEMICOLON); }
    
    /* Parentesis especiales para operaciones () */
    "є"                          { return symbol(sym.LPAREN); }
    "э"                          { return symbol(sym.RPAREN); }
    
    /* Los que seria para abrir y cerrar ploques o sentencias. */
    /* "["                          { return symbol(sym.LBRACKET); } */
    /* "]"                          { return symbol(sym.RBRACKET); } */
    "¿"                          { return symbol(sym.LBRACE); }
    "?"                          { return symbol(sym.RBRACE); }
    
    /* Flecha para condiciones */
    "->"                         { return symbol(sym.ARROW); }
    
    /* Output concatenation */
    "<<"                         { return symbol(sym.OUTPUT_CONCAT); }
    
    /* Comentarios */
    {CommentLine}                { /* ignorar */ }
    {CommentBlock}               { /* ignorar */ }
    
    /* Espacios en blanco */
    {WhiteSpace}                 { /* ignorar */ }
}

/* manejo de strings */
<STRING> {
    \"                           { yybegin(YYINITIAL); 
                                  return symbol(sym.STRING_LITERAL, string.toString()); }
    {StringSimple}+              { string.append(yytext()); }
    "\\n"                        { string.append('\n'); }
    "\\t"                        { string.append('\t'); }
    "\\r"                        { string.append('\r'); }
    "\\\\"                       { string.append('\\'); }
    "\\\""                       { string.append('\"'); }
    {LineTerminator}             { reportError("String sin cerrar"); 
                                  yybegin(YYINITIAL); }
}

/* Manejo de caracteres */
<CHAR> {
    {CaracterSimple}\'           { yybegin(YYINITIAL); 
                                  return symbol(sym.CHAR_LITERAL, yytext().charAt(0)); }
    \'                           { reportError("Caracter vacío"); 
                                  yybegin(YYINITIAL); }
    {LineTerminator}             { reportError("Caracter sin cerrar"); 
                                  yybegin(YYINITIAL); }
}

/* Manejo de errores */
[^]                              { 
                                  reportError("Caracter ilegal: '" + yytext() + "'"); 
                                }