
import parser.*;
import lexer.Lexer;

import simbolos.*;
import utils.*;
import java.io.FileReader;
import java.io.PrintStream;

public class App {
    public static void main(String[] args) {
         if (args.length == 0) {
            System.err.println("Uso: java parser.App <archivo_fuente>");
            System.exit(1);
        }

        try {

            utils.ManejoArchivos.iniciar("tokens.txt");
            // Esto es para registrar los tokens y lexemas en un archivo.

            PrintStream consolaOriginal = System.out; // Esto es para salvar la conosola 

            // PrintStream out = new PrintStream("tokens.txt"); // COn esto redirigimos la salida de toda la consola hacia el archivo, por eso si debemos 
            // System.setOut(out);


            FileReader file = new FileReader(args[0]);
            Lexer lexer = new Lexer(file);
            parser p = new parser(lexer);

            p.parse();

            p.mostrarTS();

            // Luego de analisis sintactico:
            consolaOriginal.println("Errores lexicos: " + lexer.getErrorContador());
            consolaOriginal.println("Errores sintacticos: " + p.getErrorContador());
            int erroresSemanTicos = p.getCountErroresSemanticos();

            consolaOriginal.println("Errores semanticos: " + erroresSemanTicos);

            int errores = p.getErrorContador() + lexer.getErrorContador();
            if (errores == 0 && erroresSemanTicos == 0) {
                consolaOriginal.println("El archivo fue reconocido por la gramatica.");
                // Pruebas de TAC
                TAC_Generator.imprimirCuads(consolaOriginal);
                TAC_Generator.imprimirCuadsToFile("tac_output.txt");
                // Imprimimos tabla de simbolos final
                p.mostrarTS();
            } else {
                consolaOriginal.println("El archivo fue analizado con " + (errores+erroresSemanTicos) + " errores.");
            }

            // p.mostrarTablaSimbolos();

            // Esta es la parte para mostrar las tablas de simbolos.
            // lexer.tablaIdentificadores.imprimirTablaIdentificadores(consolaOriginal);
            // lexer.tablaLiterales.imprimirTablaLiterales(consolaOriginal);

        } catch (Exception e) {
            System.out.println("Error durante el analisis sintactico:"); // Esta parte se deberia de cambiar.
            e.printStackTrace();
        } finally {
            utils.ManejoArchivos.cerrar();
        }
    }
}