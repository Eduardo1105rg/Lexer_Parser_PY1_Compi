package simbolos;

import java.util.HashMap;
import java.util.LinkedHashMap;


// Toda esta clase se basa en lo que define en el PDF Lectura_05_-_Tabla_de_Símbolos.pdf.



public class Ambitos {
    private HashMap<String, Token> tabla;
    private Ambitos anterior;


    public Ambitos(Ambitos anterior) {
        this.tabla = new LinkedHashMap<>();
        this.anterior = anterior;
        System.out.println(" \n>> Nuevo Ambito creado. \n");
    }

    // Insertar un nuevo simbolo en el ambito actual, aqui se una vez validamos que no exista en el entorno actual. [Tambien deberiamos de validar que no existe en la parte de los globales]
    // public boolean insertarNuevoToken(Token token) {
    //     if (tabla.containsKey(token.getNombre())) {
    //         System.err.println("Error semantico: '" + token.getNombre() + "' ya declarado en este ambito.");
    //         return false;
    //     }
    //     tabla.put(token.getNombre(), token);
    //     System.out.println(" \n>> Insertado token: " + token.getNombre() + " tipo: " + token.getTipo());
    //     return true;
    // }
    public boolean insertarNuevoToken(Token token) { // Aqui se supone que ya deberiamos de cubrir los ambitos anteriores tambien.
        for (Ambitos ambito = this; ambito != null; ambito = ambito.anterior) {
            if (ambito.tabla.containsKey(token.getNombre())) {
                System.err.println("Error semantico: '" + token.getNombre() + "' ya declarado en un ambito superior.");
                return false;
            }
        }
        tabla.put(token.getNombre(), token);
        System.out.println(">> Insertado token: " + token.getNombre() + " tipo: " + token.getTipo());
        return true;
    }

    // Busca un simbolo en el ambito (incluyendo a los que contienen a ese ambito) al que pertenece ese simbolo
    public Token buscar(String nombre) {
        for (Ambitos ambito = this; ambito != null; ambito = ambito.anterior) {
            if (ambito.tabla.containsKey(nombre)) return ambito.tabla.get(nombre);
        }
        return null;
    }

    // Acceder a la tabla de simbolo de forma completa
    public HashMap<String, Token> getTablaActual() {
        return tabla;
    }

    // Acceso al entorno al ambito anterior, lo que seria el padre.
    public Ambitos getAnterior() {
        return anterior;
    }


    // Funcion para mostrar todos los ambitos asociados a un token junto con lo tokens que ete tenga.
    public void mostrarTodosLosAmbitosAuxiliar(Ambitos ambito, String nombreAmbito, int nivel) {
        if (ambito == null) return;

        // Podemos agregar una validacion para el caso de que sea un bloque no mostrar los datos del nombre.
        // if (nombreAmbito == "bloque" || nombreAmbito == "bloqueError") {

            System.out.println("\n>> Ambito " + nombreAmbito + " con " + ambito.getTablaActual().size() + " tokens. \n");
        // }

        for (Token t : ambito.getTablaActual().values()) {
            System.out.printf("|| %-15s | %-10s | %-10s | %-10s | %-10s | %-5d | %-5d ||\n",
                    t.nombre, t.tipo, t.categoria,
                    nombreAmbito, String.valueOf(t.valor),
                    t.linea, t.columna);

            // Si este token es una función y tiene ambito local asociado, lo mostramos recursivamente
            // if ("funcion".equals(t.categoria) && t.ambitoLocal != null) {
            //     mostrarTodosLosAmbitosAuxiliar(t.ambitoLocal, nombreAmbito + "->Func_" + t.nombre, nivel + 1);
            // }
            if (t.ambitoLocal != null) {
                String subNombre = nombreAmbito + "->" + t.categoria + "_" + t.nombre;
                mostrarTodosLosAmbitosAuxiliar(t.ambitoLocal, subNombre, nivel + 1);
            }
        }
    }

    // Funcion para mostrar todos los ambitos registrados en el entorno actual, se usa la funcion auxiliar, para mostrar los datos especificos de cada token.
    public void mostrarTodosLosAmbitos(Ambitos entornoActual) {
        System.out.println("||===========================================================================||");
        System.out.println("||                    TABLA DE SIMBOLOS EN TODOS LOS AMBITOS                 ||");
        System.out.println("||===========================================================================||");
        System.out.printf("|| %-15s | %-10s | %-10s | %-10s | %-10s | %-5s | %-5s ||\n",
                "Nombre", "Tipo", "CategorIa", "Ambito", "Valor", "Linea", "Col");
        System.out.println("||===========================================================================||");

        int nivel = 0;
        for (Ambitos ambito = entornoActual; ambito != null; ambito = ambito.getAnterior()) {
            mostrarTodosLosAmbitosAuxiliar(ambito, "Nivel_" + nivel, nivel);
            nivel++;
        }

        System.out.println("||===========================================================================||");
    }

    


}
