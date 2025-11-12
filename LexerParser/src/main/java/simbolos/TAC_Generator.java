package simbolos;
import java.io.PrintStream;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Deque;
import java.util.List;

public class TAC_Generator {
    private static int contadorTemporales = 0;
    private static int contadorEtiquetas = 0;
    public static List<Cuad> cuadGlobales = new ArrayList<>();
    /* Pila de buffers para tomar TAC de subbloques
       Ejemplo: cada rama de un decide off
       Fuente para Deque: https://www.geeksforgeeks.org/java/arraydeque-in-java/
       Con esto podemos aprovechar la estructura de pila para "saber" si estamos en:
       * Un bloque de sentencias normal (el flujo original)
       * Un sub bloque (una rama de un decide off, un ciclo, etc)
    */

    private static Deque<List<Cuad>> pilaBuffers = new ArrayDeque<>();

    private static void add (Cuad cuad) {
        // Si la pila de buffers es vacia se agrega el cuad a la lista global
        if (pilaBuffers.isEmpty()) {
            cuadGlobales.add(cuad);
        } else {
            // Sino, la agregamos al buffer
            pilaBuffers.peek().add(cuad);
        }
    }

    public static void iniciarBuffer () {
        pilaBuffers.push(new ArrayList<>());
    }

    public static List<Cuad> finalizarBuffer () {
        // Si la pila de buffers esta vacia, retornamos una lista vacia
        return pilaBuffers.isEmpty() ? new ArrayList<>() : pilaBuffers.pop();
    }

    public static void unir (List<Cuad> cuads) {
        if (cuads == null || cuads.isEmpty())
            return;
        cuadGlobales.addAll(cuads);
    }

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
        add(cuad);
    }

    public static void generarCuadUnario (String operador, String argumento1, String resultado, String tipo) {
        // Para Post ++ o Post --
        // Convertimos ++a o --a en una suma o resta a 1
        String argumento2 = null;
        if (tipo.equals("int")) {
            argumento2 = "1";
        } else if (tipo.equals("float")) {
            argumento2 = "1.0";
        }
        // Luego de normalizar el arg 2:
        if (operador.equals("++")) {
            operador = "+";
        } else if (operador.equals("--")) {
            operador = "-";
        } else if (operador.equals("NEG")) { // No se aun como voy a representar la negación
            // Para el caso de negacion unaria
            operador = "NEG"; // aqui podria hacer el cambio de signo
            argumento2 = null; // No se usa en la negación
        }
        Cuad cuad = new Cuad (operador, argumento1, argumento2, resultado);
        add(cuad);
    }

    public static void generarCuadAsignacion (String argumento1, String resultado) {
        Cuad cuad = new Cuad ("=", argumento1, null, resultado);
        add(cuad);
    }

    public static void generarCuadSaltoIncondicional (String etiquetaDestino) {
        Cuad cuad = new Cuad ("GOTO", null, null, etiquetaDestino);
        add(cuad);
    }

    public static void generarCuadIfFalse (String temporalCondicion, String etiquetaDestino) {
        Cuad cuad = new Cuad ("IF_FALSE", temporalCondicion, null, etiquetaDestino);
        add(cuad);
    }

    public static void generarCuadIf (String temporalCondicion, String etiquetaDestino) {
        Cuad cuad = new Cuad ("IF", temporalCondicion, null, etiquetaDestino);
        add(cuad);
    }

    public static void generarLabel(String label) {
        Cuad cuad = new Cuad("LABEL", null, null, label);
        add(cuad);
    }

    public static void generarBeginFunc(String nombre) {
        Cuad cuad = new Cuad("FUNC_BEGIN", nombre, null, null);
        add(cuad);
    }

    public static void generarEndFunc(String nombre) {
        Cuad cuad = new Cuad("FUNC_END", nombre, null, null);
        add(cuad);
    }

    public static void generarParam(String valor) {
        Cuad cuad = new Cuad("PARAM", valor, null, null);
        add(cuad);
    }

    // PopParam: Manejo de parámetros para funciones
    public static void generarPopParam(int index, String id) {
        Cuad cuad = new Cuad("POP_PARAM", Integer.toString(index), null, id);
        add(cuad);
    }

    public static void generarCall(String nombre, int nargs, String destino) {
        Cuad cuad = new Cuad("CALL", nombre, Integer.toString(nargs), destino);
        add(cuad);
    }
    // Generacion para listas
    public static void generarAlloc(String id, String tipo, int tam) {
        Cuad c = new Cuad("ALLOC", tipo, Integer.toString(tam), id);
        add(c);
    }

    public static String generarGet(String id, String idxTemp) {
        // idxtemp es el index temporal
        String t = newTemp();
        Cuad c = new Cuad("GET", id, idxTemp, t);
        add(c);
        return t;
    }

    public static void generarSet(String id, String idxTemp, String valor) {
        Cuad c = new Cuad("SET", id, idxTemp, valor);
        add(c);
    }
    // Fin de listas

    // No sé si realmete se ocupe generar un retorno pero por si acaso lo dejamo
    public static void generarReturn(String valor) {
        Cuad cuad = new Cuad("RET", valor, null, null);
        add(cuad);
    }

    public static void generarPrint (String valor) {
        Cuad cuad = new Cuad ("PRINT", valor, null, null);
        add(cuad);
    }

    public static void generarRead (String tipo, String destino) {
        Cuad cuad = new Cuad ("READ", tipo, null, destino);
        add(cuad);
    }

    public static String getUltimaEtiqueta () {
        List<Cuad> lista = pilaBuffers.isEmpty() ? cuadGlobales : pilaBuffers.peek();
        for (int i = lista.size() - 1; i >= 0; i--) {
            Cuad q = lista.get(i);
            if ("LABEL".equals(q.operador)) return q.resultado;
        }
        return null;
    }

    public static void imprimirCuads (PrintStream out) {
        out.println("======== TAC Generado =============");
        // Escribir en archivo el resultado TAC:
        for (Cuad cuad : cuadGlobales) {
            out.println(cuad.toString());
        }
    
    }

    public static String imprimirCuadsToFile(String rutaArchivo) {
        StringBuilder sb = new StringBuilder();
        sb.append("======== TAC Generado =============\n");
        for (Cuad cuad : cuadGlobales) {
            sb.append(cuad.toString()).append('\n');
        }
        try (PrintStream ps = new PrintStream(rutaArchivo, "UTF-8")) {
            ps.print(sb.toString());
        } catch (Exception e) {
            System.err.println("Error al escribir TAC en archivo: " + e.getMessage());
        }
        return sb.toString();
    }
}