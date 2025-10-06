
import parser.*;
import lexer.Lexer;

import simbolos.*;

import java.io.FileReader;
import java.io.PrintStream;

public class App {
    public static void main(String[] args) {
         if (args.length == 0) {
            System.err.println("Uso: java parser.App <archivo_fuente>");
            System.exit(1);
        }

        try {

            // Esto es para registrar los tokens y lexemas en un archivo.

            PrintStream consolaOriginal = System.out; // Esto es para salvar la conosola 

            PrintStream out = new PrintStream("tokens.txt"); // COn esto redirigimos la salida de toda la consola hacia el archivo, por eso si debemos 
            System.setOut(out);


            FileReader file = new FileReader(args[0]);
            Lexer lexer = new Lexer(file);
            parser p = new parser(lexer);

            p.parse();

            // Luego de analisis sintactico:
            int errores = p.getErrorContador();

            if (errores == 0) {
                System.out.println("El archivo fue reconocido por la gramatica.");
            } else {
                System.out.println("El archivo fue analizado con " + errores + " errores.");
            }
            consolaOriginal.println("El archivo fue reconocido por la gramatica.");

            // Esta es la parte para mostrar las tablas de simbolos.
            // lexer.tablaIdentificadores.imprimirTablaIdentificadores(consolaOriginal);
            // lexer.tablaLiterales.imprimirTablaLiterales(consolaOriginal);

        } catch (Exception e) {
            System.out.println("Error durante el análisis sintáctico:"); // Esta parte se deberia de cambiar.
            e.printStackTrace();
        }
    }
}