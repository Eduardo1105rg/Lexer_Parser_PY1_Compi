package simbolos;

import java.util.HashMap;

// Toda esta clase se basa en lo que define en el PDF Lectura_05_-_Tabla_de_Símbolos.pdf.



public class Ambitos {
    private HashMap<String, Token> tabla;
    private Ambitos anterior;


    public Ambitos(Ambitos anterior) {
        this.tabla = new HashMap<>();
        this.anterior = anterior;
        System.out.println(" >> Nuevo Ambito creado.");
    }

    // Insertar un nuevo simbolo en el ambito actual, aqui se una vez validamos que no exista en el entorno actual. [Tambien deberiamos de validar que no existe en la parte de los globales]
    public boolean insertarNuevoToken(Token token) {
        if (tabla.containsKey(token.getNombre())) {
            System.err.println("Error semantico: '" + token.getNombre() + "' ya declarado en este ambito.");
            return false;
        }
        tabla.put(token.getNombre(), token);
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




}
