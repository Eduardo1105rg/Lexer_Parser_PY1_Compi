
import parser.*;

import lexer.Lexer;
import java.io.FileReader;

public class App {
    public static void main(String[] args) {
         if (args.length == 0) {
            System.err.println("Uso: java parser.App <archivo_fuente>");
            System.exit(1);
        }

        try {
            FileReader file = new FileReader(args[0]);
            Lexer lexer = new Lexer(file);
            parser p = new parser(lexer);

            p.parse();
            System.out.println("El archivo fue reconocido por la gramatica.");
        } catch (Exception e) {
            System.err.println("Error durante el análisis sintáctico:");
            e.printStackTrace();
        }
    }
}
