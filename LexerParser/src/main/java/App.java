
import parser.*;
import lexer.Lexer;

import simbolos.*;
import Codigo_Destino.MIPSGenerator;
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

            // PrintStream out = new PrintStream("tokens.txt"); // COn esto redirigimos la
            // salida de toda la consola hacia el archivo, por eso si debemos
            // System.setOut(out);

            FileReader file = new FileReader(args[0]);
            Lexer lexer = new Lexer(file);
            parser p = new parser(lexer);

            p.parse();

            // p.mostrarTS();

            // Luego de analisis sintactico:
            consolaOriginal.println("Errores lexicos: " + lexer.getErrorContador());
            consolaOriginal.println("Errores sintacticos: " + p.getErrorContador());
            int erroresSemanTicos = p.getCountErroresSemanticos();

            consolaOriginal.println("Errores semanticos: " + erroresSemanTicos);

            int errores = p.getErrorContador() + lexer.getErrorContador();
            if (errores == 0 && erroresSemanTicos == 0) {
                consolaOriginal.println("El archivo fue reconocido por la gramatica.");
                // Pruebas de TAC
                // TAC_Generator.imprimirCuads(consolaOriginal);
                TAC_Generator.imprimirCuadsToFile("tac_output.txt");
                // Imprimimos tabla de simbolos final
                // p.mostrarTS();

                // Generar codigo MIPS
                MIPSGenerator mipsGenerator = new MIPSGenerator();
                mipsGenerator.generarCodigoMIPS();
                mipsGenerator.generar_segmento_data_var_globales();
                mipsGenerator.generar_inicio_segmento_text();
                mipsGenerator.generar_funciones_segmento_text();

                // Prueba del calculo de stack de las funciones.
                // mipsGenerator.analizarFunciones();
                // System.out.println("\n\n" + "");
                // mipsGenerator.mostrar_datos_funciones();

                System.out.println(" Mostrando el codigo MIPS.");
                mipsGenerator.mostrar_codigo_destino_mips();

            } else {
                consolaOriginal.println("El archivo fue analizado con " + (errores + erroresSemanTicos) + " errores.");
            }

        } catch (Exception e) {
            System.out.println("Error durante el analisis sintactico:"); // Esta parte se deberia de cambiar.
            e.printStackTrace();
        } finally {
            utils.ManejoArchivos.cerrar();
        }
    }
}