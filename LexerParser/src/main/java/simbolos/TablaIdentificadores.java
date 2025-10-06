package simbolos;


import java.util.Map;
import java.io.PrintStream;
import java.util.HashMap;


public class TablaIdentificadores {
    public Map<String, IdentificadorInfo> tablaIdentificadores = new HashMap<>();

    public void agregarElemento (String nombre, int linea, int columna) {
        tablaIdentificadores.put(nombre, new IdentificadorInfo(nombre, linea, columna));
    }


    public void imprimirTablaIdentificadores(PrintStream consola) {
        consola.println(">>>> Mostrando la tabla de identificadores:");

        for (IdentificadorInfo elemento : tablaIdentificadores.values()) {
            consola.println("Identificador: " + elemento.nombre + ", Linea: " + elemento.linea + ", Columna: " + elemento.columna);
        }
    }


}
