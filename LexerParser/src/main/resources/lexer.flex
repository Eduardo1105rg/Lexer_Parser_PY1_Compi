
/* Esta es la seccion de encabezados u configuracion: eso de la directiva cup podria dar problemas. */
package lexer;
import java_cup.runtime.*;
import java.io.*;
import parser.sym;

import simbolos.TablaIdentificadores;
import simbolos.TablaLiterales;


import java.util.ArrayList;
import java.util.List;
import utils.ErroresInfo;

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
    public TablaIdentificadores tablaIdentificadores = new TablaIdentificadores();
    public TablaLiterales tablaLiterales = new TablaLiterales();

    public List<ErrorInfo> erroresLexicos = new ArrayList<>();// Esto es para almacenar los errores.


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

    // Para el registro de errores
    public void registrarErrorLexico(String mensaje) {
        erroresLexicos.add(new ErrorInfo("LEXICO", yyline + 1, yycolumn + 1, mensaje));
    }

    // Errores lexicos
    public void reportError(String message) {
        System.err.println("Error lexico en linea " + (yyline + 1) + ", columna " + (yycolumn + 1) + ": " + message);
    }

    // Para reportes especificos de errores
    private Symbol symbolError(String message) {
        registrarErrorLexico(message);// Registrar errores en la clase de registro
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
<YYINITIAL> "true"               { tablaLiterales.agregarElemento(Boolean.TRUE, "boolean", yyline + 1, yycolumn + 1); System.out.println("Token: true, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.TRUE, Boolean.TRUE); } 
<YYINITIAL> "false"              { tablaLiterales.agregarElemento(Boolean.FALSE, "boolean", yyline + 1, yycolumn + 1); System.out.println("Token: false, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.FALSE, Boolean.FALSE); } 

/* Tipos de datos */
<YYINITIAL> "int"                { System.out.println("Token: int, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.INT); }
<YYINITIAL> "float"              { System.out.println("Token: float, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.FLOAT); }
<YYINITIAL> "boolean"            { System.out.println("Token: boolean, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.BOOLEAN); }
<YYINITIAL> "char"               { System.out.println("Token: char, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.CHAR); }
<YYINITIAL> "string"             { System.out.println("Token: string, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.STRING); }

<YYINITIAL> {
    /* Literales */
    {Flotante}                   { tablaLiterales.agregarElemento(Double.parseDouble(yytext()), "float", yyline + 1, yycolumn + 1); System.out.println("Token: FLOAT_LITERAL, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.FLOAT_LITERAL, Double.parseDouble(yytext())); }
    {Entero}                     { tablaLiterales.agregarElemento(Integer.parseInt(yytext()), "int", yyline + 1, yycolumn + 1); System.out.println("Token: INT_LITERAL, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.INT_LITERAL, Integer.parseInt(yytext())); }
    {Identificador}              { tablaIdentificadores.agregarElemento(yytext(), yyline + 1, yycolumn + 1); System.out.println("Token: identificador, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.IDENTIFICADOR, yytext()); }
    
    /* Strings */
    \"                           { string.setLength(0); yybegin(STRING); }
    
    /* Caracteres */
    \'                           { yybegin(CHAR); }
    
    /* Operadores aritmeticos */
    "+"                          { System.out.println("Token: MAS, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.MAS); }
    "-"                          { System.out.println("Token: MENOS, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.MENOS); }
    "*"                          { System.out.println("Token: MULTIPLICACION, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.MULTIPLICACION); }
    "/"                          { System.out.println("Token: DIVISION, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.DIVISION); }
    "//"                         { System.out.println("Token: DIVISION_ENTERA, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.DIVISION_ENTERA); }
    "%"                          { System.out.println("Token: MODULO, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.MODULO); }
    "^"                          { System.out.println("Token: POTENCIA, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.POTENCIA); }
    "++"                         { System.out.println("Token: INCREMENTO, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.INCREMENTO); }
    "--"                         { System.out.println("Token: DECREMENTO, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.DECREMENTO); }
    
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
    "є"                          { System.out.println("Token: PAREN_I, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.PAREN_I); }
    "э"                          { System.out.println("Token: PAREN_D, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.PAREN_D); }
    
    /* Estos son los que se usan para el manejo de listas */
    "["                          { System.out.println("Token: CORCHETE_I, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.CORCHETE_I); } 
    "]"                          { System.out.println("Token: CORCHETE_D, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.CORCHETE_D); } 

    /* Los que seria para abrir y cerrar bloques o sentencias. */
    "¿"                          { System.out.println("Token: LLAVE_I, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.LLAVE_I); }
    "?"                          { System.out.println("Token: LLAVE_D, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.LLAVE_D); }
    
    /* Flecha para condiciones */
    "->"                         { System.out.println("Token: FLECHA, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.FLECHA); }
    
    /* Output concatenacion */
    "<<"                         { System.out.println("Token: CONCATENACION_OUTPUT, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); return symbol(sym.CONCATENACION_OUTPUT); }
    

    /* Esta parte de aqui es de la seccion original, creo que se tiene que borrar o revisar */
    /* Comentarios */
    {ComentarioLinea}                { /* ignorar */ }
    {ComentarioBloque}               { /* ignorar */ }
    
    /* Espacios en blanco */
    {WhiteSpace}                 { /* ignorar */ }
}

/* manejo de strings */
<STRING> {
    \"                           { tablaLiterales.agregarElemento(string.toString(), "string", yyline + 1, yycolumn + 1); System.out.println("Token: STRING_LITERAL, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); yybegin(YYINITIAL); return symbol(sym.STRING_LITERAL, string.toString()); } // Esta es la que devuleve el contenido cuando el string se cirra.
    [^\"\\\n\r]+                 { string.append(yytext()); }
    "\\n"                        { string.append('\n'); }
    "\\t"                        { string.append('\t'); }
    "\\r"                        { string.append('\r'); }
    "\\\\"                       { string.append('\\'); }
    "\\\""                       { string.append('\"'); }
    {LineTerminator}             { registrarErrorLexico("String sin cerrar");  symbolError("String sin cerrar"); yybegin(YYINITIAL); }
}

/* Manejo de caracteres */
<CHAR> {
    {CaracterSimple}\'           { tablaLiterales.agregarElemento(yytext().charAt(0), "char", yyline + 1, yycolumn + 1); System.out.println("Token: CHAR_LITERAL, Lexema: " + yytext() + ", Linea: " + (yyline + 1) + ", Columna: " + (yycolumn + 1)); yybegin(YYINITIAL); return symbol(sym.CHAR_LITERAL, yytext().charAt(0)); }

    \'                           { registrarErrorLexico("Caracter vacio");  yybegin(YYINITIAL); return symbolError("Caracter vacio");}

    {LineTerminator}             { registrarErrorLexico("Caracter vacio"); yybegin(YYINITIAL); return symbolError("Caracter sin cerrar");}
}



/* Manejo de errores: Me parece que esta lo que hace es revisar cualquier caracter que no esta registrado o que quede suelto. */
[^] { symbolError("Caracter ilegal: '" + yytext() + "'"); return symbol(sym.ERROR, yytext()); } /* Aqui se reporta el error, captura el token y deja que se continue el proceso. */
