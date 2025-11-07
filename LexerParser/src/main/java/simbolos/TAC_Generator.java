package simbolos;
import java.io.PrintStream;
import java.util.ArrayList;
import java.util.List;


public class TAC_Generator {
    private static int contadorTemporales = 0;
    private static int contadorEtiquetas = 0;
    public static List<Cuad> cuadGlobales = new ArrayList<>();

    /**
     * Generacion de un temporal nuevo
     * @return temporal nuevo con formato tn, n=contador++
     */
    public static String newTemp () {
        return "t" + (contadorTemporales++);
    }

    /**
     * Generacion de una etiqueta nueva
     * @return etiqueta nueva con formato Ln, n=contador++
     */
    public static String newEtiqueta () {
        return "L" + (contadorEtiquetas++);
    }

    public static void generarCuad (String operador, String argumento1, String argumento2, String resultado) {
        Cuad cuad = new Cuad (operador, argumento1, argumento2, resultado);
        cuadGlobales.add(cuad);
    }

    public static void generarCuadUnario (String operador, String argumento1, String resultado) {
        Cuad cuad = new Cuad (operador, argumento1, null, resultado);
        cuadGlobales.add(cuad);
    }

    public static void generarCuadAsignacion (String argumento1, String resultado) {
        Cuad cuad = new Cuad ("=", argumento1, null, resultado);
        cuadGlobales.add(cuad);
    }

    public static void generarCuadSaltoIncondicional (String etiquetaDestino) {
        Cuad cuad = new Cuad ("GOTO", null, null, etiquetaDestino);
        cuadGlobales.add(cuad);
    }

    public static void generarCuadIfFalse (String temporalCondicion, String etiquetaDestino) {
        Cuad cuad = new Cuad ("IF_FALSE", temporalCondicion, null, etiquetaDestino);
        cuadGlobales.add(cuad);
    }

    public static void generarCuadIf (String temporalCondicion, String etiquetaDestino) {
        Cuad cuad = new Cuad ("IF", temporalCondicion, null, etiquetaDestino);
        cuadGlobales.add(cuad);
    }

    public static void imprimirCuads (PrintStream out) {
        out.println("======== TAC Generado =============");
        for (Cuad cuad : cuadGlobales) {
            out.println(cuad.toString());
        }
    
    }
}