
/* Esta es la seccion de encabezados u configuracion: eso de la directiva cup podria dar problemas. */
package lexer;
import java_cup.runtime.*;
import java.io.*;
import parser.sym;


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
        System.err.println("Error lexico en linea " + (yyline + 1) + ", columna " + (yycolumn + 1) + ": " + message);
    }
%}


/* Definicion de macros: En esta parte va todo lo que es definido con expresiones regulares*/
LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
WhiteSpace     = {LineTerminator} | [ \t\f]

/* comentarios */
ComentarioLinea    = \|[^\n\r]*  
ComentarioBloque   = \¡([^¡]|\n|\r)*\!

Entero = 0 | [-]?[1-9][0-9]*
EnteroPositivo = [1-9][0-9]* | 0
Flotante = (0\.0) | [-]?0\.[0-9]*[1-9]+ | [-]?[1-9][0-9]*\.([0-9]*[1-9]+|0)

/* Identificadores */
Identificador = [a-zA-Z][a-zA-Z0-9_]*

/* Caracteres especiales para strings y chars */
CaracterSimple = [^'\n\r\t]
StringSimple = [^\n\r\"\\]+  

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
<YYINITIAL> "true"               { return symbol(sym.TRUE, Boolean.TRUE); } 
<YYINITIAL> "false"              { return symbol(sym.FALSE, Boolean.FALSE); } 

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
    {Identificador}                 { return symbol(sym.IDENTIFICADOR, yytext()); }
    
    /* Strings */
    \"                           { string.setLength(0); yybegin(STRING); }
    
    /* Caracteres */
    \'                           { yybegin(CHAR); }
    
    /* Operadores aritmeticos */
    "+"                          { return symbol(sym.MAS); }
    "-"                          { return symbol(sym.MENOS); }
    "*"                          { return symbol(sym.MULTIPLICACION); }
    "/"                          { return symbol(sym.DIVISION); }
    "//"                         { return symbol(sym.DIVISION_ENTERA); }
    "%"                          { return symbol(sym.MODULO); }
    "^"                          { return symbol(sym.POTENCIA); }
    "++"                         { return symbol(sym.INCREMENTO); }
    "--"                         { return symbol(sym.DECREMENTO); }
    
    /* Operadores relacionales */
    "=="                         { return symbol(sym.IGUAL); }
    "!="                         { return symbol(sym.DIFERENTE); }
    "<="                         { return symbol(sym.MENOR_IGUAL); }
    ">="                         { return symbol(sym.MAYOR_IGUAL); }
    "<"                          { return symbol(sym.MENOR); }
    ">"                          { return symbol(sym.MAYOR); }
    
    /* Operadores logicos */
    "@"                          { return symbol(sym.AND); }
    "~"                          { return symbol(sym.OR); }
    "Σ"                          { return symbol(sym.NOT); }
    
    /* Asignacion */
    "="                          { return symbol(sym.ASIGNACION); }
    
    /* Delimitadores y separadores */
    "$"                          { return symbol(sym.DELIMITADOR); }
    ","                          { return symbol(sym.COMA); } 
    /* ";"                          { return symbol(sym.SEMICOLON); } Me parece que no esta definido en la gramatica original.*/
    
    /* Parentesis especiales para operaciones () */
    "є"                          { return symbol(sym.PAREN_I); }
    "э"                          { return symbol(sym.PAREN_D); }
    
    /* Estos son los que se usan para el manejo de listas */
    "["                          { return symbol(sym.CORCHETE_I); } 
    "]"                          { return symbol(sym.CORCHETE_D); } 

    /* Los que seria para abrir y cerrar bloques o sentencias. */
    "¿"                          { return symbol(sym.LLAVE_I); }
    "?"                          { return symbol(sym.LLAVE_D); }
    
    /* Flecha para condiciones */
    "->"                         { return symbol(sym.FLECHA); }
    
    /* Output concatenaCion */
    "<<"                         { return symbol(sym.CONCATENACION_OUTPUT); }
    

    /* Esta parte de aqui es de la seccion original, creo que se tiene que borrar o revisar */
    /* Comentarios */
    {ComentarioLinea}                { /* ignorar */ }
    {ComentarioBloque}               { /* ignorar */ }
    
    /* Espacios en blanco */
    {WhiteSpace}                 { /* ignorar */ }
}

/* manejo de strings */
<STRING> {
    \"                           { yybegin(YYINITIAL); return symbol(sym.STRING_LITERAL, string.toString()); } // Esta es la que devuleve el contenido cuando el string se cirra.
    [^\"\\\n\r]+                 { string.append(yytext()); }
    "\\n"                        { string.append('\n'); }
    "\\t"                        { string.append('\t'); }
    "\\r"                        { string.append('\r'); }
    "\\\\"                       { string.append('\\'); }
    "\\\""                       { string.append('\"'); }
    {LineTerminator}             { reportError("String sin cerrar"); yybegin(YYINITIAL); }
}

/* Manejo de caracteres */
<CHAR> {
    {CaracterSimple}\'           { yybegin(YYINITIAL); return symbol(sym.CHAR_LITERAL, yytext().charAt(0)); }

    \'                           { reportError("Caracter vacaio");  yybegin(YYINITIAL); }

    {LineTerminator}             { reportError("Caracter sin cerrar");  yybegin(YYINITIAL); }
}



/* Manejo de errores: Me parece que esta lo que hace es revisar cualquier caracter que no esta registrado o que quede suelto. */
[^] { reportError("Caracter ilegal: '" + yytext() + "'"); } /* Aqui se reporta el error, captura el token y deja que se continue el proceso. */
