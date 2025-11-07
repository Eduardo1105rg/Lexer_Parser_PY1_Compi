
/* Esta es la seccion de encabezados u configuracion: eso de la directiva cup podria dar problemas. */
package lexer;
import java_cup.runtime.*;
import java.io.*;
import parser.sym;

import simbolos.TablaIdentificadores;
import simbolos.TablaLiterales;


/**
 * Analizador lexico jflex tomando en cuenta gramatica propia
 */
%%


%class Lexer
%public
%unicode
%cup
%line   /* Estos de aqui son los que nos ayudan a la hora de saber en que posicion esta un token. */
%column

/* Esta es la parte de los codigos de usuario */
%{

    // Tablas de simbolos, aunque todavia no estamos seguros de si esto deberia hacerse asi.
    // public TablaIdentificadores tablaIdentificadores = new TablaIdentificadores();
    // public TablaLiterales tablaLiterales = new TablaLiterales();

    private int errorContador = 0; // Contador de errores lexicos
    StringBuffer string = new StringBuffer(); // De la parte original
    
    public int getErrorContador() { return errorContador; }
    public void incrementarErrorContador() { errorContador++; }
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
        incrementarErrorContador();
        System.err.println("Error lexico en linea " + (yyline + 1) + ", columna " + (yycolumn + 1) + ": " + message);
    }

    // Para reportes especificos de errores
    private Symbol symbolError(String message) {
        reportError(message);
        return new Symbol(sym.ERROR, yyline + 1, yycolumn + 1, message);
    }
%}


/* Definicion de macros: En esta parte va todo lo que es definido con expresiones regulares*/
LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
WhiteSpace     = {LineTerminator} | [ \t\f]

/* comentarios */
ComentarioLinea    = \|[^\n\r]*  
ComentarioBloque   = \¡([^¡]|\n|\r)*\! /* >> Se tiene que corregir esta, no funciona cuando son varias lineas */

Entero = 0 | [-]?[1-9][0-9]*
EnteroPositivo = [1-9][0-9]* | 0
// Flotante = [-]?(0\.0) | [-]?0\.[0-9]*[1-9]+ | [-]?[1-9][0-9]*\.([0-9]*[1-9]+|0) /* >> Se tiene que corregir esta, no acepta negativos */
Flotante = -?( (0\.0) | (0\.[0-9]*[1-9]+) | ([1-9][0-9]*\.([0-9]*[1-9]+|0)) )

/* Identificadores */
Identificador = [a-zA-Z][a-zA-Z0-9_]* /* >> Se tiene que corregir esta: No acepta un guion al inicio */

/* Caracteres especiales para strings y chars */
CaracterSimple = [^'\n\r\t]
StringSimple = [^\n\r\"\\]+  

%state STRING
%state CHAR

%%

/* Palabras reservadas definidas System.out.println("Token: LET, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1));*/

<YYINITIAL> "let"                { System.out.println("Token: let, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.LET); }
<YYINITIAL> "global"             { System.out.println("Token: global, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.GLOBAL); }
<YYINITIAL> "void"               { System.out.println("Token: void, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.VOID); }
<YYINITIAL> "principal"          { System.out.println("Token: principal, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.PRINCIPAL); }
<YYINITIAL> "decide"             { System.out.println("Token: decide, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.DECIDE); }
<YYINITIAL> "of"                 { System.out.println("Token: of, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.OF); }
<YYINITIAL> "else"               { System.out.println("Token: else, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.ELSE); }
<YYINITIAL> "end"                { System.out.println("Token: end, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.END); }
<YYINITIAL> "loop"               { System.out.println("Token: loop, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.LOOP); }
<YYINITIAL> "exit"               { System.out.println("Token: exit, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.EXIT); }
<YYINITIAL> "when"               { System.out.println("Token: when, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.WHEN); }
<YYINITIAL> "for"                { System.out.println("Token: for, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.FOR); }
<YYINITIAL> "step"               { System.out.println("Token: step, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.STEP); }
<YYINITIAL> "to"                 { System.out.println("Token: to, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.TO); }
<YYINITIAL> "downto"             { System.out.println("Token: downto, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.DOWNTO); }
<YYINITIAL> "do"                 { System.out.println("Token: do, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.DO); }
<YYINITIAL> "return"             { System.out.println("Token: return, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.RETURN); }
<YYINITIAL> "break"              { System.out.println("Token: break, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.BREAK); }
<YYINITIAL> "output"             { System.out.println("Token: output, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.OUTPUT); }
<YYINITIAL> "input"              { System.out.println("Token: input, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.INPUT); }
<YYINITIAL> "true"               { System.out.println("Token: true, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.TRUE, Boolean.TRUE); } 
<YYINITIAL> "false"              { System.out.println("Token: false, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.FALSE, Boolean.FALSE); } 

{Flotante}                   { 
    try {
        Double valor = Double.parseDouble(yytext());
        // tablaLiterales.agregarElemento(valor, "float", yyline + 1, yycolumn + 1); 
        System.out.println("Token: FLOAT_LITERAL, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); 
        return symbol(sym.FLOAT_LITERAL, valor);
    } catch (NumberFormatException e) {
        return symbolError("Numero flotante mal formado: " + yytext());
    }
}
{Entero}                     { 
    try {
        Integer valor = Integer.parseInt(yytext());
        // tablaLiterales.agregarElemento(valor, "int", yyline + 1, yycolumn + 1); 
        System.out.println("Token: INT_LITERAL, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); 
        return symbol(sym.INT_LITERAL, valor);
    } catch (NumberFormatException e) {
        return symbolError("Numero entero mal formado: " + yytext());
    }
}

/* Tipos de datos */
<YYINITIAL> "int"                { System.out.println("Token: int, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.INT); }
<YYINITIAL> "float"              { System.out.println("Token: float, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.FLOAT); }
<YYINITIAL> "boolean"            { System.out.println("Token: boolean, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.BOOLEAN); }
<YYINITIAL> "char"               { System.out.println("Token: char, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.CHAR); }
<YYINITIAL> "string"             { System.out.println("Token: string, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.STRING); }

<YYINITIAL> {
    /* Strings */
    \"                           { string.setLength(0); yybegin(STRING); }
    
    /* Caracteres */
    \'                           { yybegin(CHAR); }
    
    /* Operadores aritmeticos */
    "*"                          { System.out.println("Token: MULTIPLICACION, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.MULTIPLICACION); }
    "/"                          { System.out.println("Token: DIVISION, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.DIVISION); }
    "//"                         { System.out.println("Token: DIVISION_ENTERA, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.DIVISION_ENTERA); }
    "%"                          { System.out.println("Token: MODULO, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.MODULO); }
    "^"                          { System.out.println("Token: POTENCIA, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.POTENCIA); }
    "++"                         { System.out.println("Token: INCREMENTO, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.INCREMENTO); }
    "--"                         { System.out.println("Token: DECREMENTO, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.DECREMENTO); }
    "+"                          { System.out.println("Token: MAS, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.MAS); }
    "-"                          { System.out.println("Token: MENOS, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.MENOS); }

    /* Operadores relacionales */
    "=="                         { System.out.println("Token: IGUAL, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.IGUAL); }
    "!="                         { System.out.println("Token: DIFERENTE, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.DIFERENTE); }
    "<="                         { System.out.println("Token: MENOR_IGUAL, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.MENOR_IGUAL); }
    ">="                         { System.out.println("Token: MAYOR_IGUAL, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.MAYOR_IGUAL); }
    "<"                          { System.out.println("Token: MENOR, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.MENOR); }
    ">"                          { System.out.println("Token: MAYOR, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.MAYOR); }

    /* Operadores logicos */
    "@"                          { System.out.println("Token: AND, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.AND); }
    "~"                          { System.out.println("Token: OR, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.OR); }
    "Σ"                          { System.out.println("Token: NOT, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.NOT); }
    
    /* Asignacion */
    "="                          { System.out.println("Token: ASIGNACION, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.ASIGNACION); }
    
    /* Delimitadores y separadores */
    "$"                          { System.out.println("Token: DELIMITADOR, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.DELIMITADOR); }
    ","                          { System.out.println("Token: COMA, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.COMA); } 
    /* ";"                          { return symbol(sym.SEMICOLON); } Me parece que no esta definido en la gramatica original.*/
    
    /* Parentesis especiales para operaciones () */
    "є"                          { System.out.println("Token: PAREN_I, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); System.out.println("\nLexema: " + yytext() + " code: " + (int)yytext().charAt(0)); return symbol(sym.PAREN_I); }
    "э"                          { System.out.println("Token: PAREN_D, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); System.out.println("\nLexema: " + yytext() + " code: " + (int)yytext().charAt(0)); return symbol(sym.PAREN_D);  }
    
    /* Estos son los que se usan para el manejo de listas */
    "["                          { System.out.println("Token: CORCHETE_I, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.CORCHETE_I); } 
    "]"                          { System.out.println("Token: CORCHETE_D, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.CORCHETE_D); } 

    /* Los que seria para abrir y cerrar bloques o sentencias. */
    "¿"                          { System.out.println("Token: LLAVE_I, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); System.out.println("\nLexema: " + yytext() + " code: " + (int)yytext().charAt(0)); return symbol(sym.LLAVE_I); }
    "?"                          { System.out.println("Token: LLAVE_D, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); System.out.println("\nLexema: " + yytext() + " code: " + (int)yytext().charAt(0)); return symbol(sym.LLAVE_D); }
    
    /* Flecha para condiciones */
    "->"                         { System.out.println("Token: FLECHA, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.FLECHA); }
    
    /* Output concatenacion */
    "<<"                         { System.out.println("Token: CONCATENACION_OUTPUT, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.CONCATENACION_OUTPUT); }
    
    /* Identificadores */
    {Identificador}              {  System.out.println("Token: identificador, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.IDENTIFICADOR, yytext()); }

    /* Esta parte de aqui es de la seccion original, creo que se tiene que borrar o revisar */
    /* Comentarios */
    {ComentarioLinea}                { /* ignorar */ }
    {ComentarioBloque}               { /* ignorar */ }
    
    /* Espacios en blanco */
    {WhiteSpace}                 { /* ignorar */ }
}

/* manejo de strings */
<STRING> {
    \"                           { 
        String valor = string.toString();
        // tablaLiterales.agregarElemento(valor, "string", yyline + 1, yycolumn + 1); 
        System.out.println("Token: STRING_LITERAL, Lexema: \"" + valor + "\", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); 
        yybegin(YYINITIAL); 
        return symbol(sym.STRING_LITERAL, valor); 
    }
    [^\"\\\n\r]+                 { string.append(yytext()); }
    "\\n"                        { string.append('\n'); }
    "\\t"                        { string.append('\t'); }
    "\\r"                        { string.append('\r'); }
    "\\\\"                       { string.append('\\'); }
    "\\\""                       { string.append('\"'); }
    {LineTerminator}             { 
        yybegin(YYINITIAL); 
        return symbolError("String sin cerrar antes del final de linea"); 
    }
    <<EOF>>                      { 
        yybegin(YYINITIAL); 
        return symbolError("String sin cerrar al final del archivo"); 
    }
}

/* Manejo de caracteres */
<CHAR> {
    [^'\\\n\r]\'                { 
        char valor = yytext().charAt(0);
        // tablaLiterales.agregarElemento(valor, "char", yyline + 1, yycolumn + 1); 
        System.out.println("Token: CHAR_LITERAL, Lexema: '" + valor + "', Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); 
        yybegin(YYINITIAL); 
        return symbol(sym.CHAR_LITERAL, valor); 
    }
    "\\n"\'                      { 
        // tablaLiterales.agregarElemento('\n', "char", yyline + 1, yycolumn + 1); 
        System.out.println("Token: CHAR_LITERAL, Lexema: '\\n', Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); 
        yybegin(YYINITIAL); 
        return symbol(sym.CHAR_LITERAL, '\n'); 
    }
    "\\t"\'                      { 
        // tablaLiterales.agregarElemento('\t', "char", yyline + 1, yycolumn + 1); 
        System.out.println("Token: CHAR_LITERAL, Lexema: '\\t', Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); 
        yybegin(YYINITIAL); 
        return symbol(sym.CHAR_LITERAL, '\t'); 
    }
    "\\r"\'                      { 
        // tablaLiterales.agregarElemento('\r', "char", yyline + 1, yycolumn + 1); 
        System.out.println("Token: CHAR_LITERAL, Lexema: '\\r', Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); 
        yybegin(YYINITIAL); 
        return symbol(sym.CHAR_LITERAL, '\r'); 
    }
    "\\\\"\'                     { 
        // tablaLiterales.agregarElemento('\\', "char", yyline + 1, yycolumn + 1); 
        System.out.println("Token: CHAR_LITERAL, Lexema: '\\\\', Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); 
        yybegin(YYINITIAL); 
        return symbol(sym.CHAR_LITERAL, '\\'); 
    }
    "\\'"\'                      { 
        // tablaLiterales.agregarElemento('\'', "char", yyline + 1, yycolumn + 1); 
        System.out.println("Token: CHAR_LITERAL, Lexema: '\\'', Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); 
        yybegin(YYINITIAL); 
        return symbol(sym.CHAR_LITERAL, '\''); 
    }
    \'                           {
        yybegin(YYINITIAL); 
        return symbolError("Caracter vacío");
    }
    {LineTerminator}             {
        yybegin(YYINITIAL); 
        return symbolError("Caracter sin cerrar antes del final de línea");
    }
    <<EOF>>                      { 
        yybegin(YYINITIAL); 
        return symbolError("Caracter sin cerrar al final del archivo"); 
    }
}



/* Manejo de errores: Me parece que esta lo que hace es revisar cualquier caracter que no esta registrado o que quede suelto. */
[^] {
    reportError("Caracter no valido en la gramatica: '" + yytext() + "' -> En la linea: " + (yyline + 1) + ", columna: " + (yycolumn + 1));
}
